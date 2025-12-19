const { MVSF         } = require ('@metaversalcorp/mvsf');
const { InitSQL      } = require ('./utils.js');
const Settings      = require ('./settings.json');
const fs            = require ('fs');
const path          = require ('path');
const mysql         = require ('mysql2/promise');
const zlib          = require ('zlib');

const { MVSQL_MYSQL  } = require ('@metaversalcorp/mvsql_mysql');

/*******************************************************************************************************************************
**                                                     Main                                                                   **
*******************************************************************************************************************************/

class AuthSimple
{
   constructor ()
   {
   }

   Exec (bREST, sAction, pConn, Session, pData, fnRSP, fn)
   {
      if (sAction == 'login')
         this.#Login (Session, pData, fnRSP, fn);
      else if (sAction == 'logout')
         this.#Logout (Session, pData, fnRSP, fn);
      else
         fnRSP (fn, { nResult: -1 });
   }

   #Login (Session, pData, fnRSP, fn)
   {
      let pResult = { nResult: -1 };

      if (pData && pData.acToken64U_RP1 == Settings.MVSF.key)
      {
         pResult.nResult           = 0;
         pResult.sSessionToken     = Settings.MVSF.key;

         Session.twRPersonaIx      = 1;
      }

      fnRSP (fn, pResult);
   }

   #Logout (Session, pData, fnRSP, fn)
   {
      Session.twRPersonaIx     = 0;
      
      fnRSP (fn, { nResult: 0 });
   }
}

class MVSF_Map
{
   #pServer;
   #pSQL;

   constructor ()
   {
      this.ReadFromEnv (Settings.SQL.config, [ "host", "port", "user", "password", "database" ]);
      this.ProcessFabricConfig ();

      switch (Settings.SQL.type)
      {
      case 'MYSQL':
         this.#pSQL = new MVSQL_MYSQL (Settings.SQL.config, this.onSQLReady.bind (this));
         break;

      default:
         console.log ('No Database was configured for this service.');
         break;
      }
   }

   #GetToken (sToken)
   {
      const match = sToken.match (/<([^>]+)>/);
      return match ? match[1] : null;
   }

   ReadFromEnv (Config, aFields)
   {
      let sValue;

      for (let i=0; i < aFields.length; i++)
      {
         if ((sValue = this.#GetToken (Config[aFields[i]])) != null)
            Config[aFields[i]] = process.env[sValue];
      }
   }

   ProcessFabricConfig ()
   {
      const sFabricPath = path.join (__dirname, 'web', 'public', 'config', 'fabric.msf.json');

      try
      {
         let sContent = fs.readFileSync (sFabricPath, 'utf8');

         // Replace all occurrences of <PUBLIC_DOMAIN> with the actual environment variable
         // Check for PUBLIC_DOMAIN first, fallback to RAILWAY_PUBLIC_DOMAIN for Railway compatibility
         const sPublicDomain = process.env.PUBLIC_DOMAIN || process.env.RAILWAY_PUBLIC_DOMAIN || '';
         sContent = sContent.replace (/<PUBLIC_DOMAIN>/g, sPublicDomain);

         fs.writeFileSync (sFabricPath, sContent, 'utf8');
      }
      catch (err)
      {
         console.log ('Error processing fabric.msf.json: ', err);
      }
   }

   #ParseSQLWithDelimiters (sSQLContent)
   {
      const aStatements = [];
      let sCurrentDelimiter = ';';
      const aLines = sSQLContent.split (/\r?\n/);
      let sCurrentStatement = '';

      for (let i = 0; i < aLines.length; i++)
      {
         const sLine = aLines[i];
         const sTrimmedLine = sLine.trim ();

         // Check for DELIMITER command (must be at start of line, case-insensitive)
         const nDelimiterMatch = sTrimmedLine.match (/^DELIMITER\s+(.+)$/i);

         if (nDelimiterMatch)
         {
            // If we have accumulated a statement, save it before changing delimiter
            if (sCurrentStatement.trim ().length > 0)
            {
               const sStatement = sCurrentStatement.trim ();
               if (!sStatement.match (/^--/))
               {
                  aStatements.push (sStatement);
               }
               sCurrentStatement = '';
            }

            // Update delimiter (remove quotes if present)
            sCurrentDelimiter = nDelimiterMatch[1].trim ().replace (/^['"]|['"]$/g, '');
            // Skip the DELIMITER line itself
            continue;
         }

         // Add line to current statement
         if (sCurrentStatement.length > 0)
         {
            sCurrentStatement += '\n' + sLine;
         }
         else
         {
            sCurrentStatement = sLine;
         }

         // Check if current statement ends with the delimiter
         // We need to check if the delimiter appears at the end (possibly with whitespace)
         const nDelimiterIndex = sCurrentStatement.lastIndexOf (sCurrentDelimiter);
         if (nDelimiterIndex !== -1)
         {
            // Check if delimiter is at the end (allowing for trailing whitespace)
            const sAfterDelimiter = sCurrentStatement.substring (nDelimiterIndex + sCurrentDelimiter.length).trim ();

            // If there's only whitespace or newlines after the delimiter, it's the end of the statement
            if (sAfterDelimiter.length === 0 || /^[\r\n\s]*$/.test (sAfterDelimiter))
            {
               // Extract the statement (without the delimiter)
               const sStatement = sCurrentStatement.substring (0, nDelimiterIndex).trim ();

               if (sStatement.length > 0 && !sStatement.match (/^--/))
               {
                  aStatements.push (sStatement);
               }

               sCurrentStatement = '';
            }
         }
      }

      // Add any remaining statement
      if (sCurrentStatement.trim ().length > 0)
      {
         const sStatement = sCurrentStatement.trim ();
         if (!sStatement.match (/^--/))
         {
            aStatements.push (sStatement);
         }
      }

      return aStatements;
   }

   async InitializeDatabase (pMVSQL)
   {
      const sDatabaseName = 'MVD_RP1_Map';
      const sSQLFile = path.join (__dirname, 'MVD_RP1_Map.sql');
      const sSQLGzFile = path.join (__dirname, 'MVD_RP1_Map.sql.gz');

      try
      {
         // Create a connection without specifying a database, with multipleStatements enabled
         const pConfig = { ...Settings.SQL.config };
         delete pConfig.database; // Remove database from config to connect without it
         pConfig.multipleStatements = true; // Enable multiple statements

         const pConnection = await mysql.createConnection (pConfig);

         // Check if database exists
         const [aRows] = await pConnection.execute (
            `SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = ?`,
            [sDatabaseName]
         );

         if (aRows.length === 0)
         {
            console.log (`Database '${sDatabaseName}' does not exist. Creating and importing...`);

            // Determine which SQL file to use
            let sSQLContent = null;
            if (fs.existsSync (sSQLFile))
            {
               sSQLContent = fs.readFileSync (sSQLFile, 'utf8');
            }
            else if (fs.existsSync (sSQLGzFile))
            {
               const aBuffer = fs.readFileSync (sSQLGzFile);
               sSQLContent = zlib.gunzipSync (aBuffer).toString ('utf8');
            }
            else
            {
               throw new Error (`Neither ${sSQLFile} nor ${sSQLGzFile} found`);
            }

            // Parse SQL respecting DELIMITER statements
            const aStatements = this.#ParseSQLWithDelimiters (sSQLContent);

            console.log (`Parsed ${aStatements.length} SQL statements. Executing...`);

            // Execute each statement
            for (let i = 0; i < aStatements.length; i++)
            {
               const sStatement = aStatements[i];

               // Skip empty statements and comments
               if (!sStatement || sStatement.trim ().length === 0 || sStatement.trim ().match (/^--/))
                  continue;

               try
               {
                  await pConnection.query (sStatement);

                  // Log progress for large imports
                  if ((i + 1) % 50 === 0)
                  {
                     console.log (`Executed ${i + 1}/${aStatements.length} statements...`);
                  }
               }
               catch (err)
               {
                  // Ignore errors for CREATE DATABASE if it already exists
                  if (err.code === 'ER_DB_CREATE_EXISTS' || err.message.includes ('already exists'))
                  {
                     // This is okay, continue
                  }
                  else
                  {
                     console.error (`Error executing statement ${i + 1}/${aStatements.length}:`, err.message);
                     console.error (`Statement preview:`, sStatement.substring (0, 200) + '...');
                     throw err;
                  }
               }
            }

            console.log (`Database '${sDatabaseName}' created and imported successfully.`);
            await this.#ApplyDatabaseUpdates (pConnection, sDatabaseName);
         }
         else
         {
            console.log (`Database '${sDatabaseName}' already exists. Skipping initialization.`);
            await this.#ApplyDatabaseUpdates (pConnection, sDatabaseName);  // NEW

         }

         await pConnection.end ();
      }
      catch (err)
      {
         console.error ('Error initializing database:', err);
         throw err;
      }
   }
   
   // Private helper on the same class
async #ApplyDatabaseUpdates (pConnection, sDatabaseName)
{
   // Switch connection to the target database
   await pConnection.changeUser ({ database: sDatabaseName });

   const sUpdatesDir = path.join (__dirname, 'Update');
   
   if (!fs.existsSync (sUpdatesDir))
   {
      console.log (`No 'Update' directory found. Skipping database updates.`);
      return;
   }

   // Ensure tracking table exists
   await pConnection.query (`
      CREATE TABLE IF NOT EXISTS db_update (
         id INT AUTO_INCREMENT PRIMARY KEY,
         script_name VARCHAR(255) NOT NULL UNIQUE,
         applied_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
   `);

   // Get list of already-applied updates
   const [aAppliedRows] = await pConnection.query (`SELECT script_name FROM db_update`);
   const oApplied = new Set (aAppliedRows.map (r => r.script_name));


   // Get all .sql update files, sorted
   const aFiles = fs.readdirSync (sUpdatesDir)
      .filter (s => s.toLowerCase ().endsWith ('.sql'))
      .sort (); // assumes lexical order = migration order (0001, 0002, ...)

   for (const sFile of aFiles)
   {
      if (oApplied.has (sFile))
      {
         // Already applied
         continue;
      }

      const sFullPath = path.join (sUpdatesDir, sFile);
      console.log (`Applying database update: ${sFile}`);

      const sContent = fs.readFileSync (sFullPath, 'utf8');
      const aStatements = this.#ParseSQLWithDelimiters (sContent);

      for (let i = 0; i < aStatements.length; i++)
      {
         const sStatement = aStatements[i];

         if (!sStatement || sStatement.trim ().length === 0 || sStatement.trim ().match (/^--/))
            continue;

         try
         {
            await pConnection.query (sStatement);
         }
         catch (err)
         {
            console.error (`Error executing update '${sFile}' statement ${i + 1}/${aStatements.length}:`, err.message);
            console.error (`Statement preview:`, sStatement.substring (0, 200) + '...');
            throw err;
         }
      }

      // Record that this update was applied
      await pConnection.query (`INSERT INTO db_update (script_name) VALUES (?)`, [ sFile ]);

      console.log (`Update '${sFile}' applied successfully.`);
   }

   console.log (`Database updates complete.`);
}

   async onSQLReady (pMVSQL, err)
   {
      if (pMVSQL)
      {
         try
         {
            // Initialize database if it doesn't exist
            await this.InitializeDatabase (pMVSQL);

            this.ReadFromEnv (Settings.MVSF, [ "nPort", "key" ]);

            this.#pServer = new MVSF (Settings.MVSF, require ('./handler.json'), __dirname, new AuthSimple (), 'application/json');
            this.#pServer.LoadHtmlSite (__dirname, [ './web/admin', './web/public']);
            this.#pServer.Run ();

            console.log ('SQL Server READY');
            InitSQL (pMVSQL, this.#pServer, Settings.Info);
         }
         catch (initErr)
         {
            console.error ('Error during database initialization:', initErr);
            console.log ('SQL Server Connect Error: ', initErr);
         }
      }
      else
      {
         console.log ('SQL Server Connect Error: ', err);
      }
   }
}

const g_pServer = new MVSF_Map ();

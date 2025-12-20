/*
** Copyright 2025 Metaversal Corporation.
** 
** Licensed under the Apache License, Version 2.0 (the "License"); 
** you may not use this file except in compliance with the License. 
** You may obtain a copy of the License at 
** 
**    https://www.apache.org/licenses/LICENSE-2.0
** 
** Unless required by applicable law or agreed to in writing, software 
** distributed under the License is distributed on an "AS IS" BASIS, 
** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
** See the License for the specific language governing permissions and 
** limitations under the License.
** 
** SPDX-License-Identifier: Apache-2.0
*/

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
      this.#ReadFromEnv (Settings.SQL.config, [ "host", "port", "user", "password", "database" ]);
   }

   async Run ()
   {
      let bResult = await this.#IsDBInstalled ();

      if (bResult == false)
      {
         console.log ('Beginning Install...');
         
         this.#ProcessFabricConfig ();

         await this.#ExecSQL ('MSF_Map.sql', true);
      }

      console.log ('SQL Server Starting...');
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

   #ReadFromEnv (Config, aFields)
   {
      let sValue;

      for (let i=0; i < aFields.length; i++)
      {
         if ((sValue = this.#GetToken (Config[aFields[i]])) != null)
            Config[aFields[i]] = process.env[sValue];
      }
   }

   #ProcessFabricConfig ()
   {
      const sFabricPath = path.join (__dirname, 'web', 'public', 'fabric');

      try
      {
         let sContent = fs.readFileSync (path.join (sFabricPath, 'sample.msf'), 'utf8');

         // Replace all occurrences of <PUBLIC_DOMAIN> with the actual environment variable
         // Check for PUBLIC_DOMAIN first, fallback to RAILWAY_PUBLIC_DOMAIN for Railway compatibility
         const sPublicDomain = process.env.PUBLIC_DOMAIN || process.env.RAILWAY_PUBLIC_DOMAIN || '';
         sContent = sContent.replace (/<PUBLIC_DOMAIN>/g, sPublicDomain);

         fs.writeFileSync (path.join (sFabricPath, 'fabric.msf'), sContent, 'utf8');
      }
      catch (err)
      {
         console.log ('Error processing sample.msf: ', err);
      }
   }

   async #ExecSQL (sFilename, bCreate)
   {
      const sSQLFile = path.join (__dirname, sFilename);
      const pConfig = { ...Settings.SQL.config };
      let pConn;
      
      if (bCreate)
         delete pConfig.database; // Remove database from config to connect without it

      console.log ('SQLExec START (' + sFilename + ')');
     
      try 
      {
         // Create connection
         pConn = await mysql.createConnection (pConfig);

         // Read SQL file asynchronously
         const sSQLContent = fs.readFileSync (sSQLFile, 'utf8');
         let i, j, x, d, a, aStmt = sSQLContent.split ('DELIMITER');

         for (i=0; i<aStmt.length; i++)
         {
            if (i > 0)
            {
               x = aStmt[i].indexOf ('\n', 0) + 1;
               d = aStmt[i].slice (0, x).trim ();

               aStmt[i] = aStmt[i].slice (x);
            }
            else d = ';';

            if (d == ';')
            {
               a = [];
               a[0] = aStmt[i];
            }
            else a = aStmt[i].split (d);

            // Execute SQL

            for (j=0; j<a.length; j++)
               if (a[j].trim () != '')       // optional
                  await pConn.query (a[j]);
         }

         console.log ('SQLExec END (' + sFilename + ')');      
      } 
      catch (err) 
      {
         console.error ('Error executing SQL:', err.message);
      } 
      finally 
      {
         if (pConn) 
         {
            await pConn.end ();
         }
      }
   }

   onSQLReady (pMVSQL, err)
   {
      if (pMVSQL)
      {
         this.#ReadFromEnv (Settings.MVSF, [ "nPort", "key" ]);

         this.#pServer = new MVSF (Settings.MVSF, require ('./handler.json'), __dirname, new AuthSimple (), 'application/json');
         this.#pServer.LoadHtmlSite (__dirname, [ './web/admin', './web/public']);
         this.#pServer.Run ();

         console.log ('SQL Server READY');
         InitSQL (pMVSQL, this.#pServer, Settings.Info);
      }
      else
      {
         console.log ('SQL Server Connect Error: ', err);
      }
   }

   async #IsDBInstalled ()
   {
      const pConfig = { ...Settings.SQL.config };
      let pConn;
      let bResult = false;
      let sDB = pConfig.database;

      delete pConfig.database; // Remove database from config to connect without it
      try 
      {
         // Create connection
         pConn = await mysql.createConnection (pConfig);

         // Check if database exists
         const [aRows] = await pConn.execute (
            `SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = ?`,
            [sDB]
         );

         if (aRows.length !== 0)
         {
            bResult = true;
         }
      } 
      catch (err) 
      {
         console.error ('Error executing SQL:', err.message);
      } 
      finally 
      {
         if (pConn) 
         {
            await pConn.end ();
         }
      }

      return bResult;
   }
}

const g_pServer = new MVSF_Map ();
g_pServer.Run ();

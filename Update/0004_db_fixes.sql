/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : set_RMPObject_RMPObject_Close.sql                                      ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DROP PROCEDURE IF EXISTS set_RMPObject_RMPObject_Close;
DROP PROCEDURE IF EXISTS set_RMTObject_RMPObject_Close;
DROP PROCEDURE IF EXISTS set_RMTObject_RMTObject_Close;
DROP PROCEDURE IF EXISTS set_RMCObject_RMCObject_Close;
DROP PROCEDURE IF EXISTS set_RMCObject_RMTObject_Close;
DROP PROCEDURE IF EXISTS set_RMRoot_RMCObject_Close;
DROP PROCEDURE IF EXISTS set_RMRoot_RMPObject_Close;
DROP PROCEDURE IF EXISTS set_RMRoot_RMTObject_Close;


DELIMITER $$

CREATE PROCEDURE set_RMPObject_RMPObject_Close
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMPObjectIx                 BIGINT,
   IN    twRMPObjectIx_Close           BIGINT,
   IN    bDeleteAll                    TINYINT UNSIGNED,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;
       DECLARE RMPOBJECT_OP_RMPOBJECT_CLOSE               INT DEFAULT 17;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE nCount INT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx        = IFNULL (twRPersonaIx,        0);
           SET twRMPObjectIx       = IFNULL (twRMPObjectIx,       0);
           SET twRMPObjectIx_Close = IFNULL (twRMPObjectIx_Close, 0);
           SET bDeleteAll          = IFNULL (bDeleteAll,          0);

         START TRANSACTION;

          CALL call_RMPObject_Validate (twRPersonaIx, twRMPObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                 SELECT COUNT(*) INTO nCount
                   FROM RMPObject AS o
                  WHERE o.ObjectHead_Parent_wClass     = SBO_CLASS_RMPOBJECT
                    AND o.ObjectHead_Parent_twObjectIx = twRMPObjectIx_Close;

                     IF twRMPObjectIx_Close <= 0
                   THEN
                            CALL call_Error (5, 'twRMPObjectIx_Close is invalid',   nError);
                 ELSEIF bDeleteAll = 0 AND nCount > 0
                   THEN
                            CALL call_Error (6, 'twRMPObjectIx_Close is not empty', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMPObject_Event_RMPObject_Close (twRMPObjectIx, twRMPObjectIx_Close, bError, 0);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (-1, 'Failed to delete RMPObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMPObject_Log (RMPOBJECT_OP_RMPOBJECT_CLOSE, sIPAddress, twRPersonaIx, twRMPObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : set_RMTObject_RMPObject_Close.sql                                      ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMTObject_RMPObject_Close
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    twRMPObjectIx_Close           BIGINT,
   IN    bDeleteAll                    TINYINT UNSIGNED,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;
       DECLARE RMTOBJECT_OP_RMPOBJECT_CLOSE               INT DEFAULT 17;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE nCount INT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx        = IFNULL (twRPersonaIx,        0);
           SET twRMTObjectIx       = IFNULL (twRMTObjectIx,       0);
           SET twRMPObjectIx_Close = IFNULL (twRMPObjectIx_Close, 0);
           SET bDeleteAll          = IFNULL (bDeleteAll,          0);

         START TRANSACTION;

          CALL call_RMTObject_Validate (twRPersonaIx, twRMTObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                 SELECT COUNT(*) INTO nCount
                   FROM RMTObject AS o
                  WHERE o.ObjectHead_Parent_wClass     = SBO_CLASS_RMTOBJECT
                    AND o.ObjectHead_Parent_twObjectIx = twRMPObjectIx_Close;

                     IF twRMPObjectIx_Close <= 0
                   THEN
                            CALL call_Error (5, 'twRMPObjectIx_Close is invalid',   nError);
                 ELSEIF bDeleteAll = 0 AND nCount > 0
                   THEN
                            CALL call_Error (6, 'twRMPObjectIx_Close is not empty', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMTObject_Event_RMPObject_Close (twRMTObjectIx, twRMPObjectIx_Close, bError, 0);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to update RMTObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMTObject_Log (RMTOBJECT_OP_RMPOBJECT_CLOSE, sIPAddress, twRPersonaIx, twRMTObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : set_RMTObject_RMTObject_Close.sql                                      ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMTObject_RMTObject_Close
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    twRMTObjectIx_Close           BIGINT,
   IN    bDeleteAll                    TINYINT UNSIGNED,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE RMTOBJECT_OP_RMTOBJECT_CLOSE               INT DEFAULT 15;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE nCount INT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx        = IFNULL (twRPersonaIx,        0);
           SET twRMTObjectIx       = IFNULL (twRMTObjectIx,       0);
           SET twRMTObjectIx_Close = IFNULL (twRMTObjectIx_Close, 0);
           SET bDeleteAll          = IFNULL (bDeleteAll,          0);

         START TRANSACTION;

          CALL call_RMTObject_Validate (twRPersonaIx, twRMTObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                 SELECT COUNT(*) INTO nCount
                   FROM RMTObject AS o
                  WHERE o.ObjectHead_Parent_wClass     = SBO_CLASS_RMTOBJECT
                    AND o.ObjectHead_Parent_twObjectIx = twRMTObjectIx_Close;

                 SELECT COUNT(*) + nCount INTO nCount
                   FROM RMPObject AS o
                  WHERE o.ObjectHead_Parent_wClass     = SBO_CLASS_RMTOBJECT
                    AND o.ObjectHead_Parent_twObjectIx = twRMTObjectIx_Close;

                     IF twRMTObjectIx_Close <= 0
                   THEN
                            CALL call_Error (5, 'twRMTObjectIx_Close is invalid',   nError);
                 ELSEIF bDeleteAll = 0 AND nCount > 0
                   THEN
                            CALL call_Error (6, 'twRMTObjectIx_Close is not empty', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMTObject_Event_RMTObject_Close (twRMTObjectIx, twRMTObjectIx_Close, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to delete RMTObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMTObject_Log (RMTOBJECT_OP_RMTOBJECT_CLOSE, sIPAddress, twRPersonaIx, twRMTObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : set_RMCObject_RMCObject_Close.sql                                      ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMCObject_RMCObject_Close
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    twRMCObjectIx_Close           BIGINT,
   IN    bDeleteAll                    TINYINT UNSIGNED,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;
       DECLARE RMCOBJECT_OP_RMCOBJECT_CLOSE               INT DEFAULT 12;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE nCount INT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx        = IFNULL (twRPersonaIx,        0);
           SET twRMCObjectIx       = IFNULL (twRMCObjectIx,       0);
           SET twRMCObjectIx_Close = IFNULL (twRMCObjectIx_Close, 0);
           SET bDeleteAll          = IFNULL (bDeleteAll,          0);

         START TRANSACTION;

          CALL call_RMCObject_Validate (twRPersonaIx, twRMCObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                 SELECT COUNT(*) INTO nCount
                   FROM RMCObject AS o
                  WHERE o.ObjectHead_Parent_wClass     = SBO_CLASS_RMCOBJECT
                    AND o.ObjectHead_Parent_twObjectIx = twRMCObjectIx_Close;

                 SELECT COUNT(*) + nCount INTO nCount
                   FROM RMTObject AS o
                  WHERE o.ObjectHead_Parent_wClass     = SBO_CLASS_RMCOBJECT
                    AND o.ObjectHead_Parent_twObjectIx = twRMCObjectIx_Close;

                     IF twRMCObjectIx_Close <= 0
                   THEN
                            CALL call_Error (5, 'twRMCObjectIx_Close is invalid',   nError);
                 ELSEIF bDeleteAll = 0 AND nCount > 0
                   THEN
                            CALL call_Error (6, 'twRMCObjectIx_Close is not empty', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMCObject_Event_RMCObject_Close (twRMCObjectIx, twRMCObjectIx_Close, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to delete RMCObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMCObject_Log (RMCOBJECT_OP_RMCOBJECT_CLOSE, sIPAddress, twRPersonaIx, twRMCObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                       MVD_RP1_Map : set_RMCObject_RMTObject_Close.sql                                      ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMCObject_RMTObject_Close
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    twRMTObjectIx_Close           BIGINT,
   IN    bDeleteAll                    TINYINT UNSIGNED,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE RMCOBJECT_OP_RMTOBJECT_CLOSE               INT DEFAULT 14;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE nCount INT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx        = IFNULL (twRPersonaIx,        0);
           SET twRMCObjectIx       = IFNULL (twRMCObjectIx,       0);
           SET twRMTObjectIx_Close = IFNULL (twRMTObjectIx_Close, 0);
           SET bDeleteAll          = IFNULL (bDeleteAll,          0);

         START TRANSACTION;

          CALL call_RMCObject_Validate (twRPersonaIx, twRMCObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                 SELECT COUNT(*) INTO nCount
                   FROM RMTObject AS o
                  WHERE o.ObjectHead_Parent_wClass     = SBO_CLASS_RMTOBJECT
                    AND o.ObjectHead_Parent_twObjectIx = twRMTObjectIx_Close;

                     IF twRMTObjectIx_Close <= 0
                   THEN
                            CALL call_Error (5, 'twRMTObjectIx_Close is invalid',   nError);
                 ELSEIF bDeleteAll = 0 AND nCount > 0
                   THEN
                            CALL call_Error (6, 'twRMTObjectIx_Close is not empty', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMCObject_Event_RMTObject_Close (twRMCObjectIx, twRMTObjectIx_Close, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to delete RMTObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMCObject_Log (RMCOBJECT_OP_RMTOBJECT_CLOSE, sIPAddress, twRPersonaIx, twRMCObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                        MVD_RP1_Map : set_RMRoot_RMCObject_Close.sql                                        ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMRoot_RMCObject_Close
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMRootIx                    BIGINT,
   IN    twRMCObjectIx_Close           BIGINT,
   IN    bDeleteAll                    TINYINT UNSIGNED,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;
       DECLARE RMROOT_OP_RMCOBJECT_CLOSE                  INT DEFAULT 14;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE nCount INT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx        = IFNULL (twRPersonaIx,        0);
           SET twRMRootIx          = IFNULL (twRMRootIx,          0);
           SET twRMCObjectIx_Close = IFNULL (twRMCObjectIx_Close, 0);
           SET bDeleteAll          = IFNULL (bDeleteAll,          0);

         START TRANSACTION;

          CALL call_RMRoot_Validate (twRPersonaIx, twRMRootIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                 SELECT COUNT(*) INTO nCount
                   FROM RMCObject AS o
                  WHERE o.ObjectHead_Parent_wClass     = SBO_CLASS_RMCOBJECT
                    AND o.ObjectHead_Parent_twObjectIx = twRMCObjectIx_Close;

                     IF twRMCObjectIx_Close <= 0
                   THEN
                            CALL call_Error (5, 'twRMCObjectIx_Close is invalid',   nError);
                 ELSEIF bDeleteAll = 0 AND nCount > 0
                   THEN
                            CALL call_Error (6, 'twRMCObjectIx_Close is not empty', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMRoot_Event_RMCObject_Close (twRMRootIx, twRMCObjectIx_Close, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (-1, 'Failed to delete RMCObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMRoot_Log (RMROOT_OP_RMCOBJECT_CLOSE, sIPAddress, twRPersonaIx, twRMRootIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                        MVD_RP1_Map : set_RMRoot_RMPObject_Close.sql                                        ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMRoot_RMPObject_Close
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMRootIx                    BIGINT,
   IN    twRMPObjectIx_Close           BIGINT,
   IN    bDeleteAll                    TINYINT UNSIGNED,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;
       DECLARE RMROOT_OP_RMPOBJECT_CLOSE                  INT DEFAULT 17;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE nCount INT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx        = IFNULL (twRPersonaIx,        0);
           SET twRMRootIx          = IFNULL (twRMRootIx,          0);
           SET twRMPObjectIx_Close = IFNULL (twRMPObjectIx_Close, 0);
           SET bDeleteAll          = IFNULL (bDeleteAll,          0);

         START TRANSACTION;

          CALL call_RMRoot_Validate (twRPersonaIx, twRMRootIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                 SELECT COUNT(*) INTO nCount
                   FROM RMPObject AS o
                  WHERE o.ObjectHead_Parent_wClass     = SBO_CLASS_RMPOBJECT
                    AND o.ObjectHead_Parent_twObjectIx = twRMPObjectIx_Close;

                     IF twRMPObjectIx_Close <= 0
                   THEN
                            CALL call_Error (5, 'twRMPObjectIx_Close is invalid',   nError);
                 ELSEIF bDeleteAll = 0 AND nCount > 0
                   THEN
                            CALL call_Error (6, 'twRMPObjectIx_Close is not empty', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMRoot_Event_RMPObject_Close (twRMRootIx, twRMPObjectIx_Close, bError, 0);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (-1, 'Failed to delete RMPObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMRoot_Log (RMROOT_OP_RMPOBJECT_CLOSE, sIPAddress, twRPersonaIx, twRMRootIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                        MVD_RP1_Map : set_RMRoot_RMTObject_Close.sql                                        ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                              Copyright 2023-2025 Metaversal Corporation. All rights reserved.                              ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE PROCEDURE set_RMRoot_RMTObject_Close
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMRootIx                    BIGINT,
   IN    twRMTObjectIx_Close           BIGINT,
   IN    bDeleteAll                    TINYINT UNSIGNED,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE RMROOT_OP_RMTOBJECT_CLOSE                  INT DEFAULT 14;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE nCount INT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx        = IFNULL (twRPersonaIx,        0);
           SET twRMRootIx          = IFNULL (twRMRootIx,          0);
           SET twRMTObjectIx_Close = IFNULL (twRMTObjectIx_Close, 0);
           SET bDeleteAll          = IFNULL (bDeleteAll,          0);

         START TRANSACTION;

          CALL call_RMRoot_Validate (twRPersonaIx, twRMRootIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                 SELECT COUNT(*) INTO nCount
                   FROM RMTObject AS o
                  WHERE o.ObjectHead_Parent_wClass     = SBO_CLASS_RMTOBJECT
                    AND o.ObjectHead_Parent_twObjectIx = twRMTObjectIx_Close;

                     IF twRMTObjectIx_Close <= 0
                   THEN
                            CALL call_Error (5, 'twRMTObjectIx_Close is invalid',   nError);
                 ELSEIF bDeleteAll = 0 AND nCount > 0
                   THEN
                            CALL call_Error (6, 'twRMTObjectIx_Close is not empty', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMRoot_Event_RMTObject_Close (twRMRootIx, twRMTObjectIx_Close, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (-1, 'Failed to delete RMTObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMRoot_Log (RMROOT_OP_RMTOBJECT_CLOSE, sIPAddress, twRPersonaIx, twRMRootIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
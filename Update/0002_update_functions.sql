Use MVD_RP1_Map;

DROP FUNCTION IF EXISTS ArcLength;
DROP FUNCTION IF EXISTS DateTime2_Time;
DROP FUNCTION IF EXISTS Date_DateTime2;
DROP FUNCTION IF EXISTS Format_Bound;
DROP FUNCTION IF EXISTS Format_Control;
DROP FUNCTION IF EXISTS Format_Double;
DROP FUNCTION IF EXISTS Format_Double3;
DROP FUNCTION IF EXISTS Format_Double4;
DROP FUNCTION IF EXISTS Format_Float;
DROP FUNCTION IF EXISTS Format_Name_C;
DROP FUNCTION IF EXISTS Format_Name_P;
DROP FUNCTION IF EXISTS Format_Name_R;
DROP FUNCTION IF EXISTS Format_Name_T;
DROP FUNCTION IF EXISTS Format_ObjectHead;
DROP FUNCTION IF EXISTS Format_Orbit_Spin;
DROP FUNCTION IF EXISTS Format_Owner;
DROP FUNCTION IF EXISTS Format_Properties_C;
DROP FUNCTION IF EXISTS Format_Properties_T;
DROP FUNCTION IF EXISTS Format_Resource;
DROP FUNCTION IF EXISTS Format_Transform;
DROP FUNCTION IF EXISTS Format_Type_C;
DROP FUNCTION IF EXISTS Format_Type_P;
DROP FUNCTION IF EXISTS Format_Type_T;
DROP FUNCTION IF EXISTS IPstob;
DROP FUNCTION IF EXISTS IPbtos;
DROP FUNCTION IF EXISTS Time_Current;
DROP FUNCTION IF EXISTS Time_DateTime2;

DELIMITER $$
CREATE FUNCTION ArcLength
(
   dRadius          DOUBLE,

   dX0              DOUBLE,
   dY0              DOUBLE,
   dZ0              DOUBLE,

   dX               DOUBLE,
   dY               DOUBLE,
   dZ               DOUBLE
)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
            -- arc length = 2 * radius * arcsin (distance / (2 * radius))

            -- This function assumes dX0, dY0, and dZ0 have already been normalized to dRadius
            -- Origins in the database sit below the surface and must also be normalized to dRadius

       DECLARE dNormal DOUBLE DEFAULT dRadius / SQRT ((dX * dX) + (dY * dY) + (dZ * dZ));

           SET dX = dX * dNormal;
           SET dY = dY * dNormal;
           SET dZ = dZ * dNormal;

           SET dX = dX - dX0;
           SET dY = dY - dY0;
           SET dZ = dZ - dZ0;

        RETURN (2.0 * dRadius) * ASIN (SQRT ((dX * dX) + (dY * dY) + (dZ * dZ)) / (2.0 * dRadius));
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                              MVD_RP1_Map : DateTime2_Time.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- TIME reports time in 1/64 sec from UTC Jan 1, 1601
-- UNIX reports time in 1/1000 sec from UTC Jan 1, 1970
-- There are  134774 days between UTC Jan 1, 1601 and UTC Jan 1, 1970
-- There are 5529600 1/64 sec per day

-- 134774 * 5529600 = 745246310400

DELIMITER $$

CREATE FUNCTION DateTime2_Time
(
   tmStamp BIGINT
)
RETURNS DATETIME  -- DATETIME values must be in UTC
DETERMINISTIC
BEGIN

      DECLARE dt2 DATETIME;
      DECLARE s BIGINT;
      DECLARE mcs BIGINT;

          SET tmStamp = tmStamp - 745246310400;

          SET s = tmStamp DIV 64;

          SET mcs = tmStamp MOD 64;
          SET mcs = mcs * 1000000;
          SET mcs = mcs DIV 64;

          SET dt2 = DATE_ADD('1970-01-01', INTERVAL s SECOND);
          SET dt2 = DATE_ADD(dt2, INTERVAL mcs MICROSECOND);

       RETURN dt2;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                              MVD_RP1_Map : Date_DateTime2.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- DATETIME2  reports time in 1/10000000 sec from UTC Jan 1, 0001
-- JavaScript reports time in 1/1000     sec from UTC Jan 1, 1970 (Unix Epoch Time)
-- There are  719162 days between Jan 1, 0001 and Jan 1, 1970
-- There are 86400000 1/1000 sec per day

DELIMITER $$

CREATE FUNCTION Date_DateTime2
(
   dtStamp DATETIME  -- DATETIME values must be in UTC and generally generated from UTC_TIMESTAMP()
)
RETURNS BIGINT
DETERMINISTIC
BEGIN
      -- Convert MySQL DATETIME to JavaScript timestamp (milliseconds since Jan 1, 1970)
      -- MySQL's UNIX_TIMESTAMP returns seconds since 1970, so multiply by 1000 for milliseconds
      RETURN UNIX_TIMESTAMP(dtStamp) * 1000;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Format_Bound.sql                                               ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION Format_Bound
(
   dX                      DOUBLE,
   dY                      DOUBLE,
   dZ                      DOUBLE
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "Max": ', Format_Double3 (dX, dY, dZ), ' }');
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                              MVD_RP1_Map : Format_Control.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION Format_Control
(
   Self_wClass             SMALLINT,
   Self_twObjectIx         BIGINT,
   Child_wClass            SMALLINT,
   Child_twObjectIx        BIGINT,
   wFlags                  SMALLINT,
   twEventIz               BIGINT
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT
             (
                '{ "wClass_Object": ', CAST(Self_wClass AS CHAR), 
                ', "twObjectIx": ',    CAST(Self_twObjectIx AS CHAR), 
                ', "wClass_Child": ',  CAST(Child_wClass AS CHAR), 
                ', "twChildIx": ',     CAST(Child_twObjectIx AS CHAR), 
                ', "wFlags": ',        CAST(wFlags AS CHAR), 
                ', "twEventIz": ',     CAST(twEventIz AS CHAR), 
                ' }'
             );
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Format_Double.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION Format_Double
(
   d   DOUBLE
)
RETURNS VARCHAR (32)
DETERMINISTIC
BEGIN

      DECLARE dA      DOUBLE DEFAULT ABS (d);
      DECLARE e       INT DEFAULT 0;
      DECLARE sSign   VARCHAR (1) DEFAULT '';
      DECLARE sExp    VARCHAR (8) DEFAULT '';
      DECLARE sNum    VARCHAR (20) DEFAULT '';

           IF (dA <> d)
         THEN
              SET sSign = '-';
       END IF ;

           IF dA <> 0 AND dA <> 1
         THEN
                    IF dA < 1.0
                  THEN
                          WHILE (dA < POW (10, -e) AND e < 310)
                             DO
                                     SET e = e + 1;
                      END WHILE ;

                            SET dA = dA * POW (10, e);
                            SET sExp = CONCAT ('e-', e);
                ELSEIF dA >= 10.0
                  THEN
                          WHILE (dA >= POW (10, e + 1) AND e < 310)
                             DO
                                     SET e = e + 1;
                      END WHILE ;

                            SET dA = dA * POW (10, -e);
                            SET sExp = CONCAT ('e+', e);
                END IF ;
       END IF ;

           IF (FLOOR (dA) = CEILING (dA))
         THEN
              SET sNum = CAST(dA AS CHAR);
         ELSE 
              SET sNum = FORMAT (dA, 16);
       END IF ;

       RETURN CONCAT (sSign, sNum, sExp);
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                              MVD_RP1_Map : Format_Double3.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION Format_Double3
(
   dX   DOUBLE,
   dY   DOUBLE,
   dZ   DOUBLE
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('[', Format_Double(dX), ',', Format_Double(dY), ',', Format_Double(dZ), ']');
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                              MVD_RP1_Map : Format_Double4.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION Format_Double4
(
   dX   DOUBLE,
   dY   DOUBLE,
   dZ   DOUBLE,
   dW   DOUBLE
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('[', Format_Double(dX), ',', Format_Double(dY), ',', Format_Double(dZ), ',', Format_Double(dW), ']');
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Format_Float.sql                                               ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION Format_Float
(
   d   FLOAT
)
RETURNS VARCHAR (32)
DETERMINISTIC
BEGIN

      DECLARE dA      FLOAT        DEFAULT ABS (d);
      DECLARE e       INT          DEFAULT 0;
      DECLARE sSign   VARCHAR (1)  DEFAULT '';
      DECLARE sExp    VARCHAR (8)  DEFAULT '';
      DECLARE sNum    VARCHAR (20) DEFAULT '';

           IF (dA <> d)
         THEN
                   SET sSign = '-';
       END IF ;

           IF dA <> 0 AND dA <> 1
         THEN
                    IF dA < 1.0
                  THEN
                          WHILE (dA < POW (10, -e) AND e < 310)
                             DO
                                     SET e = e + 1;
                      END WHILE ;

                            SET dA = dA * POW (10, e);
                            SET sExp = CONCAT ('e-', e);

                ELSEIF dA >= 10.0
                  THEN
                          WHILE (dA >= POW (10, e + 1) AND e < 310)
                             DO
                                     SET e = e + 1;
                      END WHILE ;

                            SET dA = dA * POW (10, -e);
                            SET sExp = CONCAT ('e+', e);
                END IF ;
       END IF ;

           IF (FLOOR (dA) = CEILING (dA))
         THEN
                   SET sNum = CAST(dA AS CHAR);
         ELSE 
                   SET sNum = FORMAT (dA, 8);
       END IF ;

       RETURN CONCAT (sSign, sNum, sExp);
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Format_Name_C.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION Format_Name_C
(
   wsRMCObjectId            VARCHAR (48)
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "wsRMCObjectId": "', wsRMCObjectId, '" }');
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Format_Name_P.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION Format_Name_P
(
   wsRMPObjectId            VARCHAR (48)
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "wsRMPObjectId": "', wsRMPObjectId, '" }');
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Format_Name_R.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION Format_Name_R
(
   wsRMRootId            VARCHAR (48)
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "wsRMRootId": "', wsRMRootId, '" }');
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Format_Name_T.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION Format_Name_T
(
   wsRMTObjectId            VARCHAR (48)
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "wsRMTObjectId": "', wsRMTObjectId, '" }');
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                             MVD_RP1_Map : Format_ObjectHead.sql                                            ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION Format_ObjectHead
(
   Parent_wClass           SMALLINT,
   Parent_twObjectIx       BIGINT,
   Self_wClass             SMALLINT,
   Self_twObjectIx         BIGINT,
   wFlags                  SMALLINT,
   twEventIz               BIGINT
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "wClass_Parent": ', CAST(Parent_wClass AS CHAR), ', "twParentIx": ', CAST(Parent_twObjectIx AS CHAR), ', "wClass_Object": ', CAST(Self_wClass AS CHAR), ', "twObjectIx": ', CAST(Self_twObjectIx AS CHAR), ', "wFlags": ', CAST(wFlags AS CHAR), ', "twEventIz": ', CAST(twEventIz AS CHAR), ' }');
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                             MVD_RP1_Map : Format_Orbit_Spin.sql                                            ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION Format_Orbit_Spin
(
   tmPeriod                 BIGINT,
   tmStart                  BIGINT,
   dA                       DOUBLE,
   dB                       DOUBLE
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "tmPeriod": ', CAST(tmPeriod AS CHAR), ', "tmStart": ', CAST(tmStart AS CHAR), ', "dA": ', Format_Double(dA), ', "dB": ', Format_Double(dB), ' }');
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Format_Owner.sql                                               ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION Format_Owner
(
   twRPersonaIx                BIGINT
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "twRPersonaIx": ', CAST(twRPersonaIx AS CHAR), ' }');
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                            MVD_RP1_Map : Format_Properties_C.sql                                           ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION Format_Properties_C
(
   fMass                    FLOAT,
   fGravity                 FLOAT,
   fColor                   FLOAT,
   fBrightness              FLOAT,
   fReflectivity            FLOAT
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "fMass": ', Format_Float(fMass), ', "fGravity": ', Format_Float(fGravity), ', "fColor": ', Format_Float(fColor), ', "fBrightness": ', Format_Float(fBrightness), ', "fReflectivity": ', Format_Float(fReflectivity), ' }');
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                            MVD_RP1_Map : Format_Properties_T.sql                                           ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION Format_Properties_T
(
   bLockToGround            TINYINT UNSIGNED,
   bYouth                   TINYINT UNSIGNED,
   bAdult                   TINYINT UNSIGNED,
   bAvatar                  TINYINT UNSIGNED
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "bLockToGround": ', CAST(bLockToGround AS CHAR), ', "bYouth": ', CAST(bYouth AS CHAR), ', "bAdult": ', CAST(bAdult AS CHAR), ', "bAvatar": ', CAST(bAvatar AS CHAR), ' }');
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                              MVD_RP1_Map : Format_Resource.sql                                             ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION Format_Resource
(
   qwResource               BIGINT,
   sName                    VARCHAR (48),
   sReference               VARCHAR (128)
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
       DECLARE n        INT;
       DECLARE sName_   VARCHAR (128);

           SET sName_ = sName;

            IF SUBSTRING(sName, 1, 1) = '~'
          THEN
                    SET n = LOCATE (':', sName);
                     IF n > 0 AND LENGTH (sName) = n + 10
                   THEN
                             SET sName_ = CONCAT ('https://', SUBSTRING(sName, 2, n - 2), '-cdn.rp1.com/sector/', SUBSTRING(sName, n + 1, 1), '/', SUBSTRING(sName, n + 2, 3), '/', SUBSTRING(sName, n + 5, 3), '/', SUBSTRING(sName, n + 1, 10), '.json');
                 END IF ;
        END IF ;

        RETURN CONCAT
               (
                  '{ ', 
                    '"qwResource": ',   CAST(qwResource AS CHAR), 
                  ', "sName": "',       sName_, 
                 '", "sReference": "',  sReference, 
                 '" }'
               );
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                             MVD_RP1_Map : Format_Transform.sql                                             ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION Format_Transform
(
   Position_dX               DOUBLE,
   Position_dY               DOUBLE,
   Position_dZ               DOUBLE,
   Rotation_dX               DOUBLE,
   Rotation_dY               DOUBLE,
   Rotation_dZ               DOUBLE,
   Rotation_dW               DOUBLE,
   Scale_dX                  DOUBLE,
   Scale_dY                  DOUBLE,
   Scale_dZ                  DOUBLE
)
RETURNS VARCHAR (512)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "Position": ', Format_Double3 (Position_dX, Position_dY, Position_dZ), ', "Rotation": ', Format_Double4(Rotation_dX, Rotation_dY, Rotation_dZ, Rotation_dW), ', "Scale": ', Format_Double3 (Scale_dX, Scale_dY, Scale_dZ), ' }');
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Format_Type_C.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION Format_Type_C
(
   bType                    TINYINT UNSIGNED,
   bSubtype                 TINYINT UNSIGNED,
   bFiction                 TINYINT UNSIGNED
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "bType": ', CAST(bType AS CHAR), ', "bSubtype": ', CAST(bSubtype AS CHAR), ', "bFiction": ', CAST(bFiction AS CHAR), ' }');
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Format_Type_P.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION Format_Type_P
(
   bType                    TINYINT UNSIGNED,
   bSubtype                 TINYINT UNSIGNED,
   bFiction                 TINYINT UNSIGNED,
   bMovable                 TINYINT UNSIGNED
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "bType": ', CAST(bType AS CHAR), ', "bSubtype": ', CAST(bSubtype AS CHAR), ', "bFiction": ', CAST(bFiction AS CHAR), ', "bMovable": ', CAST(bMovable AS CHAR), ' }');
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Format_Type_T.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION Format_Type_T
(
   bType                    TINYINT UNSIGNED,
   bSubtype                 TINYINT UNSIGNED,
   bFiction                 TINYINT UNSIGNED
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "bType": ', CAST(bType AS CHAR), ', "bSubtype": ', CAST(bSubtype AS CHAR), ', "bFiction": ', CAST(bFiction AS CHAR), ' }');
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                                  MVD_RP1_Map : IPstob.sql                                                  ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

DELIMITER $$

CREATE FUNCTION IPstob
(
   sIPAddress     VARCHAR (16)
)
RETURNS BINARY(4)
DETERMINISTIC
BEGIN
       RETURN UNHEX (HEX (INET_ATON (sIPAddress)));
END$$
  
DELIMITER ;

DELIMITER $$

CREATE FUNCTION IPbtos
(
   dwIPAddress    BINARY(4)
)
RETURNS VARCHAR (16)
DETERMINISTIC
BEGIN
      RETURN CONCAT
      (
          CAST(CONV (HEX (SUBSTRING(dwIPAddress, 1, 1)), 16, 10) AS CHAR), '.',
          CAST(CONV (HEX (SUBSTRING(dwIPAddress, 2, 1)), 16, 10) AS CHAR), '.',
          CAST(CONV (HEX (SUBSTRING(dwIPAddress, 3, 1)), 16, 10) AS CHAR), '.',
          CAST(CONV (HEX (SUBSTRING(dwIPAddress, 4, 1)), 16, 10) AS CHAR)
      );
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                                MVD_RP1_Map : Table_Error.sql                                               ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- Note: MySQL doesn't support table-valued functions like SQL Server
-- This would need to be implemented as a stored procedure that creates a temporary table
-- For now, this is converted to a comment indicating the table structure

-- CREATE TEMPORARY TABLE Error
-- (
--    nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
--    dwError                       INT             NOT NULL,
--    sError                        VARCHAR (255)   NOT NULL
-- );

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                                MVD_RP1_Map : Table_Event.sql                                               ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- Note: MySQL doesn't support table-valued functions like SQL Server
-- This would need to be implemented as a stored procedure that creates a temporary table
-- For now, this is converted to a comment indicating the table structure

-- CREATE TEMPORARY TABLE Event
-- (
--    nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
--    sType                         VARCHAR (32)    NOT NULL,
--    Self_wClass                   SMALLINT        NOT NULL,
--    Self_twObjectIx               BIGINT          NOT NULL,
--    Child_wClass                  SMALLINT        NOT NULL,
--    Child_twObjectIx              BIGINT          NOT NULL,
--    wFlags                        SMALLINT        NOT NULL,
--    twEventIz                     BIGINT          NOT NULL,
--    sJSON_Object                  TEXT            NOT NULL,
--    sJSON_Child                   TEXT            NOT NULL,
--    sJSON_Change                  TEXT            NOT NULL
-- );

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Table_Results.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- Note: MySQL doesn't support table-valued functions like SQL Server
-- This would need to be implemented as a stored procedure that creates a temporary table
-- For now, this is converted to a comment indicating the table structure

-- CREATE TEMPORARY TABLE Results
-- (
--    nResultSet                    INT,
--    ObjectHead_Self_twObjectIx    BIGINT
-- );

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                               MVD_RP1_Map : Time_Current.sql                                               ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- This function is really Date_Current

DELIMITER $$

CREATE FUNCTION Time_Current
(
)
RETURNS BIGINT
DETERMINISTIC
BEGIN
       RETURN Date_DateTime2(UTC_TIMESTAMP());
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                                                                                                                            ~~
~~                                              MVD_RP1_Map : Time_DateTime2.sql                                              ~~
~~                                                                                                                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~                            Copyright (c) 2023-2025 Metaversal Corporation. All rights reserved.                            ~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- DATETIME2  reports time in 1/10000000 sec from UTC Jan 1, 0001
-- S3         reports time in 1/64       sec from UTC Jan 1, 1601
-- There are  584388 days between UTC Jan 1, 0001 and UTC Jan 1, 1601
-- There are 5529600 1/64 sec per day

-- 584388 * 5529600 = 3231431884800

DELIMITER $$

CREATE FUNCTION Time_DateTime2
(
   dtStamp DATETIME  -- DATETIME values must be in UTC and generally generated from UTC_TIMESTAMP()
)
RETURNS BIGINT
DETERMINISTIC
BEGIN
      -- Convert MySQL DATETIME to S3 timestamp format
      -- MySQL uses seconds since 1970, S3 uses 1/64 sec since 1601
      -- There are 134774 days between Jan 1, 1601 and Jan 1, 1970
      -- 134774 * 86400 * 64 = 745246310400
      RETURN (UNIX_TIMESTAMP(dtStamp) * 64) + 745246310400;
END$$
  
DELIMITER ;

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
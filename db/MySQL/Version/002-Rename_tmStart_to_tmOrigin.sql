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

/* ************************************************************************************************************************** */

DELIMITER $$

CREATE PROCEDURE temp_Version_2()
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Version
        WHERE nVersion = 2
    ) THEN

        ALTER TABLE RMCObject
            RENAME COLUMN Orbit_Spin_tmStart TO Orbit_Spin_tmOrigin;

        INSERT INTO Version (nVersion, sDescription)
        VALUES (2, 'Rename tmStart to tmOrigin');

    END IF;
END $$

DELIMITER ;

CALL temp_Version_2();

DROP PROCEDURE temp_Version_2;

/* ************************************************************************************************************************** */

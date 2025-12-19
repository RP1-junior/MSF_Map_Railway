-- 0000_init_migrations.sql
-- Initializes the migration tracking system on an existing database.

-- 1) Create the migrations table if it doesn't exist
CREATE TABLE IF NOT EXISTS db_update (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    script_name   VARCHAR(255) NOT NULL UNIQUE,
    applied_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    checksum      VARCHAR(64) NULL,
    comment       VARCHAR(255) NULL
);

-- 2) Stamp this script as applied (baseline marker)
INSERT INTO db_migrations (script_name, checksum, comment)
SELECT '0000_init_update_table.sql', NULL, 'Baseline: DB existed before migrations system'
WHERE NOT EXISTS (
    SELECT 1
    FROM db_update
    WHERE script_name = '0000_init_update_table.sql'
);

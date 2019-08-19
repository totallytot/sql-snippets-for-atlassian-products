-- change db default collation
ALTER DATABASE jiradb CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

-- check dfault collation
SELECT default_collation_name FROM   information_schema.schemata S 
WHERE  schema_name = (SELECT 'jiradb' FROM DUAL);

-- convert table collation
ALTER TABLE ao_0456e7_cadence CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

-- generate list of commands for changing collation
SELECT concat ('ALTER TABLE ', t1.TABLE_SCHEMA, '.', t1.table_name, ' CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;')
from  information_schema.columns t1
where t1.TABLE_SCHEMA like 'jiradb' AND t1.COLLATION_NAME IS NOT NULL AND t1.COLLATION_NAME NOT IN ('utf8mb4_bin');

-- show collation for all tables in database
SELECT DISTINCT C.collation_name, T.table_name 
FROM information_schema.tables AS T, information_schema.`collation_character_set_applicability` AS C
WHERE C.collation_name = T.table_collation AND T.table_schema = 'jiradb';
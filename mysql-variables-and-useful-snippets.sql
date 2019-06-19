select @@innodb_buffer_pool_size;
select @@innodb_log_file_size;
select @@innodb_lock_wait_timeout;
select @@max_connections;

--This should deliver you which Tables have references to the table you want to drop, 
--once you drop these references, or the datasets which reference datasets in this table you will be able to drop the table
SELECT * FROM information_schema.KEY_COLUMN_USAGE 
WHERE REFERENCED_TABLE_NAME = 'YourTable';

SELECT table_name FROM information_schema.tables WHERE table_name ='Database Name';

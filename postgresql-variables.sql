-- Configuration file location
show config_file;

-- Determines the maximum number of concurrent connections to the database server. 
show max_connections;
-- psql -U postgres -c 'show max_connections;'

-- Determines how much memory is dedicated to PostgreSQL to use for caching data.
show shared_buffers;
/**
If you have a system with 1GB or more of RAM, a reasonable starting value for shared_buffers is 1/4 of the memory in your system.
it's unlikely you'll find using more than 40% of RAM to work better than a smaller amount (like 25%). Be aware that if your system or 
PostgreSQL build is 32-bit, it might not be practical to set shared_buffers above 2 ~ 2.5GB.
Note that on Windows, large values for shared_buffers aren't as effective, and you may find better results keeping it relatively low 
and using the OS cache more instead. On Windows the useful range is 64MB to 512MB.
2. Change kernel.shmmax
You would need to increase kernel max segment size to be slightly larger than the shared_buffers.
In file /etc/sysctl.conf set the parameter as shown below. It will take effect when postgresql reboots 
(The following line makes the kernel max to 96Mb) kernel.shmmax=100663296
**/

//check connections
SELECT * FROM pg_stat_activity;

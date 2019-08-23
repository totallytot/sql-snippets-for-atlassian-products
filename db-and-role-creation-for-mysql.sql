# jira MySql 5.7.6
CREATE DATABASE jiradb CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
GRANT ALL PRIVILEGES ON <database-name>.* TO '<jirauser>'@'localhost' IDENTIFIED BY '<password>';

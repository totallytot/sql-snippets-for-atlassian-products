# jira MySql 5.7.6
CREATE DATABASE jiradb CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
GRANT ALL PRIVILEGES ON <database-name>.* TO '<jirauser>'@'localhost' IDENTIFIED BY '<password>';

# confluence Mysql 5.7
CREATE DATABASE <database-name> CHARACTER SET utf8 COLLATE utf8_bin;
GRANT ALL PRIVILEGES ON <database-name>.* TO '<confluenceuser>'@'localhost' IDENTIFIED BY '<password>';

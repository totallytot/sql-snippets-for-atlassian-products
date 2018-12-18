CREATE DATABASE <database-name> CHARACTER SET utf8 COLLATE utf8_bin;
GRANT ALL PRIVILEGES ON <database-name>.* TO '<confluenceuser>'@'localhost' IDENTIFIED BY '<password>';

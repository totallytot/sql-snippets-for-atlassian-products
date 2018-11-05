create role jira with password 'j76Tre!' login;
CREATE DATABASE jiradb WITH ENCODING 'UNICODE' LC_COLLATE 'C' LC_CTYPE 'C' TEMPLATE template0;
alter database jiradb owner to jira;

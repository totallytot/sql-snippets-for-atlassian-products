create role jira with password 'j76Tre!' login;
CREATE DATABASE jiradb WITH ENCODING 'UNICODE' LC_COLLATE 'C' LC_CTYPE 'C' TEMPLATE template0;
alter database jiradb owner to jira;

create role confluence with password 'j76Tre!' login;
CREATE DATABASE "confluence"
    WITH OWNER "confluence"
    ENCODING 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TEMPLATE template0;

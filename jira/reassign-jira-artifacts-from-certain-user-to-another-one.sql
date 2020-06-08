select * from jiraissue where REPORTER = 'adam_rocska1' or ASSIGNEE = 'adam_rocska1';
update jiraissue set REPORTER = 'adam_rocska' where REPORTER = 'adam_rocska1';
update jiraissue set ASSIGNEE = 'adam_rocska' where ASSIGNEE = 'adam_rocska1';
update JIRAISSUE set creator = 'adam_rocska' where creator = 'adam_rocska1';

select * from worklog where AUTHOR='adam_rocska' ;
update worklog set author = 'adam_rocska' where author = 'adam_rocska1';

select * from JIRAACTION where author = 'adam_rocska1';
update JIRAACTION set author = 'adam_rocska' where author = 'adam_rocska1';
update JIRAACTION set UPDATEAUTHOR = 'adam_rocska' where UPDATEAUTHOR = 'adam_rocska1';

select * from changegroup where AUTHOR='adam_rocska1';
update changegroup set AUTHOR = 'adam_rocska' where AUTHOR = 'adam_rocska1';
update worklog set UPDATEAUTHOR='adam_rocska' where UPDATEAUTHOR = 'adam_rocska1';

select * from userhistoryitem where USERNAME='adam_rocska1';
update userhistoryitem set USERNAME ='adam_rocska' where USERNAME = 'adam_rocska1';

select * from userassociation where SOURCE_NAME = 'adam_rocska1';
update userassociation set SOURCE_NAME='adam_rocska' where SOURCE_NAME='adam_rocska1';

select * from portalpage where USERNAME='adam_rocska1';
update portalpage set USERNAME ='adam_rocska' where USERNAME='adam_rocska1';

select * from OS_HISTORYSTEP where CALLER='adam_rocska1';
update OS_HISTORYSTEP set CALLER ='adam_rocska' where CALLER='adam_rocska1';

select * from fileattachment where AUTHOR='adam_rocska1';
update fileattachment set AUTHOR = 'adam_rocska' where AUTHOR = 'adam_rocska1';

select * from favouriteassociations where USERNAME='adam_rocska';
update favouriteassociations set USERNAME ='adam_rocska' where USERNAME='adam_rocska1';

select * from external_entities where name ='adam_rocska1';
update external_entities set NAME ='adam_rocska' where NAME='adam_rocska1';

select * from columnlayout where USERNAME='adam_rocska1';
update columnlayout set USERNAME ='adam_rocska' where USERNAME='adam_rocska1';

select * from searchrequest where id =91422; --AUTHORNAME='adam_rocska';
update searchrequest set AUTHORNAME='adam_rocska' where AUTHORNAME='adam_rocska1';
update searchrequest set USERNAME='adam_rocska' where USERNAME='adam_rocska1';

select * from app_user where USER_KEY like '%adam_rocska%';
update app_user set USER_KEY='adam_rocska1' where id =60066;
update app_user set USER_KEY='adam_rocska' where id =26735;
update app_user set LOWER_USER_NAME='adam_rocska#2' where id = 60066;
update app_user set LOWER_USER_NAME='adam_rocska' where id = 26735;

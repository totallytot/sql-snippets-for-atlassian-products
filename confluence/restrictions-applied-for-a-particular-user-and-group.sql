select * from CONTENT where CONTENTID in ( 
select CONTENT_ID from CONTENT_PERM_SET where ID in 
  (select CPS_ID from CONTENT_PERM where USERNAME in 
	(select user_key from user_mapping where lower_username like 'local_admin')));
	 
select * from CONTENT where CONTENTID in ( 
select CONTENT_ID from CONTENT_PERM_SET where ID in 
  (select CPS_ID from CONTENT_PERM where GROUPNAME = 'confluence-users'));

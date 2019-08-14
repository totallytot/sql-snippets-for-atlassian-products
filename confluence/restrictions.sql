select * from CONTENT where CONTENTID in ( 
select CONTENT_ID from CONTENT_PERM_SET where ID in 
  (select CPS_ID from CONTENT_PERM where USERNAME in 
	(select user_key from user_mapping where lower_username like 'local_admin')));
	 
select * from CONTENT where CONTENTID in ( 
select CONTENT_ID from CONTENT_PERM_SET where ID in 
  (select CPS_ID from CONTENT_PERM where GROUPNAME = 'confluence-users'));

SELECT c.contentid, c.title, um.username as Creator, c.content_status, s.spacekey, cps.cont_perm_type as 'Restriction Type', 
cp.groupname, umm.username as 'uername' FROM SPACES s
LEFT JOIN CONTENT c ON s.spaceid = c.spaceid
LEFT JOIN CONTENT_PERM_SET cps ON c.contentid = cps.content_id
LEFT JOIN CONTENT_PERM cp ON cps.id = cp.cps_id
LEFT join user_mapping um
ON um.user_key = c.CREATOR
LEFT join user_mapping umm
ON umm.user_key = cp.username
WHERE s.SPACEKEY = 'IWI';

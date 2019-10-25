--- case: set email adrress as username for all users --- 
--- fix issue with recurrent email addresses (same email address is used with different usernames) ---
--- note: better to stop confluence before real database updates ---

-- backup DB using your favorite way and backup all tables referenced in a foreign key constraint for quick restore
create table cwd_user_backup as select * from cwd_user;
create table cwd_membership_backup as select * from cwd_membership;
create table cwd_user_attribute_backup as select * from cwd_user_attribute;
create table cwd_user_credential_record_backup as select * from cwd_user_credential_record;
-- a good idea is to save user_mapping table for future references in case of any issues
-- it is used for mapping content to users using user_key (the same as app_user table in Jira)
create table user_mapping_backup as select * from user_mapping;
-- in case of restore empty a set of tables and insert data from backuped tables
-- truncate cwd_user, cwd_membership, cwd_user_attribute, cwd_user_credential_record;
-- dry-run update of usernames (do not perfom real update on this step)
-- in case of no errors, proceed with the update of user_mapping table (see below)
begin;
	update cwd_user 
	set user_name = lower_email_address, lower_user_name = lower_email_address 
	where lower_user_name != lower_email_address 
	returning lower_display_name, user_name, lower_user_name;
rollback;
-- ERROR:  duplicate key value violates unique constraint "cwd_user_name_dir_id" 
-- DETAIL:  Key (lower_user_name, directory_id)=(blabla@blabla.com, 262145) already exists.
-- create view of recurrent email addresses 
create view recurrent_email_address as
	select lower_email_address, count(lower_email_address)
	from cwd_user
	group by lower_email_address
	having count(lower_email_address) > 1;
-- create view of users with recurrent email addresses
create view user_with_recurrent_email_address as
	select * from cwd_user where lower_email_address in (
		select distinct(lower_email_address) from recurrent_email_address);
-- check if users with recurrent email address have owns content and save for future references if you need it
select * from content where creator in (select user_key from user_mapping where lower_username in 
										 (select lower_user_name from user_with_recurrent_email_address));
-- same as above but for current pages
select * from content where creator in (select user_key from user_mapping where lower_username in 
										 (select lower_user_name from user_with_recurrent_email_address))
and contenttype = 'PAGE' and SPACEID is not null and CONTENT_STATUS = 'current';
--  w/t content
select * from user_mapping where lower_username in (select lower_user_name from user_with_recurrent_email_address)
and user_key not in (select creator from content);
-- in my case it was ok to remove not active users with recurrent emails even with content										 
select * from user_with_recurrent_email_address where active = 'F';
delete from cwd_user_attribute where user_id in (select id from user_with_recurrent_email_address where active = 'F');
delete from cwd_membership where child_user_id in (select id from user_with_recurrent_email_address where active = 'F');
delete from cwd_user where id in (select id from user_with_recurrent_email_address where active = 'F');
-- the easiest way to clean recurrent email addresses was to check users w/t login info
create view nologininfo as 
	select id, lower_user_name from user_with_recurrent_email_address where lower_user_name not in (
		select cu.lower_user_name from logininfo li
		join user_mapping um ON um.user_key = li.username
		join cwd_user cu ON um.lower_username = cu.lower_user_name
    );
-- remove users with recurrent email and no login info
select * from nologininfo order by lower_user_name;
delete from cwd_user_attribute where user_id in (select id from nologininfo);
delete from cwd_membership where child_user_id in (select id from nologininfo);
delete from cwd_user where id in (select id from nologininfo);
-- recreate your views: in my case the ouput was 6 emails (3 users), so I removed them based on login date 
-- update usernames in mappings in order not to loose the content after change of usernames 
begin;
	update user_mapping 
	set lower_username = cwd_user.lower_email_address, username = cwd_user.lower_email_address
	from cwd_user
	where lower_username = cwd_user.lower_user_name
	returning lower_username, username;
rollback;
-- ERROR:  duplicate key value violates unique constraint "unq_lwr_username"
-- DETAIL:  Key (lower_username)=(again.blabla@example.com) already exists
-- the user was remodeved. Assumed he would be mapped accordindly in case of account creation with email as username
-- finally, proceed with update of cwd_user user, drop views and start confluence
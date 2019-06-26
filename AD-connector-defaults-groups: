-- users that were added to default groups
select * FROM cwd_user_attribute
WHERE attribute_name = 'autoGroupsAdded'
AND attribute_value = 'true';

-- with usernames
select * from cwd_user where id in (
select distinct(child_user_id) from cwd_membership where child_user_id in (select user_id
FROM cwd_user_attribute WHERE attribute_name = 'autoGroupsAdded' AND attribute_value = 'true'));

--user that were not added to default group
select * from cwd_user 
where directory_id = 5570561 and active = 'T' and lower_email_address like '%@example.com' 
and id not in (select child_user_id from cwd_membership where parent_id in (
select id from cwd_group where lower_group_name = 'internal_users'))
order by created_date;

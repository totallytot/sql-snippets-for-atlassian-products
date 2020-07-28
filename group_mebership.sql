-- nested groups membership is ignored
-- mysql
select cwd_user.user_name, cwd_user.display_name, cwd_user.email_address, 
GROUP_CONCAT(cwd_membership.parent_name SEPARATOR ', ') as "MemberOf" from cwd_user 
inner join cwd_membership on cwd_membership.child_id = cwd_user.ID 
where cwd_membership.membership_type = 'GROUP_USER'
group by cwd_user.user_name, cwd_user.display_name, cwd_user.email_address;

-- postgresql
-- array_to_string(array_agg(child_name), ',')
select cwd_user.user_name, cwd_user.display_name, cwd_user.email_address, cwd_user.active,
array_to_string(array_agg(cwd_membership.parent_name), ',') as "MemberOf" from cwd_user 
inner join cwd_membership on cwd_membership.child_id = cwd_user.ID 
where cwd_membership.membership_type = 'GROUP_USER'
group by cwd_user.user_name, cwd_user.display_name, cwd_user.email_address, cwd_user.active;

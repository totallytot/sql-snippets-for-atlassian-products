select user_name, created_date from cwd_user where active = 1 and user_name not in 
(SELECT cwd_user.user_name
FROM cwd_user, cwd_user_attributes
WHERE cwd_user_attributes.user_id = cwd_user.id
AND cwd_user_attributes.attribute_name = 'login.count');

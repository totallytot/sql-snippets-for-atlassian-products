/* Treat this workaround as non-recommended. Was used for users in JIRA inrenal directory. DB: MySQL*/

select lower_user_name, email_address, lower_email_address from cwd_user where lower_user_name = 'admin';
update cwd_user
  set email_address = 'test1@test.com, test2@test.com, test3@test.com', 
      lower_email_address = 'test1@test.com, test2@test.com, test3@test.com'
  where lower_user_name = 'admin';

-- list of user and their project roles
SELECT p.pname AS "Project", pr.NAME AS "Project Role", u.lower_user_name AS "Username",
u.display_name AS "User Display Name", cd.directory_name AS "Directory"
FROM projectroleactor pra
  INNER JOIN projectrole pr ON pr.ID = pra.PROJECTROLEID
  INNER JOIN project p ON p.ID = pra.PID
  INNER JOIN app_user au ON au.user_key = pra.ROLETYPEPARAMETER
  INNER JOIN cwd_user u ON u.lower_user_name = au.lower_user_name
  INNER JOIN cwd_directory cd ON u.directory_id = cd.id 
ORDER BY p.pname;

-- list of users belonging to groups assigned to project roles for all projects
SELECT p.pname AS "Project", pr.NAME AS "Project Role", pra.roletypeparameter AS "Group", 
cmem.child_name AS "Username", u.display_name AS "Display Name", cd.directory_name AS "Directory"
FROM projectroleactor pra
  INNER JOIN projectrole pr ON pr.ID = pra.PROJECTROLEID
  INNER JOIN project p ON p.ID = pra.PID
  INNER JOIN cwd_membership cmem ON cmem.parent_name = pra.roletypeparameter
  INNER JOIN app_user au ON au.lower_user_name = cmem.child_name
  INNER JOIN cwd_user u ON u.lower_user_name = au.lower_user_name
  INNER JOIN cwd_directory cd ON u.directory_id = cd.id
WHERE pra.roletype = 'atlassian-group-role-actor' 
ORDER BY p.pname;
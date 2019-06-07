select cu.user_name, cu.active, cd.directory_name, cd.directory_type 
FROM cwd_user cu
     JOIN cwd_directory cd
     ON cu.directory_id = cd.id
WHERE user_name = 'DMARC';

SELECT cg.id, cg.group_name, cg.directory_id, cd.directory_name, cd.directory_type
FROM cwd_group cg
  JOIN cwd_directory cd
  ON cg.directory_id = cd.id
ORDER BY directory_name;

SELECT d.directory_name, d.active, d.id AS DirectoryID, d.directory_name, d.directory_type, u.id AS UserID, u.user_name,
g.id AS GroupID, g.group_name FROM cwd_user u
  JOIN cwd_directory d ON u.directory_id = d.id
  JOIN cwd_membership m ON u.id = m.child_user_id
  JOIN cwd_group g ON g.id = parent_id
ORDER BY u.user_name ASC, d.id, g.group_name ASC;

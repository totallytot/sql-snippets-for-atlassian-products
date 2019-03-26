/*Report that shows in which dirs groups are located.
DB: Microsoft SQL Server*/

SELECT cg.id, cg.group_name, cg.directory_id, cd.directory_name, cd.directory_type
FROM cwd_group cg
  JOIN cwd_directory cd
  ON cg.directory_id = cd.id
ORDER BY directory_name;

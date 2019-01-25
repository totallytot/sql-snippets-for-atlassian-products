select cu.user_name, cu.active, cd.directory_name, cd.directory_type 
FROM cwd_user cu
     JOIN cwd_directory cd
     ON cu.directory_id = cd.id
WHERE user_name = 'DMARC';

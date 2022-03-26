-- Taken from source article amd modified: https://confluence.atlassian.com/confkb/how-to-list-the-users-favourite-pages-and-spaces-790626896.html

SELECT user_mapping.username, cwd_user.display_name, cwd_user.lower_email_address, content.spaceid, spaces.spacekey, spaces.spacename
FROM label
  JOIN user_mapping
  ON label.owner = user_mapping.user_key
  LEFT JOIN cwd_user
  ON cwd_user.lower_user_name = user_mapping.lower_username
  LEFT JOIN content_label  
  ON label.labelid = content_label.labelid  
  JOIN content 
  ON content_label.contentid = content.contentid 
  JOIN spaces 
  ON content.spaceid = spaces.spaceid
WHERE LABEL.NAME = 'favourite'
AND content.contenttype = 'SPACEDESCRIPTION'
AND cwd_user.active = 'T'
ORDER BY user_mapping.username;

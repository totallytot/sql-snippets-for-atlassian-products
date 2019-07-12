-- GLOBAL PERMISSIONS
SELECT permgroupname AS groupname,
permtype AS "permission_type (global)"
FROM spacepermissions
WHERE spaceid IS NULL
AND permgroupname in ('<group_name>')
ORDER BY permgroupname,
permtype;

-- SPACE PERMISSIONS
SELECT permgroupname AS groupname,
s.spacename,
permtype AS "permission_type (space)"
FROM spacepermissions sp
JOIN spaces s ON sp.spaceid = s.spaceid
WHERE permgroupname in ('<group_name>')
ORDER BY permgroupname,
s.spacename,
permtype;

-- PAGE RESTRICTIONS
SELECT cp.groupname,
content.title AS content_title,
cp.cp_type AS "permission_type (page)"
FROM content_perm cp
JOIN content_perm_set cps ON cp.cps_id = cps.id
JOIN content ON content.contentid = cps.content_id
WHERE cp.groupname in ('<group_name>')
ORDER BY cp.groupname,
content.title,
cp.cp_type;

-- UPDATE GLOBAL PERMISSIONS
UPDATE spacepermissions
SET permgroupname = 'NEW_GROUP_NAME'
WHERE permgroupname IN ('OLD_GROUP_NAME')
AND spaceid IS NULL;

-- UPDATE SPACE PERMISSIONS - ALL SPACES
UPDATE spacepermissions
SET permgroupname = 'NEW_GROUP_NAME'
WHERE permgroupname IN ('OLD_GROUP_NAME')
AND spaceid IS NOT NULL;

-- UPDATE SPACE PERMISSIONS - SPECIFIC SPACES
UPDATE spacepermissions
SET permgroupname = 'NEW_GROUP_NAME'
WHERE permgroupname IN ('OLD_GROUP_NAME')
AND spaceid IN
(SELECT spaceid
FROM spaces
WHERE spacename IN ('<SPACE_NAME_1>',
'<SPACE_NAME_2>',
'<SPACE_NAME_n>'));

-- UPDATE PAGE PERMISSIONS
UPDATE content_perm
SET groupname = 'NEW_GROUP_NAME'
WHERE groupname IN ('OLD_GROUP_NAME');

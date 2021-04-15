SELECT na.source_node_id, na.sink_node_id, ps.name 
    FROM nodeassociation na 
    JOIN permissionscheme  ps 
        ON na.sink_node_id = ps.id 
WHERE sink_node_entity = 'PermissionScheme'
    AND SOURCE_NODE_ID = (SELECT ID FROM project WHERE pkey = 'ERPADM');

DELETE FROM nodeassociation 
    WHERE SINK_NODE_ENTITY = 'PermissionScheme' 
    AND SOURCE_NODE_ID = 12100 
    AND SINK_NODE_ID = 10300 
    AND ASSOCIATION_TYPE = 'ProjectScheme';
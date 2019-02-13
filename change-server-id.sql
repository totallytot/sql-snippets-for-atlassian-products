/*
You can take id from youyr test server <<Confluence-Home>>/confluence.cfg.xml or generate your own 
*/
select * from bandana where bandanakey = 'confluence.server.id';
update bandana set bandanavalue = '<string>SERVER_ID_HERE</string>' where bandanakey = 'confluence.server.id';

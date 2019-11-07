-- get a new server id. One of the way is to install new tempoary trial confluence and find the id in confluence.cfg.xml
-- stop confluence and swap sever id in confluence.cfg.xml file
-- update bandana table
select * from bandana where bandanakey = 'confluence.server.id';
update bandana set bandanavalue = '<string>BZPV-W7CO-39WO-TNMZ</string>' where bandanakey = 'confluence.server.id';
-- start confluence and update license for a new server id via GUI
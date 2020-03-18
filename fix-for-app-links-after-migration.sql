-- Confluence
-- remove old and create new app links between Jira and Confluence and check link ID in Confluence
select  * FROM public."AO_9412A1_USER_APP_LINK"; -- 57a47db7-22f5-3877-a43c-78acc5ba7f58

-- find old server id in content -> "serverId">a4042f01-0635-3bea-b355-770b2bd3a2e7<
select body from public.bodycontent where contentid = 367919183;
-- http://10.0.2.56:8090/pages/viewpage.action?pageId=367919183

-- replace all occurence of old id with a new one
update public.bodycontent 
set body = replace(body,'a4042f01-0635-3bea-b355-770b2bd3a2e7','57a47db7-22f5-3877-a43c-78acc5ba7f58');

-- clear cache http://10.0.2.56:8090/admin/cache/showStatistics.action

-- the same for links
-- https://example.net/wiki/spaces/NVP/pages/410976421
-- http://10.0.2.56:8090/pages/viewpage.action?pageId=430506009

-- Jira
-- check new app link id
SELECT SUBSTR(a.property_key,16,36) as "Application Key", b.propertyvalue as "Application Name" FROM propertyentry a join propertystring b on a.id=b.id where a.property_key like 'applinks.admin%name';
-- 416f96f7-f4d1-36ef-94ed-65db542babfd

-- check old id and links
SELECT issueid, globalid, url, relationship, applicationtype FROM public.remotelink
where applicationtype = 'com.atlassian.confluence';
-- 43bdd73a-c50f-3211-ae00-cf764653e6b5
-- https://example.atlassian.net/wiki/pages/viewpage.action?pageId=89751553

-- backup table 
create table public.remotelink_backup as (select * from remotelink);

-- replace old ids
begin;
update public.remotelink
set globalid = replace(globalid, '416f96f7-f4d1-36ef-94ed-65db542babfd', '43bdd73a-c50f-3211-ae00-cf764653e6b5'),
url = replace(url, 'https://example.atlassian.net/wiki', 'http://10.0.2.56:8090');
select * from public.remotelink;
commit;

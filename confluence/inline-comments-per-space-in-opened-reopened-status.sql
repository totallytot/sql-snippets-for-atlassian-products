-- inline parent comments in reopened
create view inline_reopened as 
	select distinct(cp1.contentid) from contentproperties cp1 
	inner join contentproperties cp2 on cp1.contentid = cp2.contentid
	inner join contentproperties cp3 on cp1.contentid = cp3.contentid
	where cp1.PROPERTYNAME = 'inline-comment' and cp1.STRINGVAL = 'true' 
        and cp2.PROPERTYNAME = 'inline-original-selection'  and cp2.STRINGVAL is not null
        and cp3.PROPERTYNAME = 'status' and cp3.STRINGVAL in ('reopened');

-- inline parent comments in reopened, resolved, dangling status
create view inline_resolved_reopened_dangling as 
	select distinct(cp1.contentid) from contentproperties cp1 
	inner join contentproperties cp2 on cp1.contentid = cp2.contentid
	inner join contentproperties cp3 on cp1.contentid = cp3.contentid
	where cp1.PROPERTYNAME = 'inline-comment' and cp1.STRINGVAL = 'true' 
        and cp2.PROPERTYNAME = 'inline-original-selection'  and cp2.STRINGVAL is not null
        and cp3.PROPERTYNAME = 'status' and cp3.STRINGVAL in ('reopened', 'resolved', 'dangling');

-- inline parent comments in open state (open status is not presented)
create view inline_opened as
	select distinct(cp1.contentid) from contentproperties cp1
    inner join contentproperties cp2 on cp1.contentid = cp2.contentid
    where cp1.PROPERTYNAME = 'inline-comment' and cp1.STRINGVAL = 'true' 
		and cp2.PROPERTYNAME = 'inline-original-selection'  and cp2.STRINGVAL is not null
		and cp1.contentid not in (
			select contentid from inline_resolved_reopened_dangling);
        
-- scope of inline parent comments from required space
create view inline_comments_scope as
	select * from content where CONTENTTYPE = 'COMMENT' and pageid in (
		select contentid from content where CONTENTTYPE = 'PAGE' and CONTENT_STATUS = 'current' and SPACEID in (
			select spaceid from spaces where SPACEKEY in ('SED2', 'SEUD2')));

-- opened inline comments
create view report_inline_comments_opened as (
	select * from inline_comments_scope where contentid in (select contentid from inline_opened));
    
-- final report - opened inline comments
select rico.contentid, bc.body, rico.contenttype, um.lower_username, rico.creationdate, sp.spacekey, c1.title,
concat('https://wiki.example.com/pages/viewpage.action?pageId=', rico.pageid) as Link
from report_inline_comments_opened rico
join user_mapping um on um.user_key = rico.CREATOR
join bodycontent bc on bc.contentid = rico.contentid
join content c on c.contentid = rico.pageid
join spaces sp on sp.spaceid = c.spaceid
join content c1 on rico.pageid = c1.contentid
order by rico.pageid, rico.creationdate;

-- reopened inline comments
create view report_inline_comments_reopened as (
	select * from inline_comments_scope where contentid in (select contentid from inline_reopened));

-- final report - reopened inline comments
select rico.contentid, bc.body, rico.contenttype, um.lower_username, rico.creationdate, sp.spacekey, c1.title, 
concat('https://wiki.example.com/pages/viewpage.action?pageId=', rico.pageid) as Link
from report_inline_comments_reopened rico
join user_mapping um on um.user_key = rico.CREATOR
join bodycontent bc on bc.contentid = rico.contentid
join content c on c.contentid = rico.pageid
join content c1 on rico.pageid = c1.contentid
join spaces sp on sp.spaceid = c.spaceid
order by rico.pageid, rico.creationdate;

-- drop created views
drop view inline_reopened, inline_resolved_reopened_dangling, inline_opened, inline_comments_scope, report_inline_comments_opened, report_inline_comments_reopened;
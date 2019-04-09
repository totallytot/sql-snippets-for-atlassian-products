
select um.username, s.SPACENAME, s.SPACEKEY from NOTIFICATIONS n
left join SPACES s
on n.SPACEID = s.SPACEID
left join user_mapping um
on n.USERNAME = um.user_key
left join CONTENT c
on n.CONTENTID = c.CONTENTID
where n.SPACEID is not null;

select um.username, c.CONTENTID, c.CONTENTTYPE, c.TITLE from NOTIFICATIONS n
left join user_mapping um
on n.USERNAME = um.user_key
left join CONTENT c
on n.CONTENTID = c.CONTENTID
where n.SPACEID is null and c.CONTENTTYPE = 'PAGE';

select um.username, c.CONTENTID, c.CONTENTTYPE, c.TITLE from NOTIFICATIONS n
left join user_mapping um
on n.USERNAME = um.user_key
left join CONTENT c
on n.CONTENTID = c.CONTENTID
where n.SPACEID is null and c.CONTENTTYPE = 'BLOGPOST'; 

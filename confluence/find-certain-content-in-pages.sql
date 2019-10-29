/*DB: Microsoft SQL Server*/
SELECT CONCAT('http://baseurl/pages/viewpage.action?pageId=', CONTENTID) as link FROM BODYCONTENT 
where CONTENTID in 
(select CONTENTID from CONTENT where SPACEID is not null and CONTENT_STATUS = 'current')
and BODY like '%place your content here%'
order by CONTENTID;

//Mysql
select CONCAT('https://wiki.example.com/pages/viewpage.action?pageId=', bc.CONTENTID) as 'Link', c.TITLE, s.SPACEKEY, s.SPACENAME, 
c.CONTENT_STATUS, c.VERSION, um.username as Creator, c.CREATIONDATE, umm.username as 'Last Modifier', c.LASTMODDATE from bodycontent bc
left join content c 
on c.CONTENTID = bc.CONTENTID
left join spaces s
on c.SPACEID = s.SPACEID
left join user_mapping um
on um.user_key = c.CREATOR
left join user_mapping umm
on umm.user_key = c.LASTMODIFIER  
where s.SPACEKEY not in ('SED2', 'SEUD2', 'SELD', 'PUBSELD', 'IWI', 'PB') 
and c.CONTENTTYPE = 'PAGE' and lower(bc.BODY) like lower('%pswd%')
order by s.SPACEKEY;
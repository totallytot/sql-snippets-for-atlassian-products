/*DB: Microsoft SQL Server*/
SELECT CONCAT('http://baseurl/pages/viewpage.action?pageId=', CONTENTID) as link FROM BODYCONTENT 
where CONTENTID in 
(select CONTENTID from CONTENT where SPACEID is not null and CONTENT_STATUS = 'current')
and BODY like '%place your content here%'
order by CONTENTID;

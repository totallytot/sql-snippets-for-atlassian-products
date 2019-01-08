/*Oracle*/
select 'https://www.epamplw.com/jira/browse/'||b.PKEY as "Link", b.PKEY as "Project Key",  
count (b.ID) as "Total Issues", to_char(max(a.UPDATED), 'HH24:MI:SS DD/MM/YYYY ') as "Last Activity" from jira.jiraissue a
join jira.project b
on a.project = b.ID
where b.PKEY in ('ANSLGRDN','EPPHDC')
group by b.PKEY
order by b.PKEY;

/*Mysql*/
select b.pname "Project Name", b.PKEY "Project Key", b.LEAD, count(b.ID) "Amount of Issues", 
DATE_FORMAT(min(a.CREATED), '%H:%i:%s %d/%m/%Y') "First Activity",
DATE_FORMAT(max(a.UPDATED), '%H:%i:%s %d/%m/%Y') "Last Activity" from jiraissue a
join project b
on a.project = b.ID
group by b.PKEY
order by b.PKEY;

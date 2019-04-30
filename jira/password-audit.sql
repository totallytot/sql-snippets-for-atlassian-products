/*
1234.com
1234
pswd
password
*/
-- comments
select p.pname as 'Project', concat(p.pkey, '-', ji.issuenum) as 'Issue Key', concat('https://jira.example.com/browse/', p.pkey, '-', ji.issuenum) as 'Link',
 ja.author, ja.created, ja.updateauthor, ja.updated, '1234.com' as 'Searched Value', p.lead from jiraaction ja
 left join jiraissue ji on ji.id = ja.issueid
 left join project p on p.id = ji.project 
 where ja.actionbody like '%1234.com%' COLLATE utf8_general_ci;

-- system fields
select p.pname as 'Project', concat(p.pkey, '-', ji.issuenum) as 'Issue Key', concat('https://jira.example.com/browse/', p.pkey, '-', ji.issuenum) as 'Link',
ji.creator as 'Creator', ji.created as 'Creation Date', ji.updated as 'Issue Last Update Date', '1234.com' as 'Searched Value', 'ENVIRONMENT' as 'System Field', p.lead as 'Lead'
from jiraissue ji
left join project p
on p.id = ji.project
where ji.ENVIRONMENT like '%1234.com%' COLLATE utf8_general_ci;
-- summary description environment

-- custom fields
select cfv.textvalue, cfv.stringvalue, cfv.updated, p.pname as 'Project', concat(p.pkey, '-', ji.issuenum) as 'Issue Key', concat('https://jira.example.com/browse/', p.pkey, '-', ji.issuenum) as 'Link',
ji.creator as 'Creator', ji.created as 'Creation Date', ji.updated as 'Issue Last Update Date', 
cf.cfname as 'Custom Field', 'password' as 'Searched Value', p.lead as 'Project Lead' from customfieldvalue cfv
left join jiraissue ji on cfv.issue = ji.id
left join project p on p.id = ji.project
left join customfield cf on cf.id = cfv.customfield
left join changeitem ch on ch.field = cf.cfname 
where textvalue like '%password%' COLLATE utf8_general_ci or stringvalue like '%password%' COLLATE utf8_general_ci
group by p.pname, ji.creator, ji.created, ji.updated, cf.cfname, p.lead 
order by cfv.updated;

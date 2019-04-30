//custom field
select p.pname as 'Project', concat(p.pkey, '-', ji.issuenum) as 'Issue Key', concat('https://jira.example.com/browse/', p.pkey, '-', ji.issuenum) as 'Link',
ji.creator as 'Creator', ji.created as 'Creation Date', ji.updated as 'Last Update Date', 
cf.cfname as 'Custom Field', 'password' as 'Searched Value', p.lead as 'Project Lead' from customfieldvalue cfv
left join jiraissue ji
on cfv.issue = ji.id
left join project p
on p.id = ji.project
left join customfield cf
on cf.id = cfv.customfield
where textvalue like '%password%' COLLATE utf8_general_ci
order by p.pname;

//system field
select p.pname as 'Project', concat(p.pkey, '-', ji.issuenum) as 'Issue Key', concat('https://jira.example.com/browse/', p.pkey, '-', ji.issuenum) as 'Link',
ji.creator as 'Creator', ji.created as 'Creation Date', ji.updated as 'Last Update Date', 'System Field', 'password' as 'Searched Value', p.lead as 'Lead'
from jiraissue ji
left join project p
on p.id = ji.project
where ji.description like '%password%' COLLATE utf8_general_ci
order by p.pname;

//comments
select p.pname as 'Project', concat(p.pkey, '-', ji.issuenum) as 'Issue Key', concat('https://jira.example.com/browse/', p.pkey, '-', ji.issuenum) as 'Link',
ja.author, ja.created, ja.updateauthor, ja.updated, 'password', p.lead from jiraaction ja
left join jiraissue ji on ji.id = ja.issueid
left join project p on p.id = ji.project 
where ja.actionbody like '%password%' COLLATE utf8_general_ci
order by p.pname;

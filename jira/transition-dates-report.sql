select concat(p.pkey,"-",ji.issuenum) as "Issue Key", it.PNAME as "Issue Type", ci.OLDSTRING As "From Status", 
ci.NEWSTRING As "To Status", cg.created as "Transition Date", cg.AUTHOR from changeitem ci
join changegroup cg on ci.GROUPID = cg.id
join jiraissue ji on ji.id = cg.issueid
join issuetype it on it.id = ji.ISSUETYPE
join project p on p.id = ji.project
where ci.field = 'status' and ci.newstring in ("TS Ordered", "CE Ordered")
and p.pkey = "PELA" order by cg.created;

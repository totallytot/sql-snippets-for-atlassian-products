-- worklog entries
select * from worklog where issueid is null;
select * from worklog where timeworked is null;
select * from worklog where not exists (select * from jiraissue where id=issueid);


-- issues without project 
select * from jiraissue where project is null;


-- no issues for version
select id from projectversion where not exists (
select * from  NODEASSOCIATION where sink_node_id =id and Sink_node_entity='Version' 
and source_node_entity='Issue');


-- no project for version
select id from projectversion v where not exists (
select * from  project where id=v.project);
 

-- no issue  for  version-issue record
select vname, p.pkey, sink_node_id issueid from projectversion v, project p, NODEASSOCIATION 
where v.id=sink_node_id 
and  sink_node_entity='Version' 
and source_node_entity='Issue'
and p.id=v.project
and not exists (select * from jiraissue where  id=source_node_id);

-- no version for  version-issue record 
select p.pkey,issuenum, sink_node_id versionid from jiraissue i, project p, NODEASSOCIATION where p.id=i.project and 
i.id = source_node_id and Sink_node_entity='Version' 
and source_node_entity='Issue'
and not exists (select * from projectversion where  id=sink_node_id);


-- subtasks without parents
select p.pkey, i.issuenum,t.pname from issuetype t ,jiraissue i, project p  
where i.issuetype=t.id and p.id=i.project and t.pstyle='jira_subtask'
and not exists (select * from issuelink where linktype=10100  and destination=i.id);


-- issues with null issuenum
select p.pkey, issuenum, i.id from jiraissue i left join  project p on ( p.id=i.project) where issuenum is null;


-- subtasks from another project
 select sp.pkey, si.issuenum, si.id, dp.pkey, di.issuenum, di.id     
  from issuelink l, jiraissue di, jiraissue si, project sp, project dp
  where linktype=10100
  and si.id=source and di.id=destination and si.project=sp.id and di.project=dp.id
  and dp.pkey!=sp.pkey;


-- classic-board versions that do not exists in projectversion (Oracle)
select * from     
(select  distinct extractvalue(value(t),'/long') id from TABLE(XMLSEQUENCE(
(select  
XMLAGG(extract(XMLTYPE(propertyvalue),'/map/entry[string="VERSION_MATCHUP"]//long')) 
from propertytext where  propertyvalue  like '%VERSION_MATCHUP%'))
) t) gh where not exists (select * from projectversion where id=gh.id);


 
-- orphan issuelinks
select * from issuelink   where not exists (select * from jiraissue where id=source)
or not exists (select * from jiraissue where id=destination) ;


-- versions with wrong projects  
select  p.pkey, i.issuenum,  v.vname, p.id project_project, 
(select pkey from project where id=v.project) version_project from jiraissue i, NODEASSOCIATION, project p, projectversion v 
where i.id =source_node_id
and sink_node_entity='Version' 
and source_node_entity='Issue'
and sink_node_id=v.id
and p.id=i.project
and v.project!=i.project


-- changegroup without issue id
select * from changeitem where groupid in (
select id from changegroup
where not exists (select * from jiraissue where id=issueid)
);

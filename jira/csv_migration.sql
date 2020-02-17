-- Source instance: Jira 5, Oracle 11

-- create table for non-existing in destination Jira users in order to avoid mapping during import
CREATE TABLE JIRADB.users_to_map_sa (name VARCHAR(255));

-- populate a newly created table
INSERT INTO JIRADB.users_to_map_sa (name) 
  WITH names AS ( 
    SELECT 'username0' FROM dual UNION ALL 
    SELECT 'username1' FROM dual UNION ALL 
    SELECT 'username2' FROM dual 
  ) SELECT * FROM names;

-- create main csv file
SELECT ji.PKEY AS "IssueKey", ji.PKEY AS "IssueId", it.PNAME AS "IssueType", ji.SUMMARY, p.PNAME AS "Priority", ist.PNAME AS "Status", 
ji.DESCRIPTION, comp.CNAME AS "Component", iv.vname AS "AffectsVersion", fv.vname AS "FixVersion", spr.NAME AS "SprintName",
kp.CUSTOMVALUE AS "КодПроцесса", ji.CREATED, ji.DUEDATE, ji.UPDATED, ji.TIMEORIGINALESTIMATE AS "OriginalEstimate", 
ji.TIMEESTIMATE AS "RemainingEstimate", ji.TIMESPENT,
  CASE WHEN lower(ji.ASSIGNEE) IN (SELECT name FROM users_to_map_sa) THEN 'sa' ELSE ji.ASSIGNEE END AS "Assignee",
  CASE WHEN lower(ji.REPORTER) IN (SELECT name FROM users_to_map_sa) THEN 'sa' ELSE ji.REPORTER END AS "Reporter",
  CASE WHEN lower(analitik.STRINGVALUE) IN (SELECT name FROM users_to_map_sa) THEN 'sa' ELSE analitik.STRINGVALUE END AS "Аналитик", 
  CASE WHEN lower(tester.STRINGVALUE) IN (SELECT name FROM users_to_map_sa) THEN 'sa' ELSE tester.STRINGVALUE END AS "Тестер", 
  CASE WHEN lower(razrab.STRINGVALUE) IN (SELECT name FROM users_to_map_sa) THEN 'sa' ELSE razrab.STRINGVALUE END  AS "Разработчик", 
  CASE WHEN lower(recenzent.STRINGVALUE) IN (SELECT name FROM users_to_map_sa) THEN 'sa' ELSE recenzent.STRINGVALUE END  AS "Рецензент", 
  CASE WHEN lower(zakazchik.STRINGVALUE) IN (SELECT name FROM users_to_map_sa) THEN 'sa' ELSE zakazchik.STRINGVALUE END  AS "Заказчик" 
FROM JIRAISSUE ji
LEFT JOIN (SELECT ISSUE, STRINGVALUE FROM CUSTOMFIELDVALUE 
			WHERE CUSTOMFIELD = 13202 AND ISSUE IN (SELECT ID FROM JIRAISSUE  WHERE project = 16703)) analitik
ON analitik.ISSUE = ji.ID
LEFT JOIN (SELECT ISSUE, STRINGVALUE FROM CUSTOMFIELDVALUE 
  			WHERE CUSTOMFIELD = 13201 AND ISSUE IN (SELECT ID FROM JIRAISSUE WHERE project = 16703)) tester
ON tester.ISSUE = ji.ID
LEFT JOIN (SELECT ISSUE, STRINGVALUE FROM CUSTOMFIELDVALUE 
			WHERE CUSTOMFIELD = 13200 AND ISSUE IN (SELECT ID FROM JIRAISSUE WHERE project = 16703)) razrab
ON razrab.ISSUE = ji.ID
LEFT JOIN (SELECT ISSUE, STRINGVALUE FROM CUSTOMFIELDVALUE 
			WHERE CUSTOMFIELD = 13600 AND ISSUE IN (SELECT ID FROM JIRAISSUE WHERE project = 16703)) recenzent
ON recenzent.ISSUE = ji.ID
LEFT JOIN (SELECT ISSUE, STRINGVALUE FROM CUSTOMFIELDVALUE 
		    WHERE CUSTOMFIELD = 13203 AND ISSUE IN (SELECT ID FROM JIRAISSUE WHERE project = 16703)) zakazchik
ON zakazchik.ISSUE = ji.ID
LEFT JOIN (SELECT cfv.ISSUE, spr.NAME FROM CUSTOMFIELDVALUE cfv, AO_60DB71_SPRINT spr
		    WHERE cfv.CUSTOMFIELD = 10005 AND cfv.STRINGVALUE = spr.ID AND cfv.ISSUE IN (
		     SELECT ID FROM JIRAISSUE WHERE project = 16703)) spr
ON spr.ISSUE = ji.ID
LEFT JOIN (SELECT cfv.ISSUE, cfo.CUSTOMVALUE FROM CUSTOMFIELDVALUE cfv, CUSTOMFIELDOPTION cfo
		    WHERE cfv.CUSTOMFIELD = 13206 AND cfv.STRINGVALUE = cfo.ID AND ISSUE IN (SELECT ID FROM JIRAISSUE WHERE project = 16703)) kp
ON kp.ISSUE = ji.ID
LEFT JOIN (SELECT na.SOURCE_NODE_ID, pv.VNAME FROM NODEASSOCIATION na, PROJECTVERSION pv
		    WHERE na.ASSOCIATION_TYPE = 'IssueFixVersion' AND na.SINK_NODE_ID = pv.id AND na.SOURCE_NODE_ENTITY = 'Issue' 
		     AND na.SOURCE_NODE_ID IN (SELECT ID FROM JIRAISSUE WHERE project = 16703)) fv
ON fv.SOURCE_NODE_ID = ji.ID
LEFT JOIN (SELECT na.SOURCE_NODE_ID, pv.VNAME FROM NODEASSOCIATION na, PROJECTVERSION pv
		    WHERE na.ASSOCIATION_TYPE = 'IssueVersion' AND na.SINK_NODE_ID = pv.id AND
		      na.SOURCE_NODE_ENTITY = 'Issue' AND na.SOURCE_NODE_ID IN (SELECT ID FROM JIRAISSUE WHERE project = 16703)) iv
ON iv.SOURCE_NODE_ID = ji.ID
LEFT JOIN (SELECT na.SOURCE_NODE_ID, c.CNAME FROM NODEASSOCIATION na, COMPONENT c
		     WHERE na.ASSOCIATION_TYPE = 'IssueComponent' AND na.SINK_NODE_ID = c.id AND na.SOURCE_NODE_ENTITY = 'Issue' 
		       AND na.SOURCE_NODE_ID IN (SELECT ID FROM JIRAISSUE WHERE project = 16703)) comp
ON comp.SOURCE_NODE_ID = ji.ID
LEFT JOIN PRIORITY p ON p.id = ji.PRIORITY
LEFT JOIN ISSUETYPE it ON it.id = ji.ISSUETYPE
LEFT JOIN ISSUESTATUS ist ON ist.id = ji.ISSUESTATUS
LEFT JOIN RESOLUTION r ON r.id = ji.RESOLUTION
WHERE ji.PROJECT = 16703;

-- drop table with non-existitng users
DROP TABLE JIRADB.users_to_map_sa;

-- sub-tasks
select jist.pkey as "Issue key", ji.pkey AS "Parent Id", jist.pkey  as "Issue Id",  it.pname as "Issue Type", jist.summary from issuelink il
left JOIN jiraissue ji
on il.SOURCE = ji.id
left JOIN jiraissue jist
on il.DESTINATION = jist.ID
left join project pr
on pr.id = ji.project
left join issuetype it
on jist.ISSUETYPE = it.id
where il.LINKTYPE = 10100 and pr.PKEY = 'PROJECT_KEY'

-- comments yyyy.MM.dd hh:mm
select ji.PKEY as "Issue Key", ji.SUMMARY, 
to_char(ja.created, 'YYYY.MM.DD HH24:MI')||q'[; ]'||ja.author||q'[; ]'||ja.actionbody as "Date; Author; Comment" 
FROM jiraissue ji
left join project p
on ji.project = p.id
right join jiraaction ja
on ji.id = ja.issueid
where p.pkey = 'PROJECT_KEY'
order by ja.created;

-- link "Epic Links"
select jist.pkey as "Issue Key", ji.summary, ji.pkey as "Epic Link" from issuelink il
left join ISSUELINKTYPE ilt on il.LINKTYPE = ilt.id
left JOIN jiraissue ji on il.SOURCE = ji.id
left JOIN jiraissue jist on il.DESTINATION = jist.ID
left join project pr on pr.id = ji.project
where pr.PKEY = 'PROJECT_KEY' AND ilt.LINKNAME = 'Epic-Story Link'
order by ilt.LINKNAME;

-- link "Blocks"
select ji.pkey as "Issue Key", ji.summary, jist.pkey as "Link Blocks" from issuelink il
left join ISSUELINKTYPE ilt on il.LINKTYPE = ilt.id
left JOIN jiraissue ji on il.SOURCE = ji.id
left JOIN jiraissue jist on il.DESTINATION = jist.ID
left join project pr on pr.id = ji.project
where pr.PKEY = 'PROJECT_KEY' and ilt.PSTYLE is NULL AND ilt.LINKNAME = 'Blocks'
order by ilt.LINKNAME;

-- link "Cloners"
select ji.pkey as "Issue Key", ji.summary, jist.pkey as "Link Cloners" from issuelink il
left join ISSUELINKTYPE ilt on il.LINKTYPE = ilt.id
left JOIN jiraissue ji on il.SOURCE = ji.id
left JOIN jiraissue jist on il.DESTINATION = jist.ID
left join project pr on pr.id = ji.project
where pr.PKEY = 'PROJECT_KEY' and ilt.PSTYLE is NULL AND ilt.LINKNAME = 'Cloners'
order by ilt.LINKNAME;

-- link "Relates"
select ji.pkey as "Issue Key", ji.summary, jist.pkey as "Link Relates" from issuelink il
left join ISSUELINKTYPE ilt on il.LINKTYPE = ilt.id
left JOIN jiraissue ji on il.SOURCE = ji.id
left JOIN jiraissue jist on il.DESTINATION = jist.ID
left join project pr on pr.id = ji.project
where pr.PKEY = 'PROJECT_KEY' and ilt.PSTYLE is NULL AND ilt.LINKNAME = 'Relates'
order by ilt.LINKNAME;

-- link "links"
select ji.pkey as "Issue Key", ji.summary, jist.pkey as "Link links" from issuelink il
left join ISSUELINKTYPE ilt on il.LINKTYPE = ilt.id
left JOIN jiraissue ji on il.SOURCE = ji.id
left JOIN jiraissue jist on il.DESTINATION = jist.ID
left join project pr on pr.id = ji.project
where pr.PKEY = 'PROJECT_KEY' and ilt.PSTYLE is NULL AND ilt.LINKNAME = 'links'
order by ilt.LINKNAME;

-- link "Duplicate"
select ji.pkey as "Issue Key", ji.summary, jist.pkey as "Link Duplicate" from issuelink il
left join ISSUELINKTYPE ilt on il.LINKTYPE = ilt.id
left JOIN jiraissue ji on il.SOURCE = ji.id
left JOIN jiraissue jist on il.DESTINATION = jist.ID
left join project pr on pr.id = ji.project
where pr.PKEY = 'PROJECT_KEY' and ilt.PSTYLE is NULL AND ilt.LINKNAME = 'Duplicate'
order by ilt.LINKNAME;

-- cmd commands for renaming
select 'REN '||'C:\Users\jiramigr\Desktop\PROJECT_KEY_CSV\PROJECT_KEY\'||ji.pkey||'\'||fa.id||' '||
TRANSLATE(fa.id||'_'||fa.filename, '!@#$%^&*() ', '___________') as "Commands" 
from jiraissue ji
left join project p
on ji.project = p.id
right join fileattachment fa
on ji.id = fa.issueid
where p.pkey = 'PROJECT_KEY';

-- csv file for attacments upload 
select ji.pkey as "Issue Key", Summary, 
'file://PROJECT_KEY/'||ji.pkey||'/'||TRANSLATE(fa.id||'_'||fa.filename, '!@#$%^&*() ', '___________') as "Attachment" from jiraissue ji
left join project p
on ji.project = p.id
right join fileattachment fa
on ji.id = fa.issueid
where p.pkey = 'PROJECT_KEY';
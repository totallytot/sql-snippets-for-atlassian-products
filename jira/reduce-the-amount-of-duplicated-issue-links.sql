/* Usefull if you want to clean JIRA from similar issue links
DB: PostgreSQL */

/* Create a report from DB in order to analyse a situation */
select linktype, count(linktype), linkname from issuelink il
left join issuelinktype ilt
on il.linktype = ilt.id
group by linktype, linkname
order by count(linktype);

/* Get list of affected projects */
select distinct pr.pkey "Project" from issuelink il
left join issuelinktype ilt
on il.linktype = ilt.id
left join jiraissue ji
on il.source = ji.id
left join project pr
on pr.id = ji.project
where il.linktype in (10300, 10100) /*linktype id for removal*/
order by pr.pkey

/*Create a backup of 'issuelink' and 'issuelinktype' tables and check it*/
create table issuelink_backup as select * from issuelink;
create table issuelinktype_backup as select * from issuelinktype;
select * from issuelink_backup;
select * from issuelinktype_backup;

/*Keep in mind that you can remove issue links in JIRA gui. JIRA will ask you the link for substitution before removal.
Update issue links according to your analyse, for example: */
update issuelink set linktype = 10300 where linktype = 10000;

/*If you need to revert the changes:*/
truncate table issuelink;
insert into issuelink select * from issuelink_backup;

/*Remove backup-ed tables if you are sure that you do not need them anymore:*/
drop issuelink_backup;
drop issuelinktype_backup;

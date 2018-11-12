/*DB: PostgreSQL*/
select p.pkey from project p
join projectroleactor pra on p.id = pra.pid
where pra.ROLETYPEPARAMETER = 'jira-software-users';

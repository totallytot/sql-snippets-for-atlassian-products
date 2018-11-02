/* DB: MySQL */
SELECT 
  workflowscheme.name as 'Workflow Scheme',
  workflowschemeentity.workflow as 'Workflow',
  issuetype.pname as 'Issue Type'
FROM 
  issuetype,
  workflowschemeentity,
  workflowscheme
WHERE 
issuetype.id = workflowschemeentity.issuetype and
workflowscheme.id = workflowschemeentity.scheme and
  workflowschemeentity.workflow in
	(SELECT 
		jiraworkflows.workflowname
	FROM 
		jiraworkflows
	WHERE 
		jiraworkflows.descriptor like '%googlecode.jira-suite%' or jiraworkflows.descriptor like '%om.onresolve.scriptrun%');

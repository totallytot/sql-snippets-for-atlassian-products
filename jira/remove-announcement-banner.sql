DELETE from propertytext WHERE ID = (select id from propertyentry where property_key='jira.alertheader');
DELETE from propertystring where ID = (select id from propertyentry where property_key='jira.alertheader.visibility');
DELETE from propertyentry where property_key in ('jira.alertheader','jira.alertheader.visibility');

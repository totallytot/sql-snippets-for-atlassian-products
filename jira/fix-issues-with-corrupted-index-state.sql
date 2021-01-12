update issue_version set DELETED = 'N' where DELETED ='Y' and ISSUE_ID in (Select ID from jiraissue);

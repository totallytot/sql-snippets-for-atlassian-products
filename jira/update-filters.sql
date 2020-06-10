select * from searchrequest where reqcontent like '%tech_user%';
update searchrequest 
  set reqcontent = replace(reqcontent, 'tech_user', 'test') 
    where reqcontent like '%tech_user%';

select * from "AO_60DB71_QUICKFILTER" where "LONG_QUERY" like '%tech_user%';
update "AO_60DB71_QUICKFILTER" 
  set "LONG_QUERY" = replace("LONG_QUERY", 'tech_user', 'test') 
    where "LONG_QUERY" like '%tech_user%';

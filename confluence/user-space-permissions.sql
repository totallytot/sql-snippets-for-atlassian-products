select um.lower_username, cu.lower_email_address, s.SPACENAME, s.SPACEKEY, concat('https://wiki.example.com/display/', s.SPACEKEY) as LINK from SPACEPERMISSIONS sp
left join user_mapping um
on sp.PERMUSERNAME = um.user_key
left join spaces s
on sp.SPACEID = s.SPACEID
left join cwd_user cu
on cu.lower_user_name = um.lower_username
where sp.PERMGROUPNAME is null and cu.lower_email_address not like '%@example.com%'
group by um.lower_username, cu.lower_email_address, s.SPACENAME, s.SPACEKEY
order by s.SPACEKEY;

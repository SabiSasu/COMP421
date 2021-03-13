--List the name and start date of all projects of the type internal sorted by the project name.
select pname, pstartdate
from project
where ptype='internal'
order by pname
;
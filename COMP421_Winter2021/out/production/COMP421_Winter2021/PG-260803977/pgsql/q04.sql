--Give the project name, assignment date and project type of the projects assigned to the developer
--with the employee id 82102. Order the output by project names.
Select p.pname, da.asgndate, p.ptype
from project p, devassignments da
where da.employeeid = 82102
and da.pname = p.pname
order by p.pname;
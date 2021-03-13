--Give the name and employee id of the developers who are on at least one internal project but is not
--on any external project (these are the values of the project type column). Order the output by the employeeid.

Select dev.ename, dev.employeeid
from developer dev, devassignments d, project p
where dev.employeeid = d.employeeid
    and d.pname = p.pname
    and  p.ptype = 'internal'
  EXCEPT
Select dev.ename, dev.employeeid
from developer dev, devassignments d, project p
where dev.employeeid = d.employeeid
  and d.pname = p.pname
  and  p.ptype = 'external'
order by employeeid;
--Find the name and start date of the youngest project (based on start date) as well as the number of
--developers assigned to the project. If there are multiple projects with the same start date, order the output
--by the project names. Call the number column numdevs. Remember there could be a case where you may
--have no developers assigned yet, which you should consider as 0.
select p.pname, p.pstartdate, count(d.employeeid) numdevs
from (project p
         LEFT OUTER JOIN  devassignments d on p.pname = d.pname)
where p.pstartdate = (SELECT MAX(p.pstartdate) FROM project p)
group by p.pname
order by p.pname;
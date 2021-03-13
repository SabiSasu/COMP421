--Find the name and start date of the oldest project (based on start date). If there are multiple projects
--with the same start date, order the output by the project names.
select p.pname, p.pstartdate
from project p
where p.pstartdate = (SELECT MIN(p.pstartdate) FROM project p)
order by p.pname;

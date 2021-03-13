--List the name of all the projects that have 2 or less developers assigned to it. Order by the projectnames.
select d.pname
from devassignments d
group by d.pname
having COUNT(d.pname) <= 2
order by d.pname;
--List the names of all the projects for which the employee with the employee id 93401 has authored a
--document. Order the output by the project name.
Select distinct p.pname
from project p, documentauthors d, document doc
where p.pname = doc.pname
and doc.documentid = d.documentid
and d.employeeid = '93401'
order by p.pname;

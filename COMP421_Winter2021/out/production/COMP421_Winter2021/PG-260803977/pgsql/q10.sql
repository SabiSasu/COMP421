--Find the number of projects for which the employee with the employee id 93401 has authored a
--document. Call the output column numprojects.
Select count(distinct p.pname) numprojects
from project p, documentauthors d, document doc
where p.pname = doc.pname
  and doc.documentid = d.documentid
  and d.employeeid = '93401';


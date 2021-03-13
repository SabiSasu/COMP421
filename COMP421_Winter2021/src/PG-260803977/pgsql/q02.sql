--Find the information of all the authors of the document with document id 22. Output the employee
--id and name, order the output based on the employee id.
select d.employeeid, d.ename
from developer d, documentauthors doc
where doc.documentid = 22
and d.employeeid = doc.employeeid
order by d.employeeid;

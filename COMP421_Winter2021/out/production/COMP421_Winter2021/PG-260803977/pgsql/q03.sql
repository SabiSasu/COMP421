--Give the names and employee id of the developers who are assigned to the project Kodiak but has
--not authored any documents associated with the project. Order the output by the employee id.

select d.ename, d.employeeid
from developer d, devassignments dev
where dev.pname = 'Kodiak'
  and dev.employeeid = d.employeeid
  and d.employeeid not in (select doc.employeeid
                           from documentauthors doc, document doc2
                           where doc2.pname='Kodiak'
                           and doc.documentid = doc2.documentid)
order by d.employeeid;

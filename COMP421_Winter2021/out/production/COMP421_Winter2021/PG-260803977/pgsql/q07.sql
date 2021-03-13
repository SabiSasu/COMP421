--Give the project name and employee id of the developers who have authored a document for a project,
--but is not assigned to that project. Order the output by the project and then by the employee id.

select distinct p.pname, dev.employeeid
from project p, developer dev, documentauthors d, document doc
where p.pname = doc.pname
  and d.documentid = doc.documentid
  and d.employeeid = dev.employeeid
except
    (select p.pname, dev.employeeid
    from project p, developer dev, devassignments d
    where p.pname = d.pname
        and dev.employeeid = d.employeeid)
order by pname, employeeid;

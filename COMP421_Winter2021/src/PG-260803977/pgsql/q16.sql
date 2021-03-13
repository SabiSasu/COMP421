--Find the names and employee ids of developers who are either assigned to the project Kodiak or has
--authored a document for it. Order the output by their employee ids.
select distinct dev.ename, dev.employeeid
from developer dev, devassignments d, documentauthors da, document doc
where (d.pname = 'Kodiak' and dev.employeeid = d.employeeid)
or (doc.pname = 'Kodiak' and doc.documentid = da.documentid and dev.employeeid = da.employeeid)
order by dev.employeeid;
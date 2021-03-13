--List the names of the internal projects and the number of documents associated with them. Name the
--latter column numdocs. Order the output with the projects having the highest number of documents being
--first. You can then order by the project names if two of them have the same number of documents. Remember
--to take into account the projects with no documents in the output of the query.

select p.pname, count(doc.documentid) numdocs
from (document doc
    INNER JOIN project p on doc.pname = p.pname)
group by p.pname
order by numdocs DESC, p.pname;
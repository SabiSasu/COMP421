--Find the names of (all types of) projects whose budget is more than the average internal project
--budget. Also include the budget of such projects in the output. Order the output such that the highest
--budget projects are at the top of the list. If there are two projects with same budget, then order them by the
--project name. You can assume that there are some internal projects.

SELECT p.pname, p.budget
FROM project p
WHERE p.budget > (SELECT AVG(p.budget)
                    FROM project p
                    where p.ptype = 'internal')
order by p.budget desc, p.pname;
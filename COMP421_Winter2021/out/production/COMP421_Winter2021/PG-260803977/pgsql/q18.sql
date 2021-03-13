--Find the name of the project whose budget to the number of developers assigned ratio is the highest
--as well as that ratio (call this column devcost). If there are multiple projects with the same ratio, order the
--output by the project name. Do not include projects with no developers assigned for this calculation.


select * from
    (SELECT p.pname, p.budget/count(d.employeeid) as devcost
        from (project p
            INNER JOIN  devassignments d on p.pname = d.pname)
        group by p.pname) as x
where devcost = (SELECT p.budget/count(d.employeeid) as devcost
                 from (project p
                          INNER JOIN  devassignments d on p.pname = d.pname)
                 group by p.pname
                order by devcost desc limit 1)
order by x.pname;

--first get all the project and their devcost. Then only keep record with their devcost equal to the highest one in the list
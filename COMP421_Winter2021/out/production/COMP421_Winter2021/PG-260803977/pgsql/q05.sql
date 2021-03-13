--Give a list of projects that started last summer (2020 May through August). Output project name
--and start date, order the output by start date and then by the project name.
Select pname, pstartdate from project
where pstartdate > '2020-05-01'
and pstartdate < '2020-08-31'
order by pstartdate, pname;
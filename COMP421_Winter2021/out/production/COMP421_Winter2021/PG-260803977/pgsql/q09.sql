--Find the number of projects that started this year. Name the output column numprojects.
Select count(*) numprojects from project
where pstartdate > '2021-01-01';
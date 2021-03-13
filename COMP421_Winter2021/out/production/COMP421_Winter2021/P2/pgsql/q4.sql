--a
select *
from timeslot t
where t.health_ins_num IS NULL
and t.locname = 'Jewish General'
and EXTRACT(MONTH FROM t.tdate) = 03
and EXTRACT(DAY FROM t.tdate) = 20
;

--b
select b.bdate_expire
from batch b, vial v, timeslot t, person p
where p.pname = 'Jane Doe'
and t.health_ins_num = p.phealth_ins_num
and t.tdate = '2021-02-06'
and t.vialid = v.vial_id
and t.batchno = v.batch_no
and t.vname = v.vname
AND v.batch_no = b.batch_no
group by b.bdate_expire
;

--c
select count(*) AS mtl_vaccinated
from timeslot t, location l
where l.lcity_addr = 'Montreal'
  and l.lname = t.locname
  and t.tdate = '2021-02-06'
  and t.vialid is not NULL
;

--d
select p.pname, p.pphone, p.phealth_ins_num
from person p, timeslot t, vaccine va, vial vi
where va.vname = 'Pfizer-BioNTech'
and vi.vname = va.vname
and t.vialid = vi.vial_id
and t.tdate < '2021-02-01'
and p.phealth_ins_num = t.health_ins_num
    EXCEPT
        (select p.pname, p.pphone, p.phealth_ins_num
         from person p, timeslot t, vial vi
         where vi.vname = 'Pfizer-BioNTech'
           and vi.vial_id = t.vialid
           and vi.batch_no = t.batchno
           and t.health_ins_num = p.phealth_ins_num
         group by p.pname, p.pphone, p.phealth_ins_num
         having count(*) >= 2)
;

--e
select c.cname, count(*) as num_vaccinated
from category c, person p
where p.pcategory = c.cname
and p.phealth_ins_num in (select t.health_ins_num
                          from timeslot t
                          where t.vialid is not null
                            and t.health_ins_num is not null
                          group by t.health_ins_num)
group by c.cname
;
DROP VIEW mtlnurses
;
CREATE VIEW mtlnurses AS
SELECT n.nlicense_no, n.nname, h.location_name, l.lstreet_addr, l.lcity_addr, l.lpostal
    FROM NURSE n, HOSPITAL h, LOCATION l
    WHERE l.lcity_addr like 'Montreal'
    and l.lname = h.location_name
    and n.nlocationname = h.location_name
;

select * from mtlnurses limit 5
;

select * from mtlnurses where location_name = 'Jewish General' limit 5
;

insert into mtlnurses values
(999, 'Sam Field', 'Jewish General', '111, that street', 'Montreal', 'q1w2e3')
;

DROP VIEW mtlnurses
;



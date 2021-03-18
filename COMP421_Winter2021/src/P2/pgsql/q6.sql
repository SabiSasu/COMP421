ALTER TABLE batch ADD CHECK (bdate_expire>=bdate_manufactured);
INSERT INTO batch(vname,batch_no,bdate_expire,bdate_manufactured,bvials_quantity,blocation_name) values
('Pfizer-BioNTech',99,'2011-07-02','2021-01-04',30,'Jewish General');


INSERT INTO PERSON(phealth_ins_num, pname, pgender, pdob, pstreet_addr, pcity_addr, pphone, ppostal, pdate_registered, pcategory) VALUES
('123Pol', 'Paul Pol', 'M', '1990-03-02', '123, street street', 'Montreal', 111222333, 'g2h3j4', '01-01-2021', 'Physical proximity to second priority'),
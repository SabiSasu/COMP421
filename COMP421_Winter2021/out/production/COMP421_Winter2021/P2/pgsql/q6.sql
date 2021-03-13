ALTER TABLE batch ADD CHECK (bdate_expire>=bdate_manufactured);
INSERT INTO batch(vname,batch_no,bdate_expire,bdate_manufactured,bvials_quantity,blocation_name) values
('Pfizer-BioNTech',99,'2011-07-02','2021-01-04',30,'Jewish General');
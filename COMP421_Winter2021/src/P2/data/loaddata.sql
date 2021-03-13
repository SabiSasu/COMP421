-- Include your INSERT SQL statements in this file.
-- Make sure to terminate each statement with a semicolon (;)

-- LEAVE this statement on. It is required to connect to your database.
CONNECT TO cs421;

-- Remember to put the INSERT statements for the tables with foreign key references
--    ONLY AFTER the parent tables!

INSERT INTO CATEGORY (cname, cpriority) VALUES
('Health Care workers', 1)
,('Elderly (>= 65)', 1)
,('Immunologically Compromised', 1)
,('Teachers', 2)
,('Children below 10', 2)
,('Physical proximity to first priority', 2)
,('Essential Service Workers', 3)
,('Physical proximity to second priority', 3)
,('Everybody else', 4)
;

INSERT INTO  VACCINE(vname, vwaitperiod, vdoses, vmanufacturer) VALUES
('Pfizer-BioNTech', 28, 2, 'Pfizer & BioNTech'),
('Moderna', 28, 2, 'ModernaTX')
;

INSERT INTO LOCATION(lname,lstreet_addr,lcity_addr,lpostal) VALUES
('Jewish General', '111, that street', 'Montreal', 'q1w2e3'),
('Jewish Clinic', '222, other street', 'Montreal', 'q1w2e4'),
('C Clinic', '333, this street', 'Longueuil', 'q1w2e5'),
('Pierre Boucher', '444, this street', 'Longueuil', 'q1w2e5'),
('Montreal Childrens Hospital', '555, that street', 'Montreal', 'q1w2e6')
;

INSERT INTO hospital(location_name) VALUES
('Jewish General'),
('Pierre Boucher'),
('Montreal Childrens Hospital')
;

INSERT INTO PERSON(phealth_ins_num, pname, pgender, pdob, pstreet_addr, pcity_addr, pphone, ppostal, pdate_registered, pcategory) VALUES
('123Pol', 'Paul Pol', 'M', '1990-03-02', '123, street street', 'Montreal', 111222333, 'g2h3j4', '01-01-2021', 'Physical proximity to second priority'),
('124Pol', 'Tiny Pol', 'M', '2015-05-01', '123, street street', 'Montreal', 111222333, 'g2h3j4', '01-01-2021', 'Children below 10'),
('125Pol', 'Paula Plante Pol', 'F', '1994-01-09', '123, street street', 'Montreal', 111222333, 'g2h3j4', '01-01-2021', 'Teachers'),
('126Pol', 'Old Pol', 'M', '1945-01-01', '123, street street', 'Montreal', 111222333, 'g2h3j4', '01-01-2021', 'Elderly (>= 65)'),
('123King', 'Stephen King', 'M', '1979-03-02', '149, street street', 'Montreal', 111222444, 'g2h3j5', '08-01-2021', 'Everybody else'),
('127Pol', 'Paul Pol2', 'M', '1990-03-02', '123, street street', 'Montreal', 111222333, 'g2h3j4', '01-01-2021', 'Essential Service Workers'),
('128Pol', 'Paul Pol3', 'M', '1990-03-02', '123, street street', 'Montreal', 111222333, 'g2h3j4', '01-01-2021', 'Health Care workers'),
('123Doe', 'Jane Doe', 'F', '1990-03-02', '123, street street', 'Montreal', 111222333, 'g2h3j4', '01-01-2021', 'Physical proximity to second priority')
;

INSERT INTO batch(vname,batch_no,bdate_expire,bdate_manufactured,bvials_quantity,blocation_name) values
('Pfizer-BioNTech',1,'2021-07-02','2021-01-04',30,'Jewish General'),
('Pfizer-BioNTech',2,'2021-07-02','2021-01-04',50,'Jewish General'),
('Moderna',1,'2021-07-02','2021-01-04',20,'Jewish General'),
('Pfizer-BioNTech',3,'2021-07-02','2021-01-04',30,'Montreal Childrens Hospital'),
('Pfizer-BioNTech',4,'2021-07-02','2021-01-04',90,'Montreal Childrens Hospital'),
('Moderna',2,'2021-07-02','2021-01-04',90,'Montreal Childrens Hospital'),
('Pfizer-BioNTech',5,'2021-07-02','2021-01-04',10,'Pierre Boucher'),
('Moderna',3,'2021-07-02','2021-01-04',20,'Pierre Boucher')
;

INSERT INTO VIAL(vname,batch_no,vial_id) VALUES
('Pfizer-BioNTech',1, 1),
('Pfizer-BioNTech',1, 2),
('Pfizer-BioNTech',1, 3),
('Pfizer-BioNTech',1, 4),
('Pfizer-BioNTech',1, 5),
('Pfizer-BioNTech',1, 6),
('Pfizer-BioNTech',1, 7),
('Moderna',1, 1),
('Moderna',1, 2),
('Pfizer-BioNTech',3, 1),
('Pfizer-BioNTech',3, 2),
('Pfizer-BioNTech',5, 1),
('Pfizer-BioNTech',5, 2),
('Pfizer-BioNTech',5, 3),
('Moderna',2, 1),
('Moderna',3, 1)
;

insert into VACCDATE(tdate,locname) VALUES
('2021-01-07', 'Jewish General'),
('2021-02-21', 'Jewish General'),
('2021-02-22', 'Jewish General'),
('2021-02-23', 'Jewish General'),
('2021-02-06', 'Jewish General'),
('2021-02-06', 'Pierre Boucher'),
('2021-02-02', 'Jewish General'),
('2021-03-20', 'Jewish General')
;

INSERT INTO NURSE(nlicense_no,nname,nlocationname) VALUES
(12345, 'Sarah Lock', 'Jewish General'),
(12344, 'Chad Rett', 'Jewish General'),
(12346, 'Brett Red', 'Pierre Boucher'),
(12348, 'Jessica Jay', 'Pierre Boucher'),
(12347, 'Ryan Holl', 'Montreal Childrens Hospital')
;

INSERT INTO NURSEASSIG(licensenum,locname,vdate) VALUES
(12345, 'Jewish General', '2021-02-02'),
(12344, 'Jewish General', '2021-02-02'),
(12345, 'Jewish General', '2021-03-20'),
(12345, 'Jewish General', '2021-02-06'),
(12345, 'Jewish General', '2021-01-07'),
(12346, 'Pierre Boucher', '2021-02-06')
;
INSERT INTO TIMESLOT(tslot,ttime,tdate,locname,health_ins_num,tdate_allocated,vname,batchno,vialid,licensenum) VALUES
(1, '13:00:00', '2021-02-02', 'Jewish General', '128Pol', '2021-01-20', 'Pfizer-BioNTech', 1, 1, 12345),
(2, '13:00:00', '2021-03-20', 'Jewish General', NULL, NULL, NULL, NULL, NULL, NULL),
(3, '13:05:00', '2021-03-20', 'Jewish General', NULL, NULL, NULL, NULL, NULL, NULL),
(4, '13:10:00', '2021-03-20', 'Jewish General', '128Pol', '2021-01-20', 'Pfizer-BioNTech', 1, 4, 12345),
(5, '13:00:00', '2021-02-06', 'Jewish General', '123Doe', '2021-01-20', 'Pfizer-BioNTech', 1, 2, 12345),
(6, '13:05:00', '2021-02-06', 'Jewish General', '127Pol', '2021-01-20', 'Pfizer-BioNTech', 1, 3, 12345),
(7, '13:10:00', '2021-02-06', 'Pierre Boucher', '123King', '2021-01-20', 'Pfizer-BioNTech', 5, 1, 12346),
(8, '13:15:00', '2021-02-06', 'Pierre Boucher', NULL, NULL, NULL, NULL, NULL, NULL),
(9, '13:05:00', '2021-02-06', 'Jewish General', NULL, NULL, NULL, NULL, NULL, NULL),
(10, '13:00:00', '2021-01-07', 'Jewish General', '126Pol', '2021-01-05', 'Pfizer-BioNTech', 1, 5, 12345),
(11, '13:05:00', '2021-01-07', 'Jewish General', '125Pol', '2021-01-05', 'Pfizer-BioNTech', 1, 6, 12345),
(12, '13:00:00', '2021-03-20', 'Jewish General', '126Pol', '2021-01-20','Pfizer-BioNTech', 1, 7, 12345)
;
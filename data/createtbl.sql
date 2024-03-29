-- Include your create table DDL statements in this file.
-- Make sure to terminate each statement with a semicolon (;)

-- LEAVE this statement on. It is required to connect to your database.
CONNECT TO cs421;

-- Remember to put the create table ddls for the tables with foreign key references
--    ONLY AFTER the parent tables has already been created.

-- This is only an example of how you add create table ddls to this file.
--   You may remove it.

CREATE TABLE CATEGORY
(
    cname     VARCHAR(50) NOT NULL,
    cpriority INTEGER DEFAULT 4,
    PRIMARY KEY (cname)
);
CREATE TABLE PERSON
(
    phealth_ins_num  VARCHAR(12) NOT NULL,
    pname            VARCHAR(30) NOT NULL,
    pgender          VARCHAR(1) CHECK (pgender IN ('F', 'M', NULL)),
    pdob             DATE NOT NULL,
    pstreet_addr     VARCHAR(30),
    pcity_addr       VARCHAR(30),
    pphone           INTEGER,
    ppostal          VARCHAR(6),
    pdate_registered DATE,
    pcategory        VARCHAR(50) NOT NULL,
    PRIMARY KEY (phealth_ins_num),
    FOREIGN KEY (pcategory) REFERENCES CATEGORY (cname)
);
CREATE TABLE LOCATION
(
    lname        VARCHAR(30) NOT NULL,
    lstreet_addr VARCHAR(30),
    lcity_addr   VARCHAR(30),
    lpostal      VARCHAR(6),
    PRIMARY KEY (lname)
);
CREATE TABLE HOSPITAL
(
    location_name VARCHAR(30) NOT NULL,
    PRIMARY KEY(location_name),
    FOREIGN KEY (location_name) REFERENCES LOCATION (lname)
);
CREATE TABLE NURSE
(
    nlicense_no   INTEGER NOT NULL,
    nname         VARCHAR(30) NOT NULL,
    nlocationname VARCHAR(30),
    PRIMARY KEY (nlicense_no),
    FOREIGN KEY (nlocationname) REFERENCES HOSPITAL (location_name)
);
CREATE TABLE VACCINE
(
    vname         VARCHAR(30) NOT NULL,
    vwaitperiod   INTEGER DEFAULT NULL,
    vdoses        INTEGER DEFAULT NULL,
    vmanufacturer VARCHAR(30),
    PRIMARY KEY (vname)
);
CREATE TABLE BATCH
(
    vname              VARCHAR(30) NOT NULL,
    batch_no           INTEGER NOT NULL,
    bdate_expire       DATE,
    bdate_manufactured DATE,
    bvials_quantity   INTEGER,
    blocation_name     VARCHAR(30),
    PRIMARY KEY (vname, batch_no),
    FOREIGN KEY (vname) REFERENCES VACCINE (vname),
    FOREIGN KEY (blocation_name) references location (lname)
);
CREATE TABLE VIAL
(
    vname    VARCHAR(30) not null,
    batch_no INTEGER NOT NULL,
    vial_id  INTEGER NOT NULL,
    PRIMARY KEY (vname, batch_no, vial_id)
);
CREATE TABLE VACCDATE
(
    tdate   DATE    NOT NULL,
    locname VARCHAR(30) NOT NULL,
    PRIMARY KEY (tdate, locname),
    FOREIGN KEY (locname) REFERENCES LOCATION (lname)
);
CREATE TABLE TIMESLOT
(
    tslot           INTEGER NOT NULL,
    ttime           TIME    NOT NULL,
    tdate           DATE    NOT NULL,
    locname         VARCHAR(30) NOT NULL,
    health_ins_num  VARCHAR(12) DEFAULT NULL,
    tdate_allocated DATE DEFAULT NULL,
    vname           VARCHAR(30) DEFAULT NULL,
    batchno         INTEGER DEFAULT NULL,
    vialid          INTEGER DEFAULT NULL,
    PRIMARY KEY (tslot, ttime, tdate, locname),
    FOREIGN KEY (locname, tdate) REFERENCES VACCDATE (locname, tdate),
    FOREIGN KEY (health_ins_num) REFERENCES PERSON (phealth_ins_num),
    FOREIGN KEY (vname, batchno, vialid) REFERENCES VIAL (vname, batch_no, vial_id)
);

CREATE TABLE NURSEASSIG
(
    licensenum INTEGER NOT NULL,
    locname    VARCHAR(30) NOT NULL,
    vdate      DATE NOT NULL,
    PRIMARY KEY (licensenum, locname, vdate),
    FOREIGN KEY (licensenum) REFERENCES NURSE (nlicense_no),
    FOREIGN KEY (locname, vdate) REFERENCES VACCDATE (locname, tdate)
);
#!/bin/bash

BASEDIR=`eval basename $(dirname $PWD)`

if [[ $BASEDIR == 'PG-342567987' ]] || [[ $BASEDIR == 'PG-XXXXXXXXX' ]]
then
	echo "Fatal error !! Please rename your directory $BASEDIR to include your student id as per the instructions given with the assignment!"
	exit 1
fi

if ! [[ $BASEDIR =~ PG-[1-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] ]]
then
	echo "Fatal error !! Please rename your directory $BASEDIR to include your student id as per the instructions given with the assignment!"
	exit 1
fi

psql cs421 --echo-all <<-END 2>&1 | tee setup.log

CREATE TABLE project
(
	pname VARCHAR(30) NOT NULL
  ,pstartdate DATE NOT NULL
	,ptype VARCHAR(15) NOT NULL
	,budget INTEGER NOT NULL
  ,PRIMARY KEY (pname)
);

CREATE TABLE developer
(
  employeeid INTEGER NOT NULL
  ,ename VARCHAR(30) NOT NULL
  ,PRIMARY KEY (employeeid)
);


CREATE TABLE document
(
	 documentid INTEGER NOT NULL
  ,dname VARCHAR(50) NOT NULL
  ,publishdate DATE NOT NULL
	,pname VARCHAR(30) NOT NULL
  ,PRIMARY KEY (documentid)
  ,FOREIGN KEY(pname) REFERENCES project(pname)
);

CREATE TABLE devassignments
(
   employeeid INTEGER NOT NULL
	,pname VARCHAR(30) NOT NULL
  ,asgndate DATE NOT NULL
  ,PRIMARY KEY(employeeid,pname)
  ,FOREIGN KEY(employeeid) REFERENCES developer(employeeid)
  ,FOREIGN KEY(pname) REFERENCES project(pname)
);

CREATE TABLE documentauthors
(
   employeeid INTEGER NOT NULL
  ,documentid INTEGER NOT NULL
  ,PRIMARY KEY (employeeid, documentid)
  ,FOREIGN KEY(employeeid) REFERENCES developer(employeeid)
  ,FOREIGN KEY(documentid) REFERENCES document(documentid)
);


INSERT INTO project VALUES('Charles', '2019-12-08', 'internal', 6300000);
INSERT INTO project VALUES('Otters', '2020-05-13', 'internal', 46100000);
INSERT INTO project VALUES('Kodiak', '2020-05-20', 'external', 50000000);
INSERT INTO project VALUES('Capybara', '2020-08-22', 'external', 19500000);
INSERT INTO project VALUES('Snowy', '2021-01-12', 'external', 4500000);
INSERT INTO project VALUES('Albatrose', '2021-01-20', 'internal', 3500000);
INSERT INTO project VALUES('Haddock', '2021-01-23', 'external', 2400000);
INSERT INTO project VALUES('Walleye', '2021-01-23', 'internal', 12000000);


INSERT INTO developer VALUES(81532, 'May Owens');
INSERT INTO developer VALUES(82102, 'Milly Fulton');
INSERT INTO developer VALUES(82453, 'Tom Smith');
INSERT INTO developer VALUES(85473, 'Bob Williams');
INSERT INTO developer VALUES(87634, 'Alice Kay');
INSERT INTO developer VALUES(87642, 'Jane Doe');
INSERT INTO developer VALUES(89374, 'Isabel Lee');
INSERT INTO developer VALUES(90234, 'Melanie Carson');
INSERT INTO developer VALUES(91243, 'Emery Woods');
INSERT INTO developer VALUES(93401, 'Zara Haas');
INSERT INTO developer VALUES(93752, 'John Doe');
INSERT INTO developer VALUES(94857, 'Issac Harrison');


INSERT INTO devassignments VALUES(82102, 'Charles', '2019-12-08');
INSERT INTO devassignments VALUES(82453, 'Charles', '2019-12-08');
INSERT INTO devassignments VALUES(87634, 'Charles', '2020-02-04');
INSERT INTO devassignments VALUES(93401, 'Otters', '2020-05-13');
INSERT INTO devassignments VALUES(93752, 'Otters', '2020-05-13');
INSERT INTO devassignments VALUES(89374, 'Otters', '2020-08-01');
INSERT INTO devassignments VALUES(82102, 'Kodiak', '2020-06-07');
INSERT INTO devassignments VALUES(87642, 'Kodiak', '2020-06-07');
INSERT INTO devassignments VALUES(82453, 'Kodiak', '2020-08-04');
INSERT INTO devassignments VALUES(81532, 'Kodiak', '2020-08-04');
INSERT INTO devassignments VALUES(91243, 'Kodiak', '2020-08-04');
INSERT INTO devassignments VALUES(81532, 'Capybara', '2020-09-13');
INSERT INTO devassignments VALUES(94857, 'Capybara', '2020-10-14');
INSERT INTO devassignments VALUES(87634, 'Snowy', '2021-01-13');
INSERT INTO devassignments VALUES(89374, 'Snowy', '2021-01-19');
INSERT INTO devassignments VALUES(93752, 'Albatrose', '2021-01-21');
INSERT INTO devassignments VALUES(82453, 'Albatrose', '2021-01-29');
INSERT INTO devassignments VALUES(81532, 'Walleye', '2021-01-25');
INSERT INTO devassignments VALUES(93401, 'Walleye', '2021-01-25');
INSERT INTO devassignments VALUES(90234, 'Walleye', '2021-01-28');


INSERT INTO document VALUES(1, 'Proposal', '2019-12-08', 'Charles');
INSERT INTO document VALUES(4, 'Implementation Design', '2020-01-20', 'Charles');
INSERT INTO document VALUES(9, 'Evaluation', '2020-04-20', 'Charles');
INSERT INTO document VALUES(12, 'Case Study', '2020-05-17', 'Otters');
INSERT INTO document VALUES(17, 'Alternative Approach', '2020-07-28', 'Otters');
INSERT INTO document VALUES(19, 'Project Summary', '2020-09-15', 'Otters');
INSERT INTO document VALUES(21, 'External Requests', '2020-07-11', 'Kodiak');
INSERT INTO document VALUES(22, 'System Test Cases', '2020-09-21', 'Kodiak');
INSERT INTO document VALUES(23, 'Architectural Modification', '2020-10-25', 'Kodiak');
INSERT INTO document VALUES(27, 'Performance Evaluation', '2020-11-30', 'Kodiak');
INSERT INTO document VALUES(29, 'Case Study', '2020-08-22', 'Capybara');
INSERT INTO document VALUES(33, 'Implementation Design', '2020-11-01', 'Capybara');
INSERT INTO document VALUES(39, 'Modified Requirements', '2021-02-01', 'Snowy');
INSERT INTO document VALUES(45, 'Initial Proposal', '2021-01-22', 'Albatrose');
INSERT INTO document VALUES(47, 'Design Details', '2021-02-01', 'Albatrose');
INSERT INTO document VALUES(51, 'Proposal', '2021-01-23', 'Walleye');


INSERT INTO documentauthors VALUES(82102,1);
INSERT INTO documentauthors VALUES(81532,1);
INSERT INTO documentauthors VALUES(82102,4);
INSERT INTO documentauthors VALUES(82453,4);
INSERT INTO documentauthors VALUES(82102,9);
INSERT INTO documentauthors VALUES(82453,9);
INSERT INTO documentauthors VALUES(87634,9);
INSERT INTO documentauthors VALUES(93401,12);
INSERT INTO documentauthors VALUES(93401,17);
INSERT INTO documentauthors VALUES(93401,19);
INSERT INTO documentauthors VALUES(89374,19);
INSERT INTO documentauthors VALUES(82102,21);
INSERT INTO documentauthors VALUES(82102,22);
INSERT INTO documentauthors VALUES(93401,22);
INSERT INTO documentauthors VALUES(93401,23);
INSERT INTO documentauthors VALUES(90234,23);
INSERT INTO documentauthors VALUES(82102,27);
INSERT INTO documentauthors VALUES(82453,27);
INSERT INTO documentauthors VALUES(87642,27);
INSERT INTO documentauthors VALUES(91243,29);
INSERT INTO documentauthors VALUES(81532,33);
INSERT INTO documentauthors VALUES(94857,33);
INSERT INTO documentauthors VALUES(93401,39);
INSERT INTO documentauthors VALUES(82453,45);
INSERT INTO documentauthors VALUES(82453,47);
INSERT INTO documentauthors VALUES(93752,47);
INSERT INTO documentauthors VALUES(90234,51);


END
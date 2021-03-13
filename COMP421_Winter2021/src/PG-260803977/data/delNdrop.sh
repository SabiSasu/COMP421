psql cs421 --echo-all <<-END 2>&1 | tee delNdrop.log

DROP TABLE documentauthors;
DROP TABLE devassignments;
DROP TABLE document;
DROP TABLE project;
DROP TABLE developer;

END

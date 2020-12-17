CREATE TABLE Student (
    Sno CHAR(5) NOT NULL UNIQUE,
    Sname CHAR(20) UNIQUE,
    Ssex CHAR(1),
    Sage INT,
    Sdept CHAR(15),
    Scholarship CHAR(2)
);
CREATE TABLE SC(
    Sno CHAR(5),
    Cno CHAR(3),
    Grade int,
    Primary key (Sno, Cno)
);
CREATE TABLE SC (
    Sno CHAR(9),
    Cno CHAR(4),
    Grade SMALLINT
);
DROP TABLE Student;
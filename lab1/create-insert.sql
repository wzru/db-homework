CREATE DATABASE S_T_U201814867 CHARACTER SET utf8 COLLATE utf8_general_ci;
USE S_T_U201814867;
CREATE TABLE Student (
    Sno CHAR(9) PRIMARY KEY,
    Sname CHAR(20) UNIQUE,
    Ssex CHAR(2),
    Sage SMALLINT,
    Sdept CHAR(20),
    Scholarship char(2)
);
CREATE TABLE Course (
    Cno CHAR(4) PRIMARY KEY,
    Cname CHAR(40),
    Cpno CHAR(4),
    Ccredit SMALLINT,
    FOREIGN KEY (Cpno) REFERENCES Course(Cno)
);
CREATE TABLE SC (
    Sno CHAR(9),
    Cno CHAR(4),
    Grade SMALLINT,
    primary key (Sno, Cno),
    FOREIGN KEY (Sno) REFERENCES Student(Sno),
    FOREIGN KEY (Cno) REFERENCES Course(Cno)
);
INSERT INTO Student
VALUES('200215121', '李勇', '男', 20, 'CS', '否');
INSERT INTO Student
VALUES('200215122', '刘晨', '女', 19, 'CS', '否');
INSERT INTO Student
VALUES('200215123', '王敏', '女', 18, 'MA', '否');
INSERT INTO Student
VALUES('200215125', '张立', '男', 19, 'IS', '否');
/*为表 Student 添加数据*/
INSERT INTO Course
VALUES('1', '数据库', NULL, 4);
INSERT INTO Course
VALUES('2', '数学', NULL, 2);
INSERT INTO Course
VALUES('3', '信息系统', NULL, 4);
INSERT INTO Course
VALUES('4', '操作系统', NULL, 3);
INSERT INTO Course
VALUES('5', '数据结构', NULL, 4);
INSERT INTO Course
VALUES('6', '数据处理', NULL, 2);
INSERT INTO Course
VALUES('7', 'java', NULL, 4);
UPDATE Course
SET Cpno = '5'
WHERE Cno = '1';
UPDATE Course
SET Cpno = '1'
WHERE Cno = '3';
UPDATE Course
SET Cpno = '6'
WHERE Cno = '4';
UPDATE Course
SET Cpno = '7'
WHERE Cno = '5';
UPDATE Course
SET Cpno = '6'
WHERE Cno = '7';
/*为表 Course 添加数据*/
INSERT INTO SC
VALUES('200215121', '1', 92);
INSERT INTO SC
VALUES('200215121', '2', 85);
INSERT INTO SC
VALUES('200215121', '3', 88);
INSERT INTO SC
VALUES('200215122', '2', 90);
INSERT INTO SC
VALUES('200215122', '3', 80);
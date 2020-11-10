-- （1）查询每门课程及其被选情况（输出所有课程中每门课的课程号、课程名称、选修该课程的学生学号及成绩。如果没有学生选择该课，则相应的学生学号及成绩为空值）。
SELECT Course.Cno,
    Course.Cname,
    Student.Sno,
    SC.Grade
FROM Course,
    SC,
    Student
WHERE Course.Cno = SC.Cno
    AND SC.Sno = Student.Sno;
-- （2）查询与“张立”同岁的学生的学号、姓名和年龄。（要求使用至少 3 种方法求解）
-- 方法一
SELECT Sno,
    Sname,
    Sage
FROM Student
WHERE Sage =(
        SELECT Sage
        FROM Student
        WHERE Sname = "张立"
    );
-- 方法二
SELECT Sno,
    Sname,
    Sage
FROM Student
WHERE Sage IN(
        SELECT Sage
        FROM Student
        WHERE Sname = "张立"
    );
-- 方法三
SELECT s1.Sno,
    s1.Sname,
    s1.Sdept
FROM Student s1,
    Student s2
WHERE s1.Sage = s2.Sage
    AND s2.Sname = '刘晨';
-- 方法四
SELECT Sno,
    Sname,
    Sdept
FROM Student S1
WHERE EXISTS (
        SELECT *
        FROM Student S2
        WHERE S2.Sage = S1.Sage
            AND S2.Sname = '刘晨'
    );
-- （3）查询选修了 3 号课程而且成绩为良好（80~89 分）的所有学生的学号和姓名。
SELECT Sno,
    Sname
FROM Student
WHERE Sno IN (
        SELECT Sno
        FROM SC
        WHERE Cno = "3"
            AND Grade BETWEEN 80 AND 89
    );
-- （4）查询学生 200215122 选修的课程号、课程名 （思考：如何查询学生 200215122 选修的课程号、课程名及成绩？）
SELECT Course.Cno,
    Course.Cname
FROM Course,
    SC
WHERE Course.Cno = SC.Cno
    AND SC.Sno = "200215122";
-- （5）找出每个学生低于他所选修课程平均成绩 5 分以上的课程号。（输出学号和课程号）
SELECT Sno,
    Cno
FROM SC
WHERE Grade + 5 < (
        SELECT AVG(T.Grade)
        FROM SC AS T
        WHERE T.Cno = SC.Cno
        GROUP BY T.Cno
    );
-- （6）查询比所有男生年龄都小的女生的学号、姓名和年龄。
SELECT Sno,
    Sname,
    Sage
FROM Student
WHERE Ssex = "女"
    AND Sage < (
        SELECT MIN(Sage)
        FROM Student
        WHERE Ssex = "男"
    );
-- （7）查询所有选修了 2 号课程的学生姓名及所在系。
SELECT Sname,
    Sdept
FROM Student
WHERE Sno IN (
        SELECT Sno
        FROM SC
        WHERE Cno = "2"
    );
-- （8）使用 update 语句把成绩为良的学生的年龄增加 2 岁，并查询出来。
UPDATE Student
SET Sage = Sage + 2
WHERE Sno IN (
        SELECT DISTINCT Sno
        FROM SC
        WHERE Grade BETWEEN 80 AND 89
    );
SELECT Sname,
    Sage
FROM Student
WHERE Sno IN (
        SELECT DISTINCT Sno
        FROM SC
        WHERE Grade BETWEEN 80 AND 89
    );
-- （9）使用 insert 语句增加两门课程：C 语言和人工智能，并查询出来
INSERT INTO Course(Cname, Cno)
VALUES("C语言", "8"),
    ("人工智能", "9");
SELECT *
FROM Course
WHERE Cname IN ("C语言", "人工智能");
-- （10）使用 delete 语句把人工智能课程删除，并查询出来。
DELETE FROM Course
WHERE Cname = "人工智能";
SELECT *
FROM Course
WHERE Cname = "人工智能";
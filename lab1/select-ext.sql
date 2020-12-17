-- （1）查询全体学生的学号、姓名和年龄；
SELECT Sno,
    Sname,
    Sage
FROM Student;
-- （2）查询所有计算机系学生的详细记录；
SELECT *
FROM Student
WHERE Sdept = "CS";
-- （3）找出考试成绩为优秀（90 分及以上）或不及格的学生的学号、课程号及成绩；
SELECT Sno,
    Cno,
    Grade
FROM SC
WHERE Grade >= 90
    OR Grade < 60;
-- （4）查询年龄不在 19~20 岁之间的学生姓名、性别和年龄；
SELECT Sname,
    Ssex,
    Sage
FROM Student
WHERE Sage NOT BETWEEN 19 AND 20;
-- （5）查询数学系（MA）、信息系（IS)的学生的姓名和所在系；
SELECT Sname,
    Sdept
FROM Student
WHERE Sdept IN ("MA", "CS");
-- （6）查询名称中包含“数据”的所有课程的课程号、课程名及其学分；
SELECT Cno,
    Cname,
    Ccredit
FROM Course
WHERE Cname LIKE "%数据%";
-- （7） 找出所有没有选修课成绩的学生学号和课程号；
SELECT Sno,
    Cno
FROM SC
WHERE Grade = NULL;
-- （8）查询学生 200215121 选修课的最高分、最低分以及平均成绩；
SELECT MAX(Grade),
    MIN(Grade),
    AVG(Grade)
FROM SC
WHERE Sno = "200215121";
-- （9）查询选修了 2 号课程的学生的学号及其成绩，查询结果按成绩升序排列；
SELECT Sno,
    Grade
FROM SC
WHERE Cno = "2"
ORDER BY Grade ASC;
-- （10）查询每个系名及其学生的平均年龄。
SELECT Sdept,
    AVG(Sage)
FROM Student
GROUP BY Sdept;
--  （思考：如何查询学生平均年龄在 19 岁以下（含 19 岁）的系别及其学生的平均年龄？）
SELECT Sdept,
    AVG(Sage)
FROM Student
GROUP BY Sdept
HAVING AVG(Sage) <= 19;
-- 例如：查询全体学生的详细记录。
SELECT Sno,
    Sname,
    Ssex,
    Sage,
    Sdept
FROM Student;
-- 例如：查询选修 2 号课程且成绩在 90 分以上的所有学生的学号、姓名
SELECT Student.Sno,
    Student.Sname
FROM Student,
    SC
WHERE Student.Sno = SC.Sno
    AND SC.Cno = '2'
    AND SC.Grade > 90;
-- 例如：查询信息系（IS）、数学系（MA）和计算机科学系（CS）学生的姓名和性别。
SELECT Sname,
    Ssex
FROM Student
WHERE Sdept IN ('IS', 'MA', 'CS');
-- 例如：查询年龄在 20~23 岁（包括 20 岁和 23 岁）之间的学生的姓名、系别和年龄。
SELECT Sname,
    Sdept,
    Sage
FROM Student
WHERE Sage BETWEEN 20 AND 23;
-- 例如：查询所有姓刘学生的姓名、学号和性别。
SELECT Sname,
    Sno,
    Ssex
FROM Student
WHERE Sname LIKE '刘%';
-- 例如：查询选修了 3 号课程的学生的学号及其成绩，查询结果按分数降序排列。
SELECT Sno,
    Grade
FROM SC
WHERE Cno = '3'
ORDER BY Grade DESC;
-- 例如：计算 1 号课程的学生平均成绩。
SELECT AVG(Grade)
FROM SC
WHERE Cno = '1';
-- 例如：查询选修了 3 门以上课程的学生学号。
SELECT Sno
FROM SC
GROUP BY Sno
HAVING COUNT(*) > 3;
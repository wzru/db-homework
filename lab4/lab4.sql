SELECT Sdept AS 院系,
    AVG(Grade) AS 平均成绩,
    MAX(Grade) AS 最好成绩,
    MIN(Grade) AS 最差成绩,
    SUM(Grade >= 80) / COUNT(*) AS 优秀率,
    SUM(Grade < 60) AS 不及格人次
FROM Student,
    SC
WHERE SC.Sno = Student.Sno
GROUP BY Sdept;
SELECT Student.Sno AS sno,
    Student.Sname AS sname,
    SC.Cno AS cno,
    Course.Cname AS cname,
    SC.Grade AS grade
FROM Student,
    Course,
    SC
WHERE Student.Sdept = "CS"
    AND Student.Sno = SC.Sno
    AND Course.Cno = SC.Cno
ORDER BY SC.Grade DESC;
DELETE FROM Course
WHERE Cno NOT IN(
        SELECT DISTINCT Cno
        FROM SC
    );
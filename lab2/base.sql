-- （1） 等值连接查询与自然连接查询 例如 ： 查询每个学生及其选修课的情况 。
SELECT Student.*,
    SC.*
FROM Student,
    SC
WHERE Student.Sno = SC.Sno;
/* 一般等值连接 */
-- 又如 ： 查询每个学生及其选修课的情况 （ 去掉重复列 ） 。
SELECT Student.Sno,
    Sname,
    Ssex,
    Sage,
    Cno,
    Grade
FROM Student,
    SC
WHERE Student.Sno = SC.Sno;
/* 自然连接--特殊的等值连接 */
-- （2） 自身连接查询 例如 ： 查询每一门课的间接先修课 。
SELECT FIRST.Cno,
    SECOND.Cpno
FROM Course FIRST,
    Course SECOND
WHERE FIRST.Cpno = SECOND.Cno;
-- （3） 外连接查询 例如 ： 查询每个学生及其选修课的情况 （ 要求输出所有学生 --含未选修课程的学生的情况）
SELECT Student.Sno,
    Sname,
    Ssex,
    Sage,
    Sdept,
    Cno,
    Grade
FROM Student
    LEFT OUTER JOIN SC ON(Student.Sno = SC.Sno);
-- （ 4 ） 复合条件连接查询 例如 ： 查询选修了 2 号课程而且成绩在 90 以上的所有学生的学号和姓名 。
SELECT Student.Sno,
    Sname
FROM Student,
    SC
WHERE Student.Sno = SC.Sno
    AND SC.Cno = '2'
    AND SC.Grade >= 90;
-- 又如 ： 查询每个学生的学号 、 姓名 、 选修的课程名及成绩 。
SELECT Student.Sno,
    Sname,
    Cname,
    Grade
FROM Student,
    SC,
    Course
WHERE Student.Sno = SC.Sno
    AND SC.Cno = Course.Cno;
-- （ 5 ） 嵌套查询 （ 带有 IN 谓词的子查询 ） 例如 ： 查询与 “ 刘晨 ” 在同一个系学习的学生的学号 、 姓名和所在系 。
SELECT Sno,
    Sname,
    Sdept
FROM Student
WHERE Sdept IN (
        SELECT Sdept
        FROM Student
        WHERE Sname = '刘晨'
    );
/* 解法一*/
-- 可以将本查询中的 IN 谓词用比较运算符 ‘ = ’ 来代替 ：
SELECT Sno,
    Sname,
    Sdept
FROM Student
WHERE Sdept = (
        SELECT Sdept
        FROM Student
        WHERE Sname = '刘晨'
    );
/* 解法二*/
-- 也可以使用自身连接完成以上查询 ：
SELECT s1.Sno,
    s1.Sname,
    s1.Sdept
FROM Student s1,
    Student s2
WHERE s1.Sdept = s2.Sdept
    AND s2.Sname = '刘晨';
/* 解法三*/
-- 还可以使用 EXISTS 谓词完成本查询 ：
SELECT Sno,
    Sname,
    Sdept
FROM Student S1
WHERE EXISTS (
        SELECT *
        FROM Student S2
        WHERE S2.Sdept = S1.Sdept
            AND S2.Sname = '刘晨'
    );
/* 解法四*/
-- 又如 ： 查询选修了课程名为 “信息系统” 的学生号和姓名 。
SELECT Sno,
    Sname
FROM Student
WHERE Sno IN (
        SELECT Sno
        FROM SC
        WHERE Cno IN (
                SELECT Cno
                FROM Course
                WHERE Cname = '信息系统'
            )
    );
-- 也可以使用连接查询来完成上述查询 ：
SELECT Student.Sno,
    Sname
FROM Student,
    SC,
    Course
WHERE Student.Sno = SC.Sno
    AND SC.Cno = Course.Cno
    AND Course.Cname = '信息系统';
-- （ 6 ） 嵌套查询 （ 带有比较运算符的子查询 ） 例如 ： 找出每个学生超过他所选修课程平均成绩的课程号 。
SELECT Sno,
    Cno
FROM SC x
WHERE Grade >= (
        SELECT AVG(Grade)
        FROM SC y
        WHERE y.Sno = x.Sno
    );
-- （7） 嵌套查询 （ 带有 ANY 或 ALL 谓词的子查询 ） 例如 ： 查询其他系中比计算机系某个学生年龄小的学生的姓名和年龄 。
SELECT Sname,
    Sage
FROM Student
WHERE Sage < ANY (
        SELECT Sage
        FROM Student
        WHERE Sdept = 'CS'
    )
    AND Sdept <> 'CS';
-- 本查询也可以使用聚集函数来实现 ：
SELECT Sname,
    Sage
FROM Student
WHERE Sage < (
        SELECT MAX(Sage)
        FROM Student
        WHERE Sdept = 'CS'
    )
    AND Sdept <> 'CS';
-- 又如 ： 查询其他系中比计算机系所有学生年龄都小的学生的姓名和年龄 。
SELECT Sname,
    Sage
FROM Student
WHERE Sage < ALL (
        SELECT Sage
        FROM Student
        WHERE Sdept = 'CS'
    )
    AND Sdept <> 'CS';
-- 也可以使用聚集函数来实现 ：
SELECT Sname,
    Sage
FROM Student
WHERE Sage < (
        SELECT MIN(Sage)
        FROM Student
        WHERE Sdept = 'CS'
    )
    AND Sdept <> 'CS';
-- （8） 嵌套查询 （ 带有 EXISTS 谓词的子查询 ） 例如 ： 查询所有选修了 1 号课程的学生姓名 。
SELECT Sname
FROM Student
WHERE EXISTS (
        SELECT *
        FROM SC
        WHERE Sno = Student.Sno
            AND Cno = '1'
    );
-- 又如 ： 查询所有未选修 1 号课程的学生姓名 。
SELECT Sname
FROM Student
WHERE NOT EXISTS (
        SELECT *
        FROM SC
        WHERE Sno = Student.Sno
            AND Cno = '1'
    );
-- 可以使用带有 EXISTS 谓词的子查询实现全称量词或蕴涵逻辑运算功能 ： 例如 ： 查询选修了全部课程的学生姓名 。
SELECT Sname
FROM Student
WHERE NOT EXISTS (
        SELECT *
        FROM Course
        WHERE NOT EXISTS (
                SELECT *
                FROM SC
                WHERE Sno = Student.Sno
                    AND Cno = Course.Cno
            )
    );
-- 又如 ： 查询至少选修了学生 200215122 选修的全部课程的学生号码 。
SELECT DISTINCT Sno
FROM SC SCX
WHERE NOT EXISTS (
        SELECT *
        FROM SC SCY
        WHERE SCY.Sno = '200215122'
            AND NOT EXISTS (
                SELECT *
                FROM SC SCZ
                WHERE SCZ.Sno = SCX.Sno
                    AND SCZ.Cno = SCY.Cno
            )
    );
-- （ 9 ） 集合查询 例如 ： 查询计算机系的学生以及年龄不大于 19 岁的的学生 。
SELECT *
FROM Student
WHERE Sdept = 'CS'
UNION
SELECT *
FROM Student
WHERE Sage <= 19;
-- 可以改用多重条件查询 ：
SELECT *
FROM Student
WHERE Sdept = 'CS'
    OR Sage <= 19;
-- 又如 ： 查询既选修了课程 1 又选修了课程 2 的学生 （ 交集运算 ） 。
SELECT Sno
FROM SC
WHERE Cno = '1'
INTERSECT
SELECT Sno
FROM SC
WHERE Cno = '2';
-- 可以使用嵌套查询 ：
SELECT Sno
FROM SC
WHERE Cno = '1'
    AND Sno IN (
        SELECT Sno
        FROM SC
        WHERE Cno = '2'
    );
-- 思考 ： 能不能改用多重条件查询 ？
SELECT Sno
FROM SC
WHERE Cno = '1'
    AND Cno = '2';
-- 再如 ： 查询计算机系的学生与年龄不大于 19 岁的学生的差集 。
SELECT *
FROM Student
WHERE Sdept = 'CS'
EXCEPT
SELECT *
FROM Student
WHERE Sage <= 19;
-- 可以改用多重条件查询 ：
SELECT *
FROM Student
WHERE Sdept = 'CS'
    AND Sage > 19;
-- (10)update 语句用于对表进行更新 例如 ： 将信息系所有学生的年龄增加 1 岁 。
UPDATE Student
SET Sage = Sage + 1
WHERE Sdept = 'IS';
-- (11) delete 语句用于对表进行删除 例如 ： 删除学号为 95019 的学生记录 。
DELETE FROM Student
WHERE Sno = '95019';
-- (12) insert 语句用于对表进行插入 例如 ： 插入一条选课记录('95020' , '1') 。
INSERT INTO SC(Sno, Cno)
VALUES ('95020', '1')
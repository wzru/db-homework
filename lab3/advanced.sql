-- (1)创建 CS 系的视图 CS_View
CREATE VIEW CS_View AS
SELECT *
FROM Student
WHERE Sdept = "CS";
-- (2)在视图 CS_View 上查询 CS 系选修了 1 号课程的学生
SELECT *
FROM CS_View
WHERE Sno IN (
        SELECT Sno
        FROM SC
        WHERE Cno = "1"
    );
-- (3)创建 IS 系成绩大于 80 的学生的视图 IS_View
CREATE VIEW IS_View AS
SELECT *
FROM Student
WHERE Sdept = "IS"
    AND Sno IN (
        SELECT Sno
        FROM SC
        WHERE Grade > 80
    );
-- (4)在视图 IS_View 查询 IS 系成绩大于 80 的学生
SELECT *
FROM IS_View
WHERE Sdept = "IS"
    AND Sno IN (
        SELECT Sno
        FROM SC
        WHERE Grade > 80
    );
-- (5)删除视图 IS_View
DROP VIEW IS_View;
-- (6) 利用可视化窗口创建 2 个不同的用户 U1 和 U2,利用系统管理员给 U1 授予 Student 表的查询和更新的权限，给 U2 对 SC 表授予插入的权限。然后用 U1 登录，分别
GRANT SELECT,
    UPDATE ON S_T_U201814867.Student to 'U1' @'%';
GRANT INSERT ON S_T_U201814867.SC to 'U2' @'%';
FLUSH PRIVILEGES;
-- 1）查询学生表的信息；
SELECT *
FROM Student;
-- 2）把所有学生的年龄增加 1 岁，然后查询；
UPDATE Student
SET Sage = Sage + 1;
SELECT *
FROM Student;
-- 3）删除 IS 系的学生；
DELETE FROM Student
WHERE Sdept = 'IS';
-- 4）查询 CS 系的选课信息。
SELECT *
FROM SC
WHERE Sno IN (
        SELECT Sno
        FROM Student
        WHERE Sdept = 'CS'
    );
-- 用 U2 登录，分别 
-- 1）在 SC 表中插入 1 条记录('200215122','1',75);
INSERT INTO SC(Sno, Cno, Grade)
VALUES('200215122', '1', 75);
-- 2）查询 SC 表的信息，
SELECT *
FROM SC;
-- 3）查询视图 CS_View 的信息。
SELECT *
FROM CS_View;
-- (7) 用系统管理员登录，收回 U1 的所有权限
REVOKE ALL PRIVILEGES ON S_T_U201814867.Student
FROM 'U1';
-- (8) 用 U1 登录，查询学生表的信息
SELECT *
FROM S_T_U201814867.Student;
-- (9)用系统管理员登录
-- (10)对 SC 表建立一个更新触发器，当更新了 SC 表的成绩时，如果更新后的成绩大于等于95，则检查该成绩的学生是否有奖学金，如果奖学金是“否”，则修改为“是”。
-- 如果修改后的成绩小于 95，则检查该学生的其他成绩是不是有大于 95 的，如果都没有，且修改前的成绩是大于 95 时，则把其奖学金修改为”否”。
DELIMITER $$ 
CREATE TRIGGER upd_sc
AFTER
UPDATE ON SC FOR EACH ROW BEGIN IF NEW.Grade >= 95 THEN
UPDATE Student
SET Student.Scholarship = '是'
WHERE Student.Sno = OLD.Sno;
ELSE IF OLD.Grade >= 95
AND (
    NOT EXISTS(
        SELECT *
        FROM SC AS T
        WHERE T.Sno = OLD.Sno
            AND T.Cno = OLD.Cno
            AND T.Grade >= 95
    )
) THEN
UPDATE Student
SET Student.Scholarship = '否'
WHERE Student.Sno = OLD.Sno;
END IF;
END IF;
END $$;
-- 然后进行成绩修改，并进行验证是否触发器正确执行。1）首先把某个学生成绩修改为 98，查询其奖学金。2）再把刚才的成绩修改为 80，再查询其奖学金。
-- (11)删除刚定义的触发器
DROP TRIGGER upd_sc;
-- (12)定义一个存储过程计算 CS 系的课程的平均成绩和最高成绩，在查询分析器或查询编辑器中执行存储过程，查看结果。
DELIMITER $$ 
CREATE PROCEDURE calc_grd() BEGIN
SELECT Cno,
    AVG(Grade),
    MAX(Grade)
FROM SC
WHERE Sno IN (
        SELECT Sno
        FROM Student
        WHERE Sdept = 'CS'
    )
GROUP BY Cno;
END $$;
-- (13)定义一个带学号为参数的查看某个学号的所有课程的成绩，查询结果要包含学生姓名。进行验证。
DELIMITER $$ 
CREATE PROCEDURE query_grd(IN no char(9)) BEGIN
SELECT Student.Sname,
    SC.Cno,
    SC.Grade
FROM Student,
    SC
WHERE Student.Sno = no
    AND SC.Sno = no;
END $$;
CALL query_grd('200215121');
-- (14)把上一题改成函数。再进行验证。
SET GLOBAL log_bin_trust_function_creators = 1;
DELIMITER $$ 
CREATE FUNCTION func_query_grd(no char(9)) RETURNS INT BEGIN CREATE TEMPORARY TABLE Grade(
    SELECT Student.Sname,
        SC.Cno,
        SC.Grade
    FROM Student,
        SC
    WHERE Student.Sno = no
        AND SC.Sno = no
);
RETURN 0;
END $$;
SELECT func_query_grd('200215121');
SELECT *
FROM Grade 
-- (15)在 SC 表上定义一个完整性约束，要求成绩再 0-100 之间。定义约束前，先把某个学生的成绩修改成 120，进行查询，再修改回来。定义约束后，再把该学生成绩修改为 120，然后进行查询。
ALTER TABLE SC
ADD CONSTRAINT CK_GRADE check(
        Grade BETWEEN 0 AND 100
    );
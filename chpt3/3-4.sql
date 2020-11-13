-- 建库建表
CREATE DATABASE T3_4;
USE T3_4;
CREATE TABLE S(
    SNO CHAR(3) PRIMARY KEY,
    SNAME CHAR(10),
    STATUS CHAR(2),
    CITY CHAR(10)
);
CREATE TABLE P(
    PNO CHAR(3),
    PNAME CHAR(10),
    COLOR CHAR(4),
    WEIGHT INT,
    PRIMARY KEY(PNO)
);
CREATE TABLE J(
    JNO CHAR(3),
    JNAME CHAR(10),
    CITY CHAR(10),
    PRIMARY KEY(JNO)
);
CREATE TABLE SPJ(
    SNO CHAR(3),
    PNO CHAR(3),
    JNO CHAR(3),
    QTY INT,
    PRIMARY KEY(SNO, PNO, JNO),
    FOREIGN KEY(SNO) REFERENCES S(SNO),
    FOREIGN KEY(PNO) REFERENCES P(PNO),
    FOREIGN KEY(JNO) REFERENCES J(JNO)
);
INSERT INTO S(SNO, SNAME, STATUS, CITY)
VALUES('S1', '精益', '20', '天津'),
    ('S2', '盛锡', '10', '北京'),
    ('S3', '东方红', '30', '北京'),
    ('S4', '丰泰盛', '20', '天津'),
    ('S5', '为民', '30', '上海');
INSERT INTO P
VALUES('P1', '螺母', '红', 12),
    ('P2', '螺栓', '绿', 17),
    ('P3', '螺丝刀', '蓝', 14),
    ('P4', '螺丝刀', '红', 14),
    ('P5', '凸轮', '蓝', 40),
    ('P6', '齿轮', '红', 30);
INSERT INTO J
VALUES('J1', '三建', '北京');
INSERT INTO J
VALUES('J2', '一汽', '长春');
INSERT INTO J
VALUES('J3', '弹簧厂', '天津');
INSERT INTO J
VALUES('J4', '造船厂', '天津');
INSERT INTO J
VALUES('J5', '机车厂', '唐山');
INSERT INTO J
VALUES('J6', '无限电厂', '常州');
INSERT INTO J
VALUES('J7', '半导体厂', '南京');
INSERT INTO SPJ
VALUES('S1', 'P1', 'J1', 200),
    ('S1', 'P1', 'J3', 100),
    ('S1', 'P1', 'J4', 700),
    ('S1', 'P2', 'J2', 100),
    ('S2', 'P3', 'J1', 400),
    ('S2', 'P3', 'J2', 200),
    ('S2', 'P3', 'J4', 500),
    ('S2', 'P3', 'J5', 400),
    ('S2', 'P5', 'J1', 400),
    ('S2', 'P5', 'J2', 100),
    ('S3', 'P1', 'J1', 200),
    ('S3', 'P3', 'J1', 200),
    ('S4', 'P5', 'J1', 100),
    ('S4', 'P6', 'J3', 300),
    ('S4', 'P6', 'J4', 200),
    ('S5', 'P2', 'J4', 100),
    ('S5', 'P3', 'J1', 200),
    ('S5', 'P6', 'J2', 200),
    ('S5', 'P6', 'J4', 500);
-- (1)
SELECT SNO
FROM SPJ
WHERE JNO = "J1";
-- (2)
SELECT SNO
FROM SPJ
WHERE JNO = "J1"
    AND PNO = "P1";
-- (3)
SELECT SPJ.SNO
FROM P,
    SPJ
WHERE P.PNO = SPJ.PNO
    AND SPJ.JNO = "J1"
    AND P.COLOR = "红";
-- (4)
SELECT JNO
FROM J
WHERE JNO NOT IN (
        SELECT DISTINCT JNO
        FROM S,
            P,
            SPJ
        WHERE S.SNO = SPJ.SNO
            AND P.PNO = SPJ.PNO
            AND S.CITY = "天津"
            AND P.COLOR = "红"
    );
-- (5)
SELECT JNO
FROM SPJ
WHERE SNO = "S1"
GROUP BY JNO
HAVING COUNT(*) = (
        SELECT COUNT(*)
        FROM (
                SELECT PNO
                FROM SPJ
                WHERE SNO = "S1"
                GROUP BY PNO
            ) AS T
    );
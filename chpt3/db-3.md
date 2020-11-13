# 《数据库系统原理》第二章作业

## 4.3

```sql
SELECT * FROM S WHERE A=10;
SELECT A,B FROM S;
SELECT * FROM S,T WHERE S.C=T.C AND S.D=T.D;
SELECT * FROM S,T WHERE S.C=T.C;
SELECT * FROM S,T WHERE A<E;
SELECT S.C,S.D,T.* FROM S,T;
```

## 3.4/2.6

用SQL语句建立第2章习题6中的4个表；针对建立的4个表用SQL语言完成第2章习题6中的查询。

（0）建库建表

```sql
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
```

（1）查询

```sql
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
```

## 3.5

```sql
-- （1）找出所有供应商的姓名和所在城市。
SELECT SNAME,
    CITY
FROM S;
-- （2）找出所有零件的名称、颜色、重量。
SELECT PNAME,
    COLOR,
    WEIGHT
FROM P;
-- （3）找出使用供应商S1所供应零件的工程号码。
SELECT DISTINCT JNO
FROM SPJ
WHERE SNO = "S1";
-- （4）找出工程项目J2使用的各种零件的名称及其数量。
SELECT P.PNAME,
    SPJ.QTY
FROM P,
    SPJ
WHERE P.PNO = SPJ.PNO
    AND SPJ.JNO = "J2";
-- （5）找出上海厂商供应的所有零件号码。
SELECT DISTINCT SPJ.PNO
FROM S,
    SPJ
WHERE S.CITY = "上海"
    AND S.SNO = SPJ.SNO;
-- （6）找出使用上海产的零件的工程名称。
SELECT DISTINCT J.JNAME
FROM S,
    J,
    SPJ
WHERE S.SNO = SPJ.SNO
    AND J.JNO = SPJ.JNO
    AND S.CITY = "上海";
-- （7）找出没有使用天津产的零件的工程号码。
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
    );
-- （8）把全部红色零件的颜色改成蓝色。
UPDATE P
SET COLOR = "蓝"
WHERE COLOR = "红";
-- （9）由S5供给J4的零件P6改为由S3供应，请作必要的修改。
UPDATE SPJ
SET SNO = "S3"
WHERE SNO = S5
    AND JNO = "J4"
    AND PNO = "P6";
-- （10）从供应商关系中删除S2的记录，并从供应情况关系中删除相应的记录。
DELETE FROM SPJ
WHERE SNO = "S2";
DELETE FROM S
WHERE SNO = "S2";
-- （11）请将 (S2, J6, P4, 200) 插入供应情况关系。
INSERT INTO S(SNO, SNAME, STATUS, CITY)
VALUES ('S2', '盛锡', '10', '北京');
INSERT INTO SPJ (SNO, JNO, PNO, QTY)
VALUES ("S2", "J6", "P4", 200);
```


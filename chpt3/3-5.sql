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
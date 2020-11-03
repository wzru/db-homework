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

## 2.6

用SQL语句建立第2章习题6中的4个表；针对建立的4个表用SQL语言完成第2章习题6中的查询。

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
VALUES('S1', '精益', '20', '天津');
INSERT INTO S
VALUES('S2', '盛锡', '10', '北京');
INSERT INTO S
VALUES('S3', '东方红', '30', '北京');
INSERT INTO S
VALUES('S4', '丰泰盛', '20', '天津');
INSERT INTO S
VALUES('S5', '为民', '30', '上海');
INSERT INTO P
VALUES('P1', '螺母', '红', 12);
INSERT INTO P
VALUES('P2', '螺栓', '绿', 17);
INSERT INTO P
VALUES('P3', '螺丝刀', '蓝', 14);
INSERT INTO P
VALUES('P4', '螺丝刀', '红', 14);
INSERT INTO P
VALUES('P5', '凸轮', '蓝', 40);
INSERT INTO P
VALUES('P6', '齿轮', '红', 30);
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
VALUES('S1', 'P1', 'J1', 200);
INSERT INTO SPJ
VALUES('S1', 'P1', 'J3', 100);
INSERT INTO SPJ
VALUES('S1', 'P1', 'J4', 700);
INSERT INTO SPJ
VALUES('S1', 'P2', 'J2', 100);
INSERT INTO SPJ
VALUES('S2', 'P3', 'J1', 400);
INSERT INTO SPJ
VALUES('S2', 'P3', 'J2', 200);
INSERT INTO SPJ
VALUES('S2', 'P3', 'J4', 500);
INSERT INTO SPJ
VALUES('S2', 'P3', 'J5', 400);
INSERT INTO SPJ
VALUES('S2', 'P5', 'J1', 400);
INSERT INTO SPJ
VALUES('S2', 'P5', 'J2', 100);
INSERT INTO SPJ
VALUES('S3', 'P1', 'J1', 200);
INSERT INTO SPJ
VALUES('S3', 'P3', 'J1', 200);
INSERT INTO SPJ
VALUES('S4', 'P5', 'J1', 100);
INSERT INTO SPJ
VALUES('S4', 'P6', 'J3', 300);
INSERT INTO SPJ
VALUES('S4', 'P6', 'J4', 200);
INSERT INTO SPJ
VALUES('S5', 'P2', 'J4', 100);
INSERT INTO SPJ
VALUES('S5', 'P3', 'J1', 200);
INSERT INTO SPJ
VALUES('S5', 'P6', 'J2', 200);
INSERT INTO SPJ
VALUES('S5', 'P6', 'J4', 500);
```

```sql
select distinct sno
from spj
where jno = 'J1';
select distinct sno
from spj
where jno = 'J1'
    and pno = 'P1';
select sno
from spj
where jno = 'j1'
    and pno in (
        select pno
        from p
        where color = '红'
    );
select Jno
from j
where not exists (
        select *
        from spj,
            s,
            p
        where spj.sno = s.sno
            and spj.jno = j.jno
            and spj.pno = p.pno
            and s.city = '天津'
            and p.color = '红'
    );
select *
from spj spjx
where sno = 's1'
    and not exists (
        select *
        from spj spjy
        where spjy.pno = spjx.pno
    );
```


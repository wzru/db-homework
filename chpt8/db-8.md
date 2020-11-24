# 《数据库系统原理》第八章作业

## 8.1

使用嵌入式SQL对学生-课程数据库中的表，完成下面功能：

1.査询某一门课程的信息。要査询的课程由用户在程序运行过程中指定，放在主变 量中。

2.査询选修某一门课程的选课信息，要查询的课程号由用户在程序运行过程中指定，放在主变量中，然后根据用户的要求修改其中某些记录的成绩字段。

```c
EXEC SQL BEGIN DECLARE SECTION;
char cno[4], cname[40], cpno[4];
short ccredit;
EXEC SQL END DECLARE SECTION;
long sqlcode;
EXEC SQL INCLUDE sqlca;
int main()
{
    scanf("%s", cno);
    EXEC SQL CONNECT TO $DSN;
    EXEC SQL DECLARE SX CURSOR FOR
        SELECT Cname,
        Cpno, Ccredit FROM Course WHERE Cno = : cno;
    EXEC SQL OPEN SX;
    EXEC SQL FETCH SX INTO : cname, : cpno, : ccredit;
    if (sqlca.sqlcode == 0)
    {
        printf("%s %s %s %d\n", cno, cname, cpno, ccredit);
    }
}
```

```c
EXEC SQL BEGIN DECLARE SECTION;
char sno[9], cno[4];
short grade, newgrade;
EXEC SQL END DECLARE SECTION;
long sqlcode;
EXEC SQL INCLUDE sqlca;
int main()
{
    scanf("%s", cno);
    EXEC SQL CONNECT TO $DSN;
    EXEC SQL DECLARE SX CURSOR FOR
        SELECT Sno,
        Grade FROM SC WHERE Cno = : cno;
    EXEC SQL OPEN SX;
    for (;;)
        EXEC SQL FETCH SX INTO : sno, : grade;
    if (sqlca.sqlcode == 0)
    {
        printf("%s %d\n", sno, grade);
        printf("update grade?");
        char yn;
        scanf("%c", &yn);
        if (yn == 'y' || yn == 'Y')
        {
            printf("input new grade:");
            scanf("%d", &newgrade);
            EXEC SQL UPDATE SC
                SET Grade = : newgrade
                                  WHERE Cno = : cno AND Sno = : sno;
        }
        EXEC SQL CLOSE SX;
        EXEC SQL COMMIT WORK;
        EXEC SQL DISCONNECT;
    }
    else
        break;
}
```

## 8.2

对学生-课程数据库，编写存储过程，完成下面功能：

1.统计离散数学的成绩分布情况，即按照各分数段统计人数;

2.统计任意一门课的平均成绩；

3.将学生选课成绩从百分制改为等级制(即A、B、C、D、E)

```sql
DELIMITER $$ 
CREATE PROCEDURE stat_dm() BEGIN
SELECT SUM(Grade >= 90) AS A,
    SUM(
        Grade BETWEEN 80 AND 89
    ) AS B,
    SUM(
        Grade BETWEEN 70 AND 79
    ) AS C,
    SUM(
        Grade BETWEEN 60 AND 69
    ) AS D,
    SUM(Grade < 60) AS E
FROM SC
WHERE Cno IN (
        SELECT Cno
        FROM Course
        WHERE Cname = "离散数学"
    );
END $$;
```

```sql
DELIMITER $$ 
CREATE PROCEDURE stat_course_grade(no CHAR(4)) BEGIN
SELECT SUM(Grade >= 90) AS A,
    SUM(
        Grade BETWEEN 80 AND 89
    ) AS B,
    SUM(
        Grade BETWEEN 70 AND 79
    ) AS C,
    SUM(
        Grade BETWEEN 60 AND 69
    ) AS D,
    SUM(Grade < 60) AS E
FROM SC
WHERE Cno = no;
END $$;
```

```sql
CREATE PROCEDURE to_hierarchy() BEGIN
UPDATE SC
SET Grade =(
        CASE
            WHEN Grade >= 90 THEN 'A'
            WHEN Grade >= 80 THEN 'B'
            WHEN Grade >= 70 THEN 'C'
            WHEN Grade >= 60 THEN 'D'
            ELSE 'E'
        END
    );
END $$;
```
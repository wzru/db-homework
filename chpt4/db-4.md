# 《数据库系统原理》第四章作业

1. 对下列两个关系模式：

   学生（学号，姓名，年龄，性别，家庭住址，班级号）

   班级（班级号，班级名，班主任，班长）

   使用GRANT完成下列授权功能：

   ① 授予用户U1拥有对两个表的所有权限，并可给其他用户授权；

   ② 授予用户U2对学生表具有查看权限，对家庭住址具有更新权限；

   ③ 将对班级表查看权限授予所有用户。

   ④ 将对学生表的查询、更新权限授予角色Rio

   ⑤ 将角色R1授予用户U1,并且U1可继续授权给其他角色。

   ```sql
   GRANT ALL PRIVILEGES ON TABLE students,
       classes TO U1 WITH
   GRANT OPTION;
   GRANT SELECT,
       UPDATE(address) ON TABLE students TO U2;
   GRANT SELECT ON TABLE students TO PUBLIC;
   GRANT SELECT,
       UPDATE ON TABLE students TO Rio;
   GRANT R1 TO U1 WITH ADMIN OPTION;
   ```

2. 今有两个关系模式：

   职工（职工号，姓名，年龄，职务，工资，部门号）

   部门（部门号，名称，经理名，地址，电话号）

   请用SQL的GRANT和REVOKE语句（加上视图机制）完成以下授权定义或存取控制 功能：

   1.用户王明对两个表有SELECT权限。

   2.用户李勇对两个表有INSERT和DELETE权限。

   3.每个职工只对自己的记录有SELECT权限；

   4.用户刘星对职工表有SELECT权限，对工资字段具有更新权限。

   5.用户张新具有修改这两个表的结构的权限。

   6.用户周平具有对两个表所有权限（读，插，改，删数据），并具有给其他用户授权的 权限。

   7.用户杨兰具有从每个部门职工中SELECT最高工资、最低工资、平均工资的权限，他不能查看每个人的工资。

```sql
GRANT SELECT ON TABLE staffs,
    departments TO 王明;
GRANT INSERT,
    DELETE ON TABLE staffs,
    departments TO 李勇;
CREATE VIEW 职工视图 AS
SELECT *
FROM staffs
WHERE concat(姓名, '@localhost') = user();
GRANT SELECT,
    UPDATE(工资) ON TABLE staffs TO 刘星;
GRANT UPDATE ON TABLE staffs,
    departments TO 张新;
GRANT ALL PRIVILEGES ON TABLE staffs,
    departments TO 周平 WITH
GRANT OPTION;
CREATE 工资统计 AS
SELECT max(工资),
    min(工资),
    avg(工资)
FROM staffs,
    departments
WHERE staffs.部门号 = dapartments.部门号;
GRANT SELECT ON 工资统计 TO 杨兰;
```


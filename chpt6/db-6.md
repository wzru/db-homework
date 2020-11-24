# 《数据库系统原理》第六章作业

建立一个关于系、学生、班级、学会等诸信息的关系数据库。

　　描述学生的属性有：学号、姓名、出生年月、系名、班号、宿舍区。

　　描述班级的属性有：班号、专业名、系名、人数、入校年份。

　　描述系的属性有：系名、系号、系办公室地点、人数。

　　描述学会的属性有：学会名、成立年份、地点、人数。

　　有关语义如下：一个系有若干专业，每个专业每年只招一个班，每个班有若干学生。一个系的学生住在同一宿舍区。每个学生可参加若干学会，每个学会有若干学生。学生参加某学会有一个入会年份。

　　 请给出关系模式，写出每个关系模式的极小函数依赖集，指出是否存在传递函数依赖，对于函数依赖左部是多属性的情况讨论函数依赖是完全函数依赖，还是部分函数依赖。

　　 指出各关系的候选码、外部码，有没有全码存在



（1）关系模式如下：
学生：$S(Sno,Sname,Sbirth,Dname,Cno,Rno)$
班级：$C(Cno,Mname,Dname,Cnum,Cyear)$
系：$D(Dname,Dno,Daddr,Dnum)$
学会：$A(Aname,Ayear,Aaddr,Anum)$

（2）每个关系模式的最小函数依赖集如下：
学生：$S(Sno,Sname,Sbirth,Dname,Cno,Rno)$的最小函数依赖集如下：
$Sno\rightarrow Sname，Sno\rightarrow Sbirth，Sno\rightarrow Cno，Cno\rightarrow Dname，Dname\rightarrow Rno$
传递依赖：Sno与Rno、Sno与Dname、Sno与Rno之间存在着传递函数依赖。

班级：$C(Cno,Mname,Dname,Cnum,Cyear)$的最小函数依赖集如下：
$Cno\rightarrow Mname，Cno\rightarrow Cnum，Cno\rightarrow Cyear，Mname\rightarrow Dname$
传递依赖：Cno与Dname存在函数传递函数依赖

系：$D(Dname,Dno,Daddr,Dnum)$的最小函数依赖集如下：
$Dname\rightarrow Dno,Dno\rightarrow Dname,Dno\rightarrow Daddr,\\Dno\rightarrow Dnum,Dname\rightarrow Daddr,Dname\rightarrow Dnum$
根据上述函数依赖可知，Dname与Daddr、Dname与Dnum、Dno与Daddr、Dno与Dnum之间存在传递依赖。

学会：$A(Aname,Ayear,Aaddr,Anum)$的最小函数依赖集如下：
$Aname\rightarrow Ayear，Aname\rightarrow Aaddr，Aname\rightarrow Anum$
不存在传递依赖。

（3）
学生S候选码：Sno；外部码：Dname、Cno；无全码
班级C候选码：Cno；外部码：Dname；无全码
系D候选码：Dno；无外部码；无全码
学会A候选码：Aname；无外部码；无全码


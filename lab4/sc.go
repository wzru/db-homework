package main

type SC struct {
	SNO   string `json:"sno" gorm:"column:Sno;primaryKey"`
	CNO   string `json:"cno" gorm:"column:Cno;primaryKey"`
	Grade uint16 `json:"grade" gorm:"column:Grade"`
}

type gradeResult struct {
	Dept      string  `json:"院系"`
	Avg       float64 `json:"平均成绩"`
	Max       int     `json:"最好成绩"`
	Min       int     `json:"最差成绩"`
	Excellent float64 `json:"优秀率"`
	Fail      int     `json:"不及格人数"`
}

type rankResult struct {
	SNO   string `json:"学号"`
	Sname string `json:"姓名"`
	CNO   string `json:"课程号"`
	Cname string `json:"课程名"`
	Grade int    `json:"成绩"`
}

func (*SC) TableName() string {
	return "SC"
}

func listScBySno(sno string) []SC {
	var sc []SC
	db.Where("Sno=?", sno).Find(&sc)
	return sc
}

func getScByNO(sno string, cno string) *SC {
	var sc []SC
	db.Where("Sno=? AND Cno=?", sno, cno).First(&sc)
	if len(sc) > 0 {
		return &sc[0]
	}
	return nil
}

func statGrade() []gradeResult {
	var res []gradeResult
	db.Raw("SELECT Sdept AS dept,AVG(Grade) AS avg,MAX(Grade) AS max,MIN(Grade) AS min,SUM(Grade >= 80) / COUNT(*) AS excellent,SUM(Grade < 60) AS fail FROM Student,SC WHERE SC.Sno = Student.Sno GROUP BY Sdept;").Scan(&res)
	return res
}

func rankGrade(dept string) []rankResult {
	var res []rankResult
	db.Raw("SELECT Student.Sno AS sno,Student.Sname AS sname,SC.Cno AS cno,Course.Cname AS cname,SC.Grade AS grade FROM Student,Course,SC WHERE Student.Sdept = ? AND Student.Sno = SC.Sno AND Course.Cno = SC.Cno ORDER BY SC.Grade DESC;", dept).Scan(&res)
	return res
}

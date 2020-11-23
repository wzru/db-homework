package main

type Student struct {
	NO    string `json:"no" gorm:"column:Sno;primaryKey"`
	Name  string `json:"name" gorm:"column:Sname"`
	Sex   string `json:"sex" gorm:"column:Ssex"`
	Age   int16  `json:"age" gorm:"column:Sage"`
	Dept  string `json:"dept" gorm:"column:Sdept"`
	Schlr string `json:"scholarship" gorm:"column:Scholarship"`
}

func (*Student) TableName() string {
	return "Student"
}

func listStByKeyword(n string) []Student {
	var st []Student
	db.Where("Sno=? OR Sname=?", n, n).Find(&st)
	return st
}

func getStByNO(no string) *Student {
	var st []Student
	db.Where("Sno=?", no).First(&st)
	if len(st) > 0 {
		return &st[0]
	}
	return nil
}

func listDept() []string {
	var depts []string
	var sts []Student
	db.Distinct("Sdept").Find(&sts)
	// fmt.Printf("sts=%+v", sts)
	for _, st := range sts {
		depts = append(depts, st.Dept)
	}
	// fmt.Printf("depts=%+v", depts)
	return depts
}

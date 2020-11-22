package main

type Student struct {
	NO    string `gorm:"column:Sno;primaryKey"`
	Name  string `gorm:"column:Sname"`
	Sex   string `gorm:"column:Ssex"`
	Age   int16  `gorm:"column:Sage"`
	Dept  string `gorm:"column:Sdept"`
	Schlr string `gorm:"column:Scholarship"`
}

func (*Student) TableName() string {
	return "Student"
}

func getStudentByNameNO(n string) []Student {
	var st []Student
	db.Where("Sno=? OR Sname=?", n, n).Find(&st)
	return st
}

func getStudentByNO(no string) *Student {
	var st []Student
	db.Where("Sno=?", no).First(&st)
	if len(st) > 0 {
		return &st[0]
	}
	return nil
}

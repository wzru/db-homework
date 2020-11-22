package main

type Course struct {
	NO     string `gorm:"column:Cno;primaryKey"`
	Name   string `gorm:"column:Cname"`
	PNO    string `gorm:"column:Cpno"`
	Credit int16  `gorm:"column:Ccredit"`
}

func (*Course) TableName() string {
	return "Course"
}

func getCourseByNameNO(n string) []Course {
	var cs []Course
	db.Where("Cno=? OR Cname=?", n, n).Find(&cs)
	return cs
}

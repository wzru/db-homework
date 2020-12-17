package main

type Course struct {
	NO     string `json:"no" gorm:"column:Cno;primaryKey"`
	Name   string `json:"name" gorm:"column:Cname"`
	PNO    string `json:"pno" gorm:"column:Cpno"`
	Credit int16  `json:"credit" gorm:"column:Ccredit"`
}

func (*Course) TableName() string {
	return "Course"
}

func listCsByKeyword(n string) []Course {
	var cs []Course
	db.Where("Cno=? OR Cname=?", n, n).Find(&cs)
	return cs
}

func getCsByNO(no string) *Course {
	var cs []Course
	db.Where("Cno=?", no).First(&cs)
	if len(cs) > 0 {
		return &cs[0]
	}
	return nil
}

func listNoCs() []Course {
	var css []Course
	db.Raw("SELECT * FROM Course WHERE Cno NOT IN(SELECT DISTINCT Cno FROM SC);").Scan(&css)
	return css
}

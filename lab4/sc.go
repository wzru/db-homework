package main

type SC struct {
	SNO   string `gorm:"column:Sno"`
	CNO   string `gorm:"column:Cno"`
	Grade uint16 `gorm:"column:Grade"`
}

func (*SC) TableName() string {
	return "SC"
}

func getSCBySname(sno string) []SC {
	var sc []SC
	db.Where("Sno=?", sno).Find(&sc)
	return sc
}

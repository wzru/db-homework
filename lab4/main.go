package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"

	"github.com/chzyer/readline"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var (
	db  *gorm.DB
	cfg map[string]interface{}
)

func init() {
	bt, err := ioutil.ReadFile("config.json")
	if err != nil {
		panic(err.Error())
	}
	if err = json.Unmarshal(bt, &cfg); err != nil {
		panic(err.Error())
	}
	dsn := cfg["dsn"].(string)
	// fmt.Printf("dsn=%v", dsn)
	db, err = gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		panic(err.Error())
	}
}

func main() {
	for {
		fmt.Printf(`
1  查询学生                4  查询课程                7  查看学生成绩
2  新生入学信息增加        5  修改课程信息            8  录入学生成绩
3  学生信息修改            6  删除没有选课的课程信息  9  修改学生成绩

10 按系对学生成绩进行排名  11 查询学生基本信息和选课信息
请输入您需要的操作(1~11):`)
		var op int
		st := &Student{}
		cs := &Course{}
		sc := &SC{}
		fmt.Scanf("%v", &op)
		// fmt.Printf("op=%v", op)
		if op < 1 || op > 11 {
			fmt.Printf("输入无效，请重新输入！")
		}
		var keyword string
		switch op {
		case 1:
			fmt.Printf("请输入学生学号或姓名:")
			fmt.Scanf("%v", &keyword)
			fmt.Printf("%+v", getStudentByNameNO(keyword))
		case 2:
			fmt.Printf("请依次输入学号，姓名，性别，年龄，院系，是否获奖学金:")
			fmt.Scanf("%v%v%v%v%v%v", &st.NO, &st.Name, &st.Sex, &st.Age, &st.Dept, &st.Schlr)
			if res := db.Create(st); res.Error != nil {
				fmt.Printf("添加新生信息错误:%+v", res.Error.Error())
			} else {
				fmt.Printf("添加新生信息成功!")
			}
		case 3:
			//TODO
			fmt.Printf("请输入学生学号:")
			fmt.Scanf("%v", &keyword)
			st = getStudentByNO(keyword)
			// fmt.Printf("%+v\r", st)
			input, _ := readline.New("")
			input.WriteStdin([]byte(fmt.Sprintf("%+v", st)))
			val, _ := input.Readline()
			fmt.Println(val)
		case 4:
			fmt.Printf("请输入课程号或课程名:")
			fmt.Scanf("%v", &keyword)
			fmt.Printf("%+v", getCourseByNameNO(keyword))
		case 5:
			//TODO
			fmt.Printf("请依次输入课程号，姓名，先修课程号，学分:")
			fmt.Scanf("%v%v%v%v", &cs.NO, &cs.Name, &cs.PNO, &cs.Credit)
		case 6:
			//TODO
		case 7:
			fmt.Printf("请输入学生学号:")
			fmt.Scanf("%v", &keyword)
			fmt.Printf("%+v", getSCBySname(keyword))
		case 8:
			fmt.Printf("请依次输入学生学号，课程号，成绩:")
			fmt.Scanf("%v%v%v", &sc.SNO, &sc.CNO, &sc.Grade)
			if res := db.Create(sc); res.Error != nil {
				fmt.Printf("录入学生成绩错误:%+v", res.Error.Error())
			} else {
				fmt.Printf("录入学生成绩成功!")
			}
		case 9:
			//TODO
		case 10:
		case 11:
		}
	}
}

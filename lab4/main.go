package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"time"

	"github.com/chzyer/readline"
	"github.com/paulrademacher/climenu"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var (
	db   *gorm.DB
	cfg  map[string]interface{}
	st   = &Student{}
	cs   = &Course{}
	sc   = &SC{}
	menu *climenu.ButtonMenu
)

func main() {
	clear()
	fmt.Println("欢迎来到学生管理系统!")
	time.Sleep(time.Duration(300) * time.Millisecond)
	waitEnter()
	for {
		st = &Student{}
		cs = &Course{}
		sc = &SC{}
		opt, esc := menu.Run()
		if esc {
			os.Exit(0)
		}
		// fmt.Println("opt=", opt)
		var kw, sno, cno string
		var depts []string
		switch opt {
		case "SelectStBase":
			kw = climenu.GetText("请输入学生学号或姓名", "")
			// fmt.Printf("kw=%v", kw)
			sts := listStByKeyword(kw)
			b, _ := json.MarshalIndent(sts, "", "\t")
			if len(sts) > 0 {
				fmt.Println(string(b))
				log.Print("查询到学生基本信息")
			} else {
				fmt.Println("未查询到相关学生信息")
			}
			waitEnter()
		case "InsertSt":
			b, _ := json.Marshal(st)
			input, _ := readline.New("")
			input.WriteStdin([]byte(fmt.Sprintf("%v", string(b))))
			line, _ := input.Readline()
			if json.Unmarshal([]byte(line), st) != nil || *st == *new(Student) {
				log.Print("操作取消")
				waitEnter()
				break
			}
			if res := db.Create(st); res.Error != nil {
				log.Printf("增加新生信息错误:%+v", res.Error.Error())
			} else {
				log.Print("增加新生信息成功")
			}
			waitEnter()
		case "UpdateSt":
			kw = climenu.GetText("请输入学生学号", "")
			if st = getStByNO(kw); st == nil {
				log.Print("学生学号不存在!")
				waitEnter()
				break
			}
			b, _ := json.Marshal(st)
			input, _ := readline.New("")
			input.WriteStdin([]byte(fmt.Sprintf("%v", string(b))))
			line, _ := input.Readline()
			newST := &Student{}
			if err := json.Unmarshal([]byte(line), newST); err != nil {
				log.Printf("输入错误:%+v", err.Error())
				waitEnter()
				break
			}
			db = db.Model(st).Updates(*newST)
			if db.Error != nil {
				log.Printf("修改学生信息失败:%+v", db.Error.Error())
			} else {
				log.Printf("修改学生信息成功")
			}
			waitEnter()
		case "SelectCs":
			kw = climenu.GetText("请输入课程号或课程名", "")
			css := listCsByKeyword(kw)
			b, _ := json.MarshalIndent(css, "", "\t")
			fmt.Println(string(b))
			log.Print("查询课程信息")
			waitEnter()
		case "InsertCs":
			b, _ := json.Marshal(cs)
			input, _ := readline.New("")
			input.WriteStdin([]byte(fmt.Sprintf("%v", string(b))))
			line, _ := input.Readline()
			if json.Unmarshal([]byte(line), cs) != nil || *cs == *new(Course) {
				log.Print("操作取消")
				waitEnter()
				break
			}
			if res := db.Create(cs); res.Error != nil {
				log.Printf("增加课程信息错误:%+v", res.Error.Error())
			} else {
				log.Print("增加课程信息成功")
			}
			waitEnter()
		case "UpdateCs":
			kw = climenu.GetText("请输入课程号", "")
			if cs = getCsByNO(kw); st == nil {
				log.Print("课程号不存在!")
				waitEnter()
				break
			}
			b, _ := json.Marshal(cs)
			input, _ := readline.New("")
			input.WriteStdin([]byte(fmt.Sprintf("%v", string(b))))
			line, _ := input.Readline()
			newCS := &Student{}
			if err := json.Unmarshal([]byte(line), newCS); err != nil {
				log.Printf("输入不合法:%+v", err.Error())
				waitEnter()
				break
			}
			db = db.Model(cs).Updates(*newCS)
			if db.Error != nil {
				log.Printf("修改课程信息失败:%+v", db.Error.Error())
			} else {
				log.Printf("修改课程信息成功")
			}
			waitEnter()
		case "DeleteCs":
			css := listNoCs()
			b, _ := json.MarshalIndent(css, "", "\t")
			fmt.Printf("%+v\n", string(b))
			kw = climenu.GetText("确认删除以上课程?(y/n)", "n")
			if kw == "y" || kw == "Y" {
				for _, cs := range css {
					fmt.Printf("delete %v\n", cs)
					db.Exec("DELETE FROM Course WHERE Cno=?", cs.NO)
				}
				log.Print("删除课程成功")
			} else {
				log.Print("已取消操作")
			}
			waitEnter()
		case "SelectSc":
			kw = climenu.GetText("请输入学生学号", "")
			if st = getStByNO(kw); st == nil {
				log.Print("学生学号不存在!")
				waitEnter()
				break
			}
			scs := listScBySno(kw)
			b, _ := json.MarshalIndent(scs, "", "\t")
			fmt.Printf("%v(%v)同学的成绩如下:\n%+v\n", st.Name, st.NO, string(b))
			waitEnter()
		case "InsertSc":
			b, _ := json.Marshal(sc)
			input, _ := readline.New("")
			input.WriteStdin([]byte(fmt.Sprintf("%v", string(b))))
			line, _ := input.Readline()
			if json.Unmarshal([]byte(line), sc) != nil || *sc == *new(SC) {
				log.Print("操作取消")
				waitEnter()
				break
			}
			if res := db.Create(sc); res.Error != nil {
				log.Printf("录入成绩失败:%+v", res.Error.Error())
			} else {
				log.Print("录入成绩成功")
			}
			waitEnter()
		case "UpdateSc":
			sno = climenu.GetText("请输入学生学号", "")
			cno = climenu.GetText("请输入课程号", "")
			if sc = getScByNO(sno, cno); sc == nil {
				log.Print("成绩不存在!")
				waitEnter()
				break
			}
			b, _ := json.Marshal(sc)
			input, _ := readline.New("")
			input.WriteStdin([]byte(fmt.Sprintf("%v", string(b))))
			line, _ := input.Readline()
			newSC := &SC{}
			if err := json.Unmarshal([]byte(line), newSC); err != nil {
				log.Printf("输入错误:%+v", err.Error())
				waitEnter()
				break
			}
			db = db.Model(sc).Updates(*newSC)
			if db.Error != nil {
				log.Printf("修改成绩失败:%+v", db.Error.Error())
			} else {
				log.Printf("修改成绩成功")
			}
			waitEnter()
		case "Stat":
			res := statGrade()
			b, _ := json.MarshalIndent(res, "", "\t")
			fmt.Printf("%+v\n", string(b))
			waitEnter()
		case "Rank":
			depts = listDept()
			for _, dept := range depts {
				res := rankGrade(dept)
				b, _ := json.MarshalIndent(res, "", "\t")
				fmt.Printf("%v系的成绩排名如下:\n%+v\n", dept, string(b))
			}
			waitEnter()
		case "SelectElect":
			sno = climenu.GetText("请输入学生学号", "")
			if st = getStByNO(sno); st == nil {
				log.Print("学生学号不存在!")
				waitEnter()
				break
			}
			b, _ := json.MarshalIndent(st, "", "\t")
			fmt.Printf("学生基本信息如下:\n%v\n", string(b))
			scs := listScBySno(sno)
			var css []Course
			for _, sc := range scs {
				css = append(css, *getCsByNO(sc.CNO))
			}
			b, _ = json.MarshalIndent(css, "", "\t")
			fmt.Printf("学生选课信息如下:\n%v\n", string(b))
			waitEnter()
		case "Exit":
			os.Exit(0)
		}
	}
}

func init() {
	//读取配置文件
	bt, err := ioutil.ReadFile("config.json")
	if err != nil {
		panic(err.Error())
	}
	if err = json.Unmarshal(bt, &cfg); err != nil {
		panic(err.Error())
	}
	dsn := cfg["dsn"].(string)
	// fmt.Printf("dsn=%v", dsn)
	//连接数据库
	db, err = gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		panic(err.Error())
	}
	db.Exec("set foreign_key_checks=0;")
	//初始化菜单
	menu = climenu.NewButtonMenu("", "选择您需要进行的操作")
	menu.AddMenuItem("查询学生基本信息", "SelectStBase")
	menu.AddMenuItem("增加新生入学信息", "InsertSt")
	menu.AddMenuItem("修改学生信息", "UpdateSt")
	menu.AddMenuItem("查询课程信息", "SelectCs")
	menu.AddMenuItem("增加新课程", "InsertCs")
	menu.AddMenuItem("修改课程信息", "UpdateCs")
	menu.AddMenuItem("删除没有选课的课程信息", "DeleteCs")
	menu.AddMenuItem("查询学生成绩", "SelectSc")
	menu.AddMenuItem("录入学生成绩", "InsertSc")
	menu.AddMenuItem("修改学生成绩", "UpdateSc")
	menu.AddMenuItem("按系统计学生的成绩", "Stat")
	menu.AddMenuItem("按系对学生成绩进行排名", "Rank")
	menu.AddMenuItem("查询学生基本信息和选课信息", "SelectElect")
	menu.AddMenuItem("退出", "Exit")
}

func waitEnter() {
	fmt.Print("按Enter键继续...")
	fmt.Scanln() // wait for Enter Key
	clear()
}

func clear() {
	c := exec.Command("clear")
	c.Stdout = os.Stdout
	c.Run()
}

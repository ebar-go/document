# 说明
定时任务是集成的`github.com/robfig/cron`，本文介绍如何优美的使用定时任务。

## 示例
我们将定时任务放在一个单独的`task`模块里

- demo.go
```go
package task
import "fmt"
type DemoJob struct {
}
// 继承cron.Job接口
func (job DemoJob) Run() {
	fmt.Println("task is running..")
}
```

- 加载定时任务
```go
package task
fucn Loader(task *cron.Cron) {
    // 使用cron.Job，推荐
    _ = task.AddJob("*/5 * * * * ?", new(Demo))

    // 使用func
    _ = task.AddFunc("*/5 * * * * ?", func() {
		fmt.Println(123)
	})
}
```

最后在main函数里调用一下Load方法
```go
func main() {
    //...
    app := ego.App()
    app.LoadTask(task.Loader)

    app.StartCron()
    app.Run()
}
```

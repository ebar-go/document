# 说明
在框架里，基于`github.com/uber-go/dig`实现的依赖注入。通过容器方式管理对如mysql、redis等基础服务实例进行管理。

## 方法
- app.Container().Provide: 注入某类实例的初始化方法。
- app.Container().Invoke： 执行函数，参数为依赖的实例变量，从容器内寻找，如果不存在，则调用Provide注入的初始化方法。

## 使用说明
- main.go
```go
package main
import(
    "github.com/ebar-go/ego/component/redis"
)
type SomeObject struct{
    Name string
}
func NewSomeObject() *SomeObject {
    return &SomeObject{}
}
func main() {
    app := ego.App()
    // 注入SomeObject的实例化方法
    app.Container().Provide(NewSomeObject)
    // 获取容器里注入的SomeObject实例，打印name
    app.Container().Invoke(func(someObject *SomeObject) {
        fmt.Println(someObject.Name)
    })
}
```

## 系统组件
```go
// 使用数据库
app.Container().Invoke(func(db mysql.Database) {
    // ...
})
// 使用redis
app.Container().Invoke(func(conn redis.Conn) {
    // ...
})
// 使用日志
app.Container().Invoke(func(logger *log.Logger) {
    // ...
})
// 使用etcd
app.Container().Invoke(func(client *etcd.Client) {
    // ...
})
```
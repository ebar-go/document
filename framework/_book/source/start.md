# 说明
本文将告诉你如果快速的使用`ego`运行起一个web项目。

## 安装
```
go get github.com/ebar-go/ego
```

## 主程序
- main.go
```go
import (
  "github.com/ebar-go/ego"
  "github.com/ebar-go/egu"
)
func main() {
    server := ego.HttpServer()
    // 添加路由
    server.Router.GET("/test", func(context *gin.Context) {
        fmt.Println("hello,world")
    })
    // 默认启动8080
    egu.SecurePanic(server.Start())
}
```

## 运行
```
go run main.go
```
运行后，访问`http://localhost:8080/test`

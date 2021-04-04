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
  "github.com/ebar-go/ego/http/response"
  "github.com/gin-gonic/gin"
)
func main() {
    app := ego.App()
    // 加载路由
    if err := app.LoadRouter(func (router *gin.Engine) {
        router.GET("/", func(ctx *gin.Context) {
          response.WrapContext(ctx).Success(nil)
        })
    }); err != nil {
      log.Fatalf("load router failed: %v\n", err)
    }
    // 启动http服务
	  app.ServeHTTP()
	  // 启动应用
	  app.Run()
}
```

## 运行
```
go run main.go
```
运行后，访问`http://localhost:8080/test`

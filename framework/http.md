# 说明
介绍如何快速搭建一个http服务

## 目录结构
```
demo/
├── cmd
│   ├── handler
│   │   └── user.go
│   └── main.go
└── conf
    └── app.yaml
```

## 配置
- conf/app.yaml
```yaml
http:
    port: 8085
```

## Demo
- cmd/handler/user.go
```go
package handler
type UserHandler interface{
    Register(ctx *gin.Context)
}
// userHandlerImpl UserHandler的实现
type userHandlerImpl struct{}
// Register 注册
func (impl userHandlerImpl) Register(ctx *gin.Context) {
    // .. 注册用户的逻辑
    response.WrapContext.Success(nil)
}
// NewUserHandler
func NewUserHandler() UserHandler{
    return &userHandlerImpl{}
}
// Inject 注入容器
func Inject(container *dig.Container) {
    _ = container.Provide(NewUserHandler)
}
```

- cmd/main.go
```go
package main
import (
  "github.com/ebar-go/ego"
  "github.com/ebar-go/ego/http/response"
  "github.com/gin-gonic/gin"
  "demo/handler"
)
func main() {
    app := ego.App()
    // 注入handler
    handler.Inject(app.Container())
    // 加载路由
    if err := app.LoadRouter(func (router *gin.Engine, userHandler handler.UserHandler) {
        router.GET("/", func(ctx *gin.Context) {
          response.WrapContext(ctx).Success(nil)
        })
        router.POST("/user/register", userHandler.Register)
    }); err != nil {
      log.Fatalf("load router failed: %v\n", err)
    }
    // 启动http服务
	  app.ServeHTTP()
	  // 启动应用
	  app.Run()
}
```

## 启动
```
cd demo
go run cmd/main.go
```

启动后访问:`http://localhost:8085/`,输出结果如下：
```
{
    "code": 0,
    "message": "success",
    "data": null,
    "meta": {
        "trace": {
            "trace_id": "trace:eea596a4-ef3c-46ea-90db-2c20e56fc725",
            "request_id": "request:2d892e13-1ab1-4b16-8d55-4284cf38ff4f"
        },
        "pagination": null
    }
}
```
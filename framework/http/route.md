# 说明
框架的web服务是基于`https://github.com/gin-gonic/gin`实现的。

## 示例
一般我们会在项目里单独用一个如`route`模块来管理路由
- route.go
```go
package route
import (
    "github.com/gin-gonic/gin"
)
func LoadRoute(router *gin.Engine) {
    // any 表示注册所有请求方式的路由
    router.ANY("/", handler.IndexHandler)
    
    // GET请求，列表查询用户信息
    router.GET("/user", handler.ListUserHandler)
    // POST请求，创建用户信息
    router.POST("/user", handler.CreateUserHandler)
    // PUT请求，更新用户信息
    router.PUT("/user/:id", handler.UpdateUserHandler)
    // GET请求，获取用户信息
    router.GET("/user/:id", handler.GetUserHandler)
    // DELETE请求，删除用户信息
    router.DELETE("/user/:id", handler.DeleteUserHandler)
}
```

- handler模块   
一般handler的职责是：接收参数，调用service,输出相应内容。   
```go
package handler
import (
	"github.com/ebar-go/ego/http/response"
	"github.com/gin-gonic/gin"
)
func Indexhandler(ctx *gin.Context) {
    // 自定义的response模块，更多使用方法见[1.1.3.响应]
    response.WrapContext(ctx).Success(nil)
}
// .. 其他handler
```
- main.go
```go
import (
    "github.com/ebar-go/ego"
    "github.com/ebar-go/egu"
    "demo/route"
)
func main() {
    server := ego.HttpServer()

	// 加载路由
	route.LoadRoute(server.Router)

	// 启动
	egu.SecurePanic(server.Start())
}
```

启动后访问:`http://localhost:8080/`,输出结果如下：
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
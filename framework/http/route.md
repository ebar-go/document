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
// 路由加载器，依赖UserHandler
func RouterLoader(router *gin.Engine, userHandler handler.UserHandler) {
    // GET请求，列表查询用户信息
    router.GET("/user", userHandler.List)
    // POST请求，创建用户信息
    router.POST("/user", userHandler.Create)
    // PUT请求，更新用户信息
    router.PUT("/user/:id", userHandler.Update)
    // GET请求，获取用户信息
    router.GET("/user/:id", userHandler.Info)
    // DELETE请求，删除用户信息
    router.DELETE("/user/:id", userHandler.Delete)
}
```
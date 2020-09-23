# 说明
介绍框架自带的`error`模块使用方法。

## 函数
```go
package service 
import "github.com/ebar-go/ego/errors"

func ExecuteSomeLogic() error{
    return errors.New(1001, "参数错误")
}
```

## 组合拳
当组合使用`middleware.Recover`中间件与`errors`时，可以有效减少你的`if err` 判断:   
```go
func main() {
    server := ego.HttpServer()
    server.Router.Use(middleware.Recover)
    // 添加路由
    server.Router.GET("/test", func(context *gin.Context) {
        fmt.Println("hello,world")
    })
    server.Router.Get("error", func(context *gin.Context) {
        err := service.ExecuteSomeLogic()
        egu.SecurePanic(err) // 这句panic会触发recover,New函数的code参数将作为response的code..
        response.WrapContext(context).Success(nil)
    })
    // 默认启动8080
    egu.SecurePanic(server.Start())
}
```
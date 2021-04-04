# 说明
Swagger 是一个规范和完整的框架，用于生成、描述、调用和可视化 RESTful 风格的 Web 服务。

## Swag
在开始使用swagger之前，需要安装`swag`
```
// 下载地址
https://github.com/swaggo/swag
```

## 示例
- 项目说明`
首先通过注解，表明接口的基础请求地址为： `localhost:8080/`
```go
// @title Swagger Example API
// @version 1.0
// @description This is a sample server Petstore server.
// @termsOfService http://swagger.io/terms/
// @contact.name hongker
// @contact.url http://hongker.github.io
// @contact.email xiaok2013@live.com
// @license.name Apache 2.0
// @license.url http://www.apache.org/licenses/LICENSE-2.0.html
// @host localhost:8080
// @BasePath /
func main()  {
	// ...
}
```

- 接口说明
声明接口的相关信息，访问路由为: /user/auth
```go
// UserAuthHandler 用户登录
// @Summary 用户登录
// @Description 通过邮箱和密码登录，换取token
// @Accept  json
// @Produce json
// @Param email body string true "邮箱"
// @Param pass body string true "密码"
// @Success 0 "success"
// @Failure 500 "error"
// @Router /user/auth [post]
func UserAuthHandler(ctx *gin.Context) {
    // demo
}
```
各项注解说明：
```
Summary : 副标题
Description : 接口描述
Accept : 接收类型
Produce: 响应类型
Param: 参数
Success: 成功的响应
Failure: 失败的响应
Router : 路由(包括uri, method)
```


- 使用swag生成文档
```
swag init
```
通过以上命令即可在项目目录下生成一个`docs`目录

## 开启swagger
- 配置
```
http:
    swagger: on
```

- 路由
```go
import (
    _ "demo/docs" // 这行不能少
)
// 通过 {host}/swagger/index.html访问swagger web
```
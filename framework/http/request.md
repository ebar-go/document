# 说明
介绍如何在handler里获取到参数。以及如何使用参数校验器

## 解析参数
因为是集成的`https://github.com/gin-gonic/gin`,所以想要更知道更详细的请参考官方文档。以下为简单介绍   
- GET请求
```go
// /index?id=1
func IndexHandler(ctx *gin.Context) {
    id := ctx.Query("id")
}
```
- POST请求(表单)   
```go
func IndexHandler(ctx *gin.Context) {
    id := ctx.PostForm("id")
}
```

- POST请求(Json)
```go
var req Request{
    Id int `json:"id"`
}
func IndexHandler(ctx *gin.Context) {
    var req Request
    if err := ctx.ShouldBindJson(&req); err != nil {
        response.WrapContext(ctx).Error(1001, "参数错误:" + err.Error())
        return
    }
}
```

- Restful   
```go
// /index/1
func route(router *gin.Engine) {
    router.Get("/index/:id", IndexHandler)
}
func IndexHandler(ctx *gin.Context) {
    id := ctx.Param("id")
}
```

以上是gin官方支持的常规获取参数的方法。对于一般的少数参数来说，上面的方法已足够。但对于参数超过三个的接口，推荐使用`ShouldBind()`来解析成一个结构体，代码简洁且易于扩展

- ShouldBind
```go
var req Request{
    Id int `json:"id"` // 如果是get请求，使用query替换json,如果是post表单的请求，使用form替换json
    Name string `json:"name"`
    Age int `json:"age"`
}
func IndexHandler(ctx *gin.Context) {
    var req Request
    if err := ctx.ShouldBind(&req); err != nil {
        response.WrapContext(ctx).Error(1001, "参数错误:" + err.Error())
        return
    }
}
```

## 参数校验器
该参数校验器是基于`https://github.com/go-playground/validator`实现,支持该包的所有规则。同时自定义的`comment`字段，以及错误提示转换为中文。
```go
type AuthRequest struct {
    // 如果是表单提交，使用form,否则获取不到数据
    Email string `json:"email" binding:"required,email" comment:"邮箱"` // 参数必填，同时验证邮箱格式
    Pass string `json:"pass" binding:"required,min=6,max=10" comment:"密码"` // 参数必填，同时要求密码长度为6~10位
}
var request AuthRequest
if err := ctx.ShouldBind(&request); err != nil { 
    response.WrapContext(ctx).Error(1001, "参数错误:" + err.Error())
    return
}
```
如果请求参数里的pass为空，则响应内容为: 
```
{
    "code": 1001,
    "message": "参数错误：密码为必填字段",
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
建议大家在struct里定义校验规则，这样可以在主业务里避免繁杂的参数判断，提高代码的整洁度，也更容易扩展。
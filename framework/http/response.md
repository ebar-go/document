# 说明
介绍与响应内容相关的使用方式。

## 响应内容
- 示例
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

## 参数
- code：业务状态码
- message: 提示信息
- data: 数据项(可以是任何数据结构)
- meta: 元数据
    - trace: 全局链路信息
        - trace_id: 全局链路唯一ID,一个独立单元的业务操作通用的ID（包含业务逻辑里的日志记录，curl请求等都会携带该ID，用于串联前前后后）
        - request_id: 请求ID,一次http请求对应一个请求ID
    - pagination: 分页数据
        - current_page: 当前页数
        - per_page: 每页行数
        - total: 总行数

## 方法
- Success   
调用`Success(data interface{})`,参数为数据项data，支持任何类型的变量。输出义务正常的响应内容：code为0,message为success   
```go
response.WrapContext(ctx).Success(nil) // {"code":0,"message":"success","data":null,...}
response.WrapContext(ctx).Success("hello,world") // {"code":0,"message":"success","data":"hello,world",...}
response.WrapContext(ctx).Success([]int{1,2,3}) // {"code":0,"message":"success","data":[1,2,3],...} 
response.WrapContext(ctx).Success(response.Data{"hello":"world"}) // {"code":0,"message":"success","data":{"hello":"world"},...} 
```

- Error
调用`Error(code int, message string)`,参数为状态码和提示信息。输出业务异常的响应内容： data为null
```go
response.WrapContext(ctx).Error(1001, "参数错误") // {"code":1001,"message":"参数错误","data":null,...}
```

- Paginate
调用`Paginate(data interface{}, pagination *pagination.Paginator)`,输出的是业务正常的分页数据：
```go
paginate := pagination.Paginate(100, 1, 5) // 三个参数分别是：总条数，当前页数，每页行数
response.WrapContext(ctx).Paginate([]int{1,2,3,4,5}, &paginate) // {"code":0,"message":"success","data":[1,2,3],"meta":{"pagination":{"total":100,"current_paeg":1,"per_page":5}}} 
```
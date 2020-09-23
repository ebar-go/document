# 说明
介绍http请求组件的使用方式。

## GET请求
```go
package main
func main() {
    var address = "http://localhost:8080/api"

    response, err := curl.Get(address)
    if err != nil {
        panic(err)
    }
    fmt.Println(response.String()) // 可以通过response获取string类型的响应
    fmt.Println(response.Byte()) // 也可以是byte
    var obj struct{}
    err = response.BindJson(&obj) // 也可以解析到一个结构体
}
```

## POST请求
```go
params := make(url.Values)
params.Set("id", "1")
response, err := curl.Post(address, strings.NewReader(params.Encode()))
```

## PUT请求
```go
response, err := curl.Put(address, nil)
```

## PUT请求
```go
response, err := curl.Put(address, nil)
```


## Patch请求
```go
response, err := curl.Patch(address, nil)
```

## Delete请求
```go
response, err := curl.Delete(address, nil)
```

## 自定义请求
```go
request := curl.NewRequest(http.MethodPost, url, body)
response, err := request.Send()
if err != nil {
    return err
}
fmt.Println(response.String())
```

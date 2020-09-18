# 说明
redis组件是基于`https://github.com/go-redis/redis`实现的。

## 初始化
一般加载数据库是在main.go里的init函数，连接redis放在加载配置项成功后。
```go

func init()  {
	// 加载配置
	secure.Panic(app.Config().LoadFile("app.yaml"))

	// 连接redis
    secure.Panic(app.Redis().Connect()) // 如果是集群模式，使用ConnectCluster(),二选一
}
```

## 操作
```go
//　写入一个key为hello,值为world
if err := app.Redis().Set("hello", "world", time.Second); err != nil {
    return err
}
// 获取redis的数据
fmt.Println(app.Redis().Get("hello").Result())
```

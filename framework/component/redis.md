# 说明
redis组件是基于`https://github.com/go-redis/redis`实现的。



## 配置
- 示例
```yaml
redis:
  host: 127.0.0.1 # 地址
  pass: xx  # 密码
  port: 6379 # 端口
  poolSize: 100 # 连接池数量
  maxRetries: 3 # 最大尝试次数
  idleTimeout: 3 # 超时时间
  cluster:   # 集群配置
	  - 127.0.0.2:6379
	  - 127.0.0.3:6379
```
- 说明
    - poolSize: 连接池数量
    - cluster: redis集群地址，用逗号隔开。


## 初始化
一般加载数据库是在main.go里的init函数，连接redis放在加载配置项成功后。
```go

func init()  {
	// 加载配置
	egu.SecurePanic(app.Config().LoadFile("app.yaml"))

	// 连接redis
    egu.SecurePanic(app.Redis().Connect()) // 如果是集群模式，使用ConnectCluster(),二选一
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

# 说明
配置组件是基于`github.com/spf13/viper`实现的。

## 加载配置文件
配置文件加载的优先级一般都比较高，所以建议`main.go`里的`init`方法。
```
import (
	"github.com/ebar-go/ego"
	"github.com/ebar-go/ego/app"
	"github.com/ebar-go/egu"
)
func init() {
	// 加载名为app.yaml的配置文件，如果失败直接panic
	egu.SecurePanic(app.Config().LoadFile("app.yaml"))
}

func main () {
    fmt.Println(app.Config().Server()) // 打印系统配置
    fmt.Println(app.Config().Mysql()) // 打印mysql配置
    fmt.Println(app.Config().Redis()) // 打印redis配置
}
```

## 系统配置
- 示例   
```yaml
server: # 服务器配置
  httpPort: 8080  # 端口号
  systemName: ego-demo # 系统名称
  maxResponseLogSize: 2000 # 响应内容截取长度
  logPath: /tmp/app.log # 日志文件
  traceHeader: gateway-trace # trace头
  httpRequestTimeout: 3 # http请求超时时间，单位：秒
  jwtSign: ego-demo-sign  # jwt的签名
  debug: on # 日志debug
  pprof: on 
  task: on
  swagger: off
```

- 说明
    - httpPort: http服务的运行端口，默认为8080
    - systemName: 系统名称,默认为app
    - maxResponseLogSize: 请求日志里，记录响应内容的截取长度，默认为2000
    - logPath: 日志文件路径，默认为/tmp/app.log
    - traceHeader: 发起http请求时，携带全局traceId的header字段名称，默认为：gateway-trace
    - httpRequestTimeout: http请求的超时时间，单位：秒。默认为3秒
    - jwtSign: jsonWebToken的签名
    - debug：是否开启debug日志，如果不开启，Debug级别的日志不会就到日志文件里，建议测试环境开启，正常运行的生产环境关闭。
    - pprof: 是否开启pprof监控，建议在压力测试时开启。
    - task: 是否开启定时任务
    - swagger: 是否开启swagger接口文档。


## 数据库配置
- 示例
```yaml
mysql:    # mysql配置。支持多数据库，读写分离
  default:  # 默认连接，如果还有其他数据库要连接，换个名字即可
    maxIdleConnections: 10  # 最大空闲连接数
    maxOpenConnections: 40  # 最大打开连接数
    maxLifeTime: 8          # 超时时间
    debug: on # 是否开启debug模式，会打印出相关的sql
    strict: off # 是否开启严格模式，如果开启，当数据库初始化连接时，直接panic
    dsn:    # 连接配置，默认第一个为写库，也可以只配置一个，即读写使用一个连接
      - host: 127.0.0.1
        port: 32768
        user: root
        password: mysql
        name: blog
        charset: utf8mb4 # 默认为utf8mb4
  other:    # 另一个数据库连接
    maxIdleConnections: 10  # 最大空闲连接数
    maxOpenConnections: 40  # 最大打开连接数
    maxLifeTime: 8          # 超时时间
    dsn:    # 连接配置，默认第一个为写库，也可以只配置一个，即读写使用一个连接
      - host: 127.0.0.2
        port: 3306
        user: root
        password: mysql
        name: otherDB
        charset: utf8mb4 # 默认为utf8mb4
```

- 说明
    - maxIdleConnections: 连接池的最大空闲数
    - maxOpenConnections: 连接池的最大打开连接数
    - maxLifeTime: 超时时间
    - dsn: 数据库相关配置
    - debug: 是否开启debug模式，会打印出相关的sql。默认不开启
    - strict: 是否开启严格模式，如果开启，当数据库初始化连接时，直接panic。默认为不开启。

## Redis配置
- 示例
```yaml
redis:
  host: 127.0.0.1 # 地址
  pass: xx  # 密码
  port: 6379 # 端口
  poolSize: 100 # 连接池数量
  maxRetries: 3 # 最大尝试次数
  idleTimeout: 3 # 超时时间
  cluster:  127.0.0.2:6379,127.0.0.3:6379 # 集群配置
```
- 说明
    - poolSize: 连接池数量
    - cluster: redis集群地址，用逗号隔开。

## Etcd配置

## 自定义配置
也可以自定义项目的相关配置。   
- 示例
```yaml
app:
    someString: egoCool
    someInt: 100
    someBool: true
```

- 读取配置:
```go
app.Config().GetString("app.someString")
app.Config().GetInt("app.someInt")
app.Config().GetBool("app.someBool")
```
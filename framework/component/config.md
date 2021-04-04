# 说明
配置组件是基于`github.com/spf13/viper`实现的。

## 加载配置文件
配置文件加载的优先级一般都比较高，所以建议`main`函数里加载。
```
import (
	"github.com/ebar-go/ego"
    "log"
)
func main() {
    app := ego.App()
	// 加载配置文件
	if err := app.LoadConfig("conf/app.yaml"); err != nil {
		log.Fatalf("load config failed: %v\n", err)
	}
}
```

## 配置文件
- 示例   
```yaml
server: # 服务器配置
    name: someApp
    environment: product # 运行环境
app: # 自定义配置
    someString: a
    someInt: 1
    SomeBool: true
```

- 读取配置:
```go
import(
    "github.com/ebar-go/ego/component/config"
)
func main() {
    app := ego.App()
	// 加载配置文件
	if err := app.LoadConfig("conf/app.yaml"); err != nil {
		log.Fatalf("load config failed: %v\n", err)
    }
    app.Container.Invoke(ReadConfig)
}
// ReadConfig 读取配置，依赖于Config
func ReadConfig(conf *config.Config) {
    conf.GetString("app.someString")
    conf.GetInt("app.someInt")
    conf.GetBool("app.someBool")
}
```
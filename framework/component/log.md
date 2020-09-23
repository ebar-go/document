# 说明
基于`https://github.com/uber-go/zap`实现的日志管理器。支持按日期切割。

## 使用
```go
func main() {
    app.Logger().Info("Info", log.Context{
		"hello": "world",
	})
	app.Logger().Debug("Debug", log.Context{
		"hello": "world",
	})
	app.Logger().Error("Error", log.Context{
		"hello": "world",
	})
}
```
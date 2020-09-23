# 说明
介绍事件模块的使用

## 接口
- event.Register(eventName string, listener Listener)   
注册监听器。
- event.Listen(eventName string, handler Handler)   
快速注册同步的监听器。
- event.Trigger(eventName string, params interface{})   
触发事件。
- event.Has(eventName string) bool   
检查是否包含事件。

## 系统事件
```
event.BeforeHttpStart： http服务启动前
event.AfterHttpStart: http服务启动后
event.BeforeHttpShutdown: http服务关闭前
event.AfterDatabaseConnect: 数据库连接成功后
event.BeforeRoute: 路由执行前
event.AfterRoute: 路由执行后
```
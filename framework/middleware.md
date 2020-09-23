# 说明
介绍中间件的使用。

## 全局链路ID
框架默认引入全局链路ID，该ID能串联的内容包括：
- 响应内容的`meta.trace`
- 日志的trace_id
- http请求的traceHeader参数

## JWT
```go
router.Use(middleware.JWT(&jwt.StandardClaims{}))
```

## Recover
```go
router.Use(middleware.Recover)
```

## 请求日志
```go
router.Use(middleware.RequestLog)
```

## 跨域
```go
router.Use(middleware.Cors)
```
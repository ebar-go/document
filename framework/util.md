# 说明
介绍集成的常用函数。

- 数组
- 时间
- 加密/解密
- json
- 字符串
- 数字

## 安装
ego框架默认引入了egu工具包，如果要单独使用：
```
go get github.com/ebar-go/egu
```

## 字符串
```
egu.UUID() // 唯一ID
egu.DefaultString(v, defaultV string) string // 填充默认值
```

## 数字
```
egu.DefaultInt(v, dv int) int // 填充默认值
egu.RandInt(min, max int) int // 取随机数
egu.Round(f float64) int // 四舍五入
```

## 数组
介绍数组的相关函数。

```
egu.InArray(needle interface{}, haystack interface{}) bool  // 判断数组是否包含某元素
egu.Implode( items interface{}, separator string) string  // 连接数组
egu.Explode(str, separator string) StringSlice // 分割字符串为数组
egu.StringArray(items []string).ToInt() // 字符串数组转int
egu.StringArray(items []string).Unique() // 去重
```

## Json
使用`github.com/pquerna/ffjson/ffjson`代替官方json库。

```
egu.JsonEncode(v interface{}) (string, error) // json序列化
egu.JsonDecode(buf []byte, obj interface{}) error // json反序列化
egu.MustJsonEncode(v interface{}) string  // 只返回json
```

# 日期/时间
```
egu.GetTime() time.Time // 获取时间
egu.GetDateStr() string // 获取日期字符串
egu.GetTimeStr() string // 获取时间字符串
egu.GetTimeStamp() int64 // 获取时间戳
```

## 加密/解密
介绍常用的加密函数。

```
egu.Md5(s string) string // md5加密
egu.Sha1(s string) string // hash加密

egu.Base64Encode(source []byte) string // base64加密
egu.Base64Decode(encoded string) []byte // base64解密

egu.Aes([]byte("someKey")).Encrypt(src []byte) ([]byte, error) // aes加密
egu.Aes([]byte("someKey")).Decrypt(src []byte) ([]byte, error) // aes解密

egu.Rsa(public, private []byte).Encrypt(src []byte) ([]byte, error) // rsa加密
egu.Rsa(public, private []byte).Decrypt(src []byte) ([]byte, error) // rsa解密
```
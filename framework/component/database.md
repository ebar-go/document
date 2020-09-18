# 说明
数据库组件是基于`https://github.com/go-gorm/gorm`实现的，同时实现了多数据库链接、读写分离等功能。稍后升级为gorm2.0

## 初始化
一般加载数据库是在main.go里的init函数，连接数据库放在加载配置项成功后。
```go
func init()  {
	// 加载配置
	secure.Panic(app.Config().LoadFile("app.yaml"))

	// 初始化数据库
    secure.Panic(app.InitDB())
}
```
## 表结构
```sql
drop table if exists users;
create table users (
    id int unsigned not null primary key auto_increment comment '主键',
    email varchar(255) not null default '' comment '邮箱',
    password varchar(32) not null default '' comment '密码',
    is_del tinyint unsigned not null default 0 comment '是否删除',
    created_at int unsigned not null default 0 comment '创建时间',
    updated_at int unsigned not null default 0 comment '更新时间',
    key `idx_is_del`(`is_del`),
    key `idx_updated_at`(`updated_at`)
)charset=utf8mb4 comment='用户信息';
```
## 定义实体
```go
package entity


const (
    TableUser = "users" // 表名
）
// 用户实体
type UserEntity struct {
	mysql.BaseEntity
	Email string `json:"email" gorm:"column:email"`
	Password string `json:"-" gorm:"column:password"`
}

// TableName 指定模型的表名称
func (UserEntity) TableName() string {
	return TableUser
}
```

## 定义Dao
- BaseDao.go
```go
package dao
import(...)
const SoftDeleteCondition = "is_del = 0" // 软删除条件
// 基础dao
type BaseDao struct {
	db *gorm.DB
}
// Unscoped 软删除
func (dao *BaseDao) Unscoped() *gorm.DB {
	return dao.db.Where("is_del", 1)
}
// Create 创建
func (dao *BaseDao) Create(entity interface{}) error {
	return dao.db.Create(entity).Error
}
// Update 更新
func (dao *BaseDao) Update(entity interface{}) error {
	return dao.db.Save(entity).Error
}
// Delete 删除
func (dao *BaseDao) Delete(entity interface{}) error {
	return dao.db.Model(entity).UpdateColumns(mysql.Columns{
		"is_del": 1,
	}).Error
}
```

- UserDao.go
```go
package dao
import(...)
type userDao struct {
	BaseDao
}
func User(db *gorm.DB) *userDao {
	return &userDao{BaseDao{
		db: db,
	}}
}
// GetByUsername 根据用户名获取记录
func (dao *userDao) GetByEmail(email string) (*entity.UserEntity, error) {
	query := dao.Unscoped().Table(entity.TableUser).
		Where("email = ?", email)
	user := new(entity.UserEntity)
	if err := query.First(user).Error; err != nil {
		return nil, err
	}
	return user, nil
}
// 分页查询
func (dao *userDao) PaginateQuery(request request.UserQueryRequest) ([]entity.UserEntity, *paginate.Pagination, error) {
	query := dao.db.Table(entity.TableUser).Where(SoftDeleteCondition).Order("id desc")
	var totalCount int
	if err := query.Count(&totalCount).Error; err != nil {
		return nil, nil, err
	}
	pagination := paginate.Paginate(totalCount, request.CurrentPage, request.PageSize)
	items := make([]entity.UserEntity, 0)
	if err := query.Offset(pagination.GetOffset()).Limit(pagination.Limit).
		Scan(&items).Error; err != nil {
		return nil, nil, err
	}
	return items, &pagination, nil
}
```

## 使用事务
```go
package service
import(...)

type userService struct {}

// User 用户服务
func User()*userService  {
	return &userService{}
}
// Register 注册
func (service *userService) Register(req request.UserRegisterRequest) error {
    // 将数据库操作包裹在Transaction内部，保证事务执行完整
	err := app.DB().Transaction(func(tx *gorm.DB) error {
		userDao := dao.User(tx)
		// 根据邮箱获取用户信息
		user, err := userDao.GetByEmail(req.Email)
		if err != nil && err != gorm.ErrRecordNotFound {
			return fmt.Errorf("获取用户信息失败:%v", err)
		}

		// 用户已存在
		if user != nil {
			return fmt.Errorf("该邮箱已被注册")
		}

		now := int(date.GetLocalTime().Unix())

		user = new(entity.UserEntity)
		user.Email = req.Email
		user.Password = strings.Md5(req.Pass)
		user.CreatedAt = now
		user.UpdatedAt = now

		return userDao.Create(user)
	})

	if err != nil {
		return errors.New(enum.DatabaseSaveFailed, fmt.Sprintf("保存数据失败:%v", err))
	}


	return nil
}
```

## 使用其他数据库
```go
app.GetDB("otherDB").Table("xxx")...
```

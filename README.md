# 公租房管理系统

一个功能完善的公租房管理系统，采用前后端分离架构。

## 技术栈

- **后端**: FastAPI + SQLAlchemy + MySQL
- **前端**: Vue 3 + Element Plus + Vite
- **认证**: JWT Token
- **数据库**: MySQL 8.0+

## 项目结构

```
public_housing_management/
├── backend/               # 后端项目
│   ├── app/
│   │   ├── routers/      # API路由
│   │   ├── models.py     # 数据库模型
│   │   ├── schemas.py    # Pydantic模型
│   │   ├── auth.py       # 认证相关
│   │   ├── database.py   # 数据库配置
│   │   ├── config.py     # 应用配置
│   │   └── main.py       # 应用入口
│   ├── requirements.txt  # Python依赖
│   ├── .env              # 环境变量
│   ├── run.py            # 启动脚本
│   └── init_db.py        # 数据库初始化
├── frontend/             # 前端项目
│   ├── src/
│   │   ├── views/        # 页面组件
│   │   ├── layouts/      # 布局组件
│   │   ├── router/       # 路由配置
│   │   ├── stores/       # Pinia状态管理
│   │   ├── api/          # API接口
│   │   ├── main.js       # 入口文件
│   │   ├── App.vue       # 根组件
│   │   └── style.css     # 全局样式
│   ├── package.json      # 依赖配置
│   ├── vite.config.js    # Vite配置
│   └── index.html        # HTML模板
└── README.md             # 说明文档
```

## 功能模块

1. **用户管理**: 管理员、员工、租户三类角色
2. **小区管理**: 小区信息的增删改查
3. **楼栋管理**: 楼栋信息的增删改查
4. **房源管理**: 房源信息的增删改查，包括状态管理（空闲、已租、维修中）
5. **租户管理**: 租户信息的增删改查，支持审核功能
6. **合同管理**: 租赁合同的增删改查，支持终止合同
7. **缴费管理**: 租金、押金等费用的管理，支持收款记录
8. **仪表盘**: 数据统计和可视化展示

## 系统要求

- Python 3.13+
- MySQL 8.0+
- Node.js 18+

## 配置和运行

### 一、MySQL数据库配置

1. **启动MySQL服务**

2. **创建数据库**

```sql
CREATE DATABASE public_housing_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

3. **创建数据库用户**（可选，也可以使用root用户）

```sql
CREATE USER 'housing_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON public_housing_db.* TO 'housing_user'@'localhost';
FLUSH PRIVILEGES;
```

### 二、后端配置和运行

1. **进入后端目录**

```bash
cd backend
```

2. **创建Python虚拟环境**（推荐）

在PyCharm中打开项目，配置Python 3.13解释器。

或者使用命令行：
```bash
python -m venv venv
# Windows
venv\Scripts\activate
# Linux/Mac
source venv/bin/activate
```

3. **安装依赖**

```bash
pip install -r requirements.txt
```

4. **配置数据库连接**

编辑 `backend/.env` 文件：

```env
# 数据库配置
DB_HOST=localhost
DB_PORT=3306
DB_USER=root                    # 你的MySQL用户名
DB_PASSWORD=your_password       # 你的MySQL密码
DB_NAME=public_housing_db

# JWT配置
SECRET_KEY=your-secret-key-here-change-this-in-production
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# 服务器配置
HOST=0.0.0.0
PORT=8000
```

5. **初始化数据库**

```bash
python init_db.py
```

这会创建所有数据表，并添加默认管理员账号：**admin / admin123**

6. **运行后端服务**

```bash
python run.py
```

或者：

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

后端服务将在 http://localhost:8000 运行

7. **访问API文档**

打开浏览器访问：http://localhost:8000/docs

这是FastAPI自动生成的Swagger UI文档，可以查看和测试所有API接口。

### 三、前端配置和运行

1. **进入前端目录**

```bash
cd frontend
```

2. **安装Node.js依赖**

```bash
npm install
```

或者使用yarn：
```bash
yarn
```

3. **配置代理（已配置好）**

vite.config.js 中已配置代理到后端服务：

```javascript
server: {
  port: 3000,
  proxy: {
    '/api': {
      target: 'http://localhost:8000',
      changeOrigin: true,
    },
  },
}
```

4. **运行前端开发服务器**

```bash
npm run dev
```

或者：
```bash
yarn dev
```

前端服务将在 http://localhost:3000 运行

5. **打包（生产环境）**

```bash
npm run build
```

打包后的文件在 `dist` 目录中。

### 四、访问系统

1. 打开浏览器访问 http://localhost:3000
2. 使用默认管理员账号登录：
   - 用户名: **admin**
   - 密码: **admin123**

## 生产环境部署

### 后端部署

1. **使用Gunicorn/Uvicorn部署**

```bash
pip install gunicorn

gunicorn app.main:app -w 4 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000
```

2. **使用Nginx反向代理**

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### 前端部署

1. **打包**

```bash
cd frontend
npm run build
```

2. **部署到Web服务器**

将 `dist` 目录中的文件部署到Nginx或其他Web服务器。

## 开发说明

### 后端开发

- **添加新API**: 在 `app/routers/` 目录下创建新文件，然后在 `main.py` 中注册
- **数据库模型**: 在 `app/models.py` 中添加，使用SQLAlchemy ORM
- **数据验证**: 在 `app/schemas.py` 中定义Pydantic模型

### 前端开发

- **添加新页面**: 在 `src/views/` 目录下创建.vue文件
- **添加路由**: 在 `src/router/index.js` 中添加路由配置
- **API调用**: 在 `src/api/index.js` 中添加新的API方法

## 默认账号

- **管理员**: admin / admin123

## 注意事项

1. 首次运行前确保MySQL服务已启动
2. 修改数据库配置后需要重新启动后端服务
3. 生产环境请修改 `SECRET_KEY` 并使用强密码
4. 建议定期备份数据库

## 常见问题

**Q: 前端无法连接到后端？**
A: 确保后端服务在8000端口运行，且vite.config.js中的代理配置正确。

**Q: 数据库连接失败？**
A: 检查.env文件中的数据库配置，确保MySQL服务已启动且用户名密码正确。

**Q: 安装依赖失败？**
A: 确保使用的是Python 3.13和Node.js 18+版本。

## 技术支持

如有问题，请检查：
1. 后端API文档: http://localhost:8000/docs
2. 后端健康检查: http://localhost:8000/health
3. 浏览器开发者工具查看网络请求

---

祝您使用愉快！
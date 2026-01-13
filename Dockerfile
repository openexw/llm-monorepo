# ==========================================
# Stage 1: Build Stage
# 使用 uv 官方镜像进行构建，速度更快
# ==========================================
FROM ghcr.io/astral-sh/uv:python3.11-bookworm-slim AS builder

WORKDIR /src

# 将项目文件复制到构建容器
COPY . .

# 执行构建，生成 wheel 包到 dist/ 目录
# 这一步会根据 pyproject.toml 自动处理打包
RUN uv build

# ==========================================
# Stage 2: Runtime Stage
# 使用精简的 Python 镜像运行服务
# ==========================================
FROM python:3.11-slim-bookworm

WORKDIR /app

# 环境变量设置
# 防止 Python 生成 .pyc 文件
ENV PYTHONDONTWRITEBYTECODE=1
# 确保控制台输出不被缓存
ENV PYTHONUNBUFFERED=1

# 从构建阶段复制生成的 .whl 文件
COPY --from=builder /src/dist/llm_monorepo-*.whl .

# 安装 python 包
# 使用 find 命令确保安装正确的文件名，防止版本号变更导致构建失败
RUN pip install --no-cache-dir llm_monorepo-*.whl && \
    rm llm_monorepo-*.whl

# 暴露服务端口
# gRPC Server
EXPOSE 7883
# HTTP Health Check Server
EXPOSE 3000

# 启动服务
# 由于我们在 pyproject.toml 中注册了 [project.scripts] food-app
# pip install 后可以直接通过命令启动
CMD ["food-app"]

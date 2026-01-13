# 定义颜色输出
COLOR_RESET   = \033[0m
COLOR_GREEN   = \033[32m
COLOR_YELLOW  = \033[33m
COLOR_BLUE    = \033[34m
INFO_LOG      = @echo "$(COLOR_BLUE)[INFO]$(COLOR_RESET) "

# 安装依赖
install:
	uv sync

# 运行所有测试
test-all:
	$(INFO_LOG) "Running all tests..."
	uv run pytest

# 仅运行 shared 包的测试
test-shared:
	$(INFO_LOG) "Running shared package tests..."
	uv run --package shared pytest shared/tests

# 仅运行 foodrecognition 的测试
test-food:
	$(INFO_LOG) "Running foodrecognition package tests..."
	uv run --package foodrecognition pytest foodrecognition/tests

# 清理缓存 (pycache)
clean:
	$(INFO_LOG) "Cleaning up pycache..."
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	rm -rf dist/

# 代码风格检查
.PHONY: lint
lint:
	@$(INFO_LOG) "$(COLOR_YELLOW)开始 Ruff 代码风格检查...$(COLOR_RESET)"
	uv run ruff check .
	@$(INFO_LOG) "$(COLOR_YELLOW)开始 MyPy 类型检查...$(COLOR_RESET)"
	uv run mypy .
	@$(INFO_LOG) "$(COLOR_GREEN)代码检查完成 ✨$(COLOR_RESET)"


# 构建并运行 aibot 服务的 Docker 容器
.PHONY: run-foodrecognition-docker
run-foodrecognition-docker:
	#uv build
	@$(INFO_LOG) "$(COLOR_GREEN)构建完成 ✨$(COLOR_RESET)"
	docker build -t foodrecognition:latest .
	@$(INFO_LOG) "$(COLOR_GREEN)Docker 镜像构建完成 ✨$(COLOR_RESET)"
	docker run  -e QIANWEN_API_KEY="your_key_here" -e DOUBAO_API_KEY="your_key_here" foodrecognition:latest
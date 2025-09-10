---
allowed-tools: Bash, Read, Write, LS
---

# 准备测试环境

此命令通过检测测试框架、验证依赖项并配置测试运行器代理来准备测试环境，以实现最佳测试执行。

## 飞行前检查清单

在继续之前，完成这些验证步骤。
不要用飞行前检查进度打扰用户（"我不会去..."）。直接执行并继续。

### 1. 测试框架检测

**JavaScript/Node.js：**
- 检查 package.json 中的测试脚本：`grep -E '"test"|"spec"|"jest"|"mocha"' package.json 2>/dev/null`
- 查找测试配置文件：`ls -la jest.config.* mocha.opts .mocharc.* 2>/dev/null`
- 检查测试目录：`find . -type d \( -name "test" -o -name "tests" -o -name "__tests__" -o -name "spec" \) -maxdepth 3 2>/dev/null`

**Python：**
- 检查 pytest：`find . -name "pytest.ini" -o -name "conftest.py" -o -name "setup.cfg" 2>/dev/null | head -5`
- 检查 unittest：`find . -path "*/test*.py" -o -path "*/test_*.py" 2>/dev/null | head -5`
- 检查要求：`grep -E "pytest|unittest|nose" requirements.txt 2>/dev/null`

**Rust：**
- 检查 Cargo 测试：`grep -E '\[dev-dependencies\]' Cargo.toml 2>/dev/null`
- 查找测试模块：`find . -name "*.rs" -exec grep -l "#\[cfg(test)\]" {} \; 2>/dev/null | head -5`

**Go：**
- 检查测试文件：`find . -name "*_test.go" 2>/dev/null | head -5`
- 检查 go.mod 是否存在：`test -f go.mod && echo "Go 模块已找到"`

**其他语言：**
- Ruby：检查 RSpec：`find . -name ".rspec" -o -name "spec_helper.rb" 2>/dev/null`
- Java：检查 JUnit：`find . -name "pom.xml" -exec grep -l "junit" {} \; 2>/dev/null`

### 2. 测试环境验证

如果未检测到测试框架：
- 告诉用户："⚠️ 未检测到测试框架。请指定您的测试设置。"
- 询问："我应该使用什么测试命令？（例如，npm test、pytest、cargo test）"
- 存储响应以供将来使用

### 3. 依赖项检查

**对于检测到的框架：**
- Node.js：运行 `npm list --depth=0 2>/dev/null | grep -E "jest|mocha|chai|jasmine"`
- Python：运行 `pip list 2>/dev/null | grep -E "pytest|unittest|nose"`
- 验证测试依赖项是否已安装

如果缺少依赖项：
- 告诉用户："❌ 测试依赖项未安装"
- 建议："运行：npm install（或 pip install -r requirements.txt）"

## Instructions

### 1. Framework-Specific Configuration

Based on detected framework, create test configuration:

#### JavaScript/Node.js (Jest)
```yaml
framework: jest
test_command: npm test
test_directory: __tests__
config_file: jest.config.js
options:
  - --verbose
  - --no-coverage
  - --runInBand
environment:
  NODE_ENV: test
```

#### JavaScript/Node.js (Mocha)
```yaml
framework: mocha
test_command: npm test
test_directory: test
config_file: .mocharc.js
options:
  - --reporter spec
  - --recursive
  - --bail
environment:
  NODE_ENV: test
```

#### Python (Pytest)
```yaml
framework: pytest
test_command: pytest
test_directory: tests
config_file: pytest.ini
options:
  - -v
  - --tb=short
  - --strict-markers
environment:
  PYTHONPATH: .
```

#### Rust
```yaml
framework: cargo
test_command: cargo test
test_directory: tests
config_file: Cargo.toml
options:
  - --verbose
  - --nocapture
environment: {}
```

#### Go
```yaml
framework: go
test_command: go test
test_directory: .
config_file: go.mod
options:
  - -v
  - ./...
environment: {}
```

### 2. Test Discovery

Scan for test files:
- Count total test files found
- Identify test naming patterns used
- Note any test utilities or helpers
- Check for test fixtures or data

```bash
# Example for Node.js
find . -path "*/node_modules" -prune -o -name "*.test.js" -o -name "*.spec.js" | wc -l
```

### 3. Create Test Runner Configuration

Create `.claude/testing-config.md` with discovered information:

```markdown
---
framework: {detected_framework}
test_command: {detected_command}
created: [Use REAL datetime from: date -u +"%Y-%m-%dT%H:%M:%SZ"]
---

# Testing Configuration

## Framework
- Type: {framework_name}
- Version: {framework_version}
- Config File: {config_file_path}

## Test Structure
- Test Directory: {test_dir}
- Test Files: {count} files found
- Naming Pattern: {pattern}

## Commands
- Run All Tests: `{full_test_command}`
- Run Specific Test: `{specific_test_command}`
- Run with Debugging: `{debug_command}`

## Environment
- Required ENV vars: {list}
- Test Database: {if applicable}
- Test Servers: {if applicable}

## Test Runner Agent Configuration
- Use verbose output for debugging
- Run tests sequentially (no parallel)
- Capture full stack traces
- No mocking - use real implementations
- Wait for each test to complete
```

### 4. Configure Test-Runner Agent

Prepare agent context based on framework:

```markdown
# Test-Runner Agent Configuration

## Project Testing Setup
- Framework: {framework}
- Test Location: {directories}
- Total Tests: {count}
- Last Run: Never

## Execution Rules
1. Always use the test-runner agent from `.claude/agents/test-runner.md`
2. Run with maximum verbosity for debugging
3. No mock services - use real implementations
4. Execute tests sequentially - no parallel execution
5. Capture complete output including stack traces
6. If test fails, analyze test structure before assuming code issue
7. Report detailed failure analysis with context

## Test Command Templates
- Full Suite: `{full_command}`
- Single File: `{single_file_command}`
- Pattern Match: `{pattern_command}`
- Watch Mode: `{watch_command}` (if available)

## Common Issues to Check
- Environment variables properly set
- Test database/services running
- Dependencies installed
- Proper file permissions
- Clean test state between runs
```

### 5. Validation Steps

After configuration:
- Try running a simple test to validate setup
- Check if test command works: `{test_command} --version` or equivalent
- Verify test files are discoverable
- Ensure no permission issues

### 6. Output Summary

```
🧪 Testing Environment Primed

🔍 Detection Results:
  ✅ Framework: {framework_name} {version}
  ✅ Test Files: {count} files in {directories}
  ✅ Config: {config_file}
  ✅ Dependencies: All installed

📋 Test Structure:
  - Pattern: {test_file_pattern}
  - Directories: {test_directories}
  - Utilities: {test_helpers}

🤖 Agent Configuration:
  ✅ Test-runner agent configured
  ✅ Verbose output enabled
  ✅ Sequential execution set
  ✅ Real services (no mocks)

⚡ Ready Commands:
  - Run all tests: /testing:run
  - Run specific: /testing:run {test_file}
  - Run pattern: /testing:run {pattern}

💡 Tips:
  - Always run tests with verbose output
  - Check test structure if tests fail
  - Use real services, not mocks
  - Let each test complete fully
```

### 7. Error Handling

**Common Issues:**

**No Framework Detected:**
- Message: "⚠️ No test framework found"
- Solution: "Please specify test command manually"
- Store user's response for future use

**Missing Dependencies:**
- Message: "❌ Test framework not installed"
- Solution: "Install dependencies first: npm install / pip install -r requirements.txt"

**No Test Files:**
- Message: "⚠️ No test files found"
- Solution: "Create tests first or check test directory location"

**Permission Issues:**
- Message: "❌ Cannot access test files"
- Solution: "Check file permissions"

### 8. Save Configuration

If successful, save configuration for future sessions:
- Store in `.claude/testing-config.md`
- Include all discovered settings
- Update on subsequent runs if changes detected

## Important Notes

- **Always detect** rather than assume test framework
- **Validate dependencies** before claiming ready
- **Configure for debugging** - verbose output is critical
- **No mocking** - use real services for accurate testing
- **Sequential execution** - avoid parallel test issues
- **Store configuration** for consistent future runs

$ARGUMENTS

# 快速安装

## Unix/Linux/macOS

```bash
curl -sSL https://raw.githubusercontent.com/automazeio/ccpm/main/ccpm.sh | bash
```

或者使用 wget：

```bash
wget -qO- https://raw.githubusercontent.com/automazeio/ccpm/main/ccpm.sh | bash
```

## Windows (PowerShell)

```powershell
iwr -useb https://raw.githubusercontent.com/automazeio/ccpm/main/ccpm.bat | iex
```

或者下载并执行：

```powershell
curl -o ccpm.bat https://raw.githubusercontent.com/automazeio/ccpm/main/ccpm.bat && ccpm.bat
```

## 单行命令替代方案

### Unix/Linux/macOS (直接命令)
```bash
git clone https://github.com/automazeio/ccpm.git . && rm -rf .git
```

### Windows (cmd)
```cmd
git clone https://github.com/automazeio/ccpm.git . && rmdir /s /q .git
```

### Windows (PowerShell)
```powershell
git clone https://github.com/automazeio/ccpm.git .; Remove-Item -Recurse -Force .git
```
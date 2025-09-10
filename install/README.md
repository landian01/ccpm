# 快速安装

## Unix/Linux/macOS

```bash
curl -sSL https://raw.githubusercontent.com/landian01/ccpm/main/install/ccpm.sh | bash
```

或者使用 wget：

```bash
wget -qO- https://raw.githubusercontent.com/landian01/ccpm/main/install/ccpm.sh | bash
```

## Windows (PowerShell)

```powershell
iwr -useb https://raw.githubusercontent.com/landian01/ccpm/main/install/ccpm.bat | iex
```

或者下载并执行：

```powershell
curl -o ccpm.bat https://raw.githubusercontent.com/landian01/ccpm/main/install/ccpm.bat && ccpm.bat
```

## 单行命令替代方案

### Unix/Linux/macOS (直接命令)
```bash
git clone https://github.com/landian01/ccpm.git . && rm -rf .git install
```

### Windows (cmd)
```cmd
git clone https://github.com/landian01/ccpm.git . && rmdir /s /q .git && rmdir /s /q install
```

### Windows (PowerShell)
```powershell
git clone https://github.com/landian01/ccpm.git .; Remove-Item -Recurse -Force .git,install
```
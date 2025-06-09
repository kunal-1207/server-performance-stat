# Server Performance Monitoring Script (`server-stats.sh`)

![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Shell Script](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

## 📝 Overview
This Bash script provides comprehensive server performance statistics in a user-friendly format. It displays system information, resource utilization, process metrics, and network details with color-coded output for better readability.

## 🛠️ Features
- System information (hostname, OS, kernel, uptime)
- CPU, memory, and disk usage metrics
- Top processes by CPU and memory consumption
- Additional system stats (load average, logged-in users)
- Network information (IP addresses)

## 🚀 Installation
```bash
curl -O https://raw.githubusercontent.com/your-repo/server-stats/main/server-stats.sh
chmod +x server-stats.sh
```

## 🏃‍♂️ Usage
```bash
./server-stats.sh
```
For root privileges (recommended for complete data):
```bash
sudo ./server-stats.sh
```

---

## 🔍 Detailed Code Explanation

### 1. Color Definitions
```bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
```
- Sets ANSI color codes for terminal output
- `NC` resets to default terminal color

### 2. System Header
```bash
echo -e "${BLUE}=============================================${NC}"
echo -e "${BLUE}         Linux Server Performance Stats       ${NC}"
```
- Prints a formatted header with blue color
- `-e` enables interpretation of backslash escapes

### 3. System Information
```bash
echo "Hostname: $(hostname)"
echo "OS: $(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)"
```
- `hostname` shows server name
- Extracts OS name from `/etc/os-release` file

### 4. CPU Usage
```bash
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
```
1. `top -bn1`: Runs top in batch mode for one iteration
2. `grep "Cpu(s)"`: Filters CPU line
3. `sed`: Extracts idle percentage
4. `awk`: Calculates used percentage

### 5. Memory Usage
```bash
free -h | awk '/^Mem/ {printf "Total: %s, Used: %s (%.1f%%), Free: %s (%.1f%%)\n", $2, $3, $3/$2*100, $4, $4/$2*100}'
```
- `free -h`: Shows memory in human-readable format
- `awk`: Formats output with percentages

### 6. Disk Usage
```bash
df -h | grep -vE "tmpfs|udev" | awk '{printf "%-20s %8s used (%5s), %8s free\n", $1, $3, $5, $4}'
```
- `df -h`: Disk space in human-readable format
- `grep -vE`: Excludes temporary filesystems
- `awk`: Aligns output in columns

### 7. Top Processes by CPU
```bash
ps -eo pid,ppid,user,%mem,%cpu,cmd --sort=-%cpu | head -n 6
```
- `ps -eo`: Custom process selection
- `--sort=-%cpu`: Sorts by CPU descending
- `head -n 6`: Shows top 5 + header

### 8. Network Information
```bash
echo "Public IP: $(curl -s ifconfig.me 2>/dev/null || echo "Not available")"
```
- `curl ifconfig.me`: Gets public IP
- `2>/dev/null`: Silences errors
- `||`: Fallback if command fails

---

## 📊 Sample Output
![Sample Output](sample-output.png)

## 🛡️ Security Notes
- Requires root for some commands (`lastb`, complete process info)
- Network queries use public IP service (can be disabled)
- No sensitive information is logged or stored

## 🤝 Contributing
Pull requests welcome! Please ensure:
- Compatibility with major Linux distros
- Clear error handling
- Maintain consistent formatting

## 📜 License
MIT License - Free for personal and commercial use


#!/bin/bash

# server-stats.sh - Basic Linux Server Performance Statistics

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Header
echo -e "${BLUE}=============================================${NC}"
echo -e "${BLUE}         Linux Server Performance Stats       ${NC}"
echo -e "${BLUE}=============================================${NC}"
echo ""

# 1. System Information
echo -e "${YELLOW}===== SYSTEM INFORMATION =====${NC}"
echo "Hostname: $(hostname)"
echo "OS: $(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p | sed 's/up //')"
echo "Current Date/Time: $(date)"
echo ""

# 2. CPU Usage
echo -e "${YELLOW}===== CPU USAGE =====${NC}"
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
echo "Total CPU Usage: ${RED}$cpu_usage${NC}"
echo ""

# 3. Memory Usage
echo -e "${YELLOW}===== MEMORY USAGE =====${NC}"
free -h | awk '/^Mem/ {printf "Total: %s, Used: %s (%.1f%%), Free: %s (%.1f%%)\n", $2, $3, $3/$2*100, $4, $4/$2*100}'
echo ""

# 4. Disk Usage
echo -e "${YELLOW}===== DISK USAGE =====${NC}"
df -h | grep -vE "tmpfs|udev" | awk '{printf "%-20s %8s used (%5s), %8s free\n", $1, $3, $5, $4}'
echo ""

# 5. Top 5 Processes by CPU - FIXED VERSION
echo -e "${YELLOW}===== TOP 5 PROCESSES BY CPU =====${NC}"
ps -eo pid,ppid,user,%mem,%cpu,cmd --sort=-%cpu | head -n 6 | awk '{printf "%-8s %-8s %-10s %-6s %-6s %s\n", $1, $2, $3, $4, $5, $6}'
echo ""

# 6. Top 5 Processes by Memory
echo -e "${YELLOW}===== TOP 5 PROCESSES BY MEMORY =====${NC}"
ps -eo pid,ppid,user,%mem,%cpu,cmd --sort=-%mem | head -n 6 | awk '{printf "%-8s %-8s %-10s %-6s %-6s %s\n", $1, $2, $3, $4, $5, $6}'
echo ""

# 7. Additional Information
echo -e "${YELLOW}===== ADDITIONAL INFORMATION =====${NC}"
echo "Load Average: $(cut -d' ' -f1-3 /proc/loadavg)"
echo "Logged-in Users: $(who | wc -l)"
echo "Last Failed Login Attempts:"
sudo lastb 2>/dev/null | head -n 5 || echo "No permission to view failed login attempts"
echo ""

# 8. Network Information
echo -e "${YELLOW}===== NETWORK INFORMATION =====${NC}"
echo "Public IP: $(curl -s ifconfig.me 2>/dev/null || echo "Not available")"
echo "Local IP(s): $(hostname -I)"
echo ""

# Footer
echo -e "${BLUE}=============================================${NC}"
echo -e "${BLUE}  Stats generated on $(date) ${NC}"
echo -e "${BLUE}=============================================${NC}"

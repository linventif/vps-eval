#!/bin/bash
echo "===== SYSTEM DIAGNOSTIC ====="
echo "Hostname: $(hostname)"
echo "User: $(whoami)"
echo "Date: $(date)"
echo "Kernel: $(uname -r)"
echo

echo "===== DISK SPACE ====="
df -h /
df -h /home 2>/dev/null
lsblk
echo

echo "===== MEMORY ====="
free -h
echo "Max memory per process (ulimit): $(ulimit -m)"
echo "Max virtual memory (ulimit): $(ulimit -v)"
echo

echo "===== CPU ====="
lscpu | grep -E 'Model name|CPU\(s\)|Thread|Core'
echo

echo "===== NETWORK TEST ====="
ping -c 2 8.8.8.8 >/dev/null 2>&1 && echo "Outbound network: OK (ping 8.8.8.8)" || echo "Outbound network: BLOCKED"
ping -c 2 google.com >/dev/null 2>&1 && echo "DNS resolution: OK" || echo "DNS resolution: BLOCKED"
echo

echo "===== DOCKER ====="
if command -v docker >/dev/null 2>&1; then
    echo "Docker binary found: $(which docker)"
    docker ps >/dev/null 2>&1 && echo "Docker usable ✅" || echo "Docker installed but not usable ❌"
else
    echo "Docker not installed"
fi
echo

echo "===== STORAGE QUOTA (if any) ====="
quota -s 2>/dev/null || echo "No quota command / no quota set"
echo

echo "===== PROCESS LIMITS ====="
ulimit -a
echo

echo "===== MODULES (restricted env detection) ====="
if command -v module >/dev/null 2>&1; then
    echo "Modules available:"
    module avail 2>&1 | head -n 20
else
    echo "No 'module' command (not an HPC env?)"
fi

echo "===== FINISHED ====="

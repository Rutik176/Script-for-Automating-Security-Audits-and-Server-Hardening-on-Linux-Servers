# 🔐 Linux Security Audit & Hardening Script

## 📝 Description
This script performs a security audit on a Linux system and applies basic hardening measures. It checks for misconfigurations, weak policies, and potential vulnerabilities, and then applies recommended system hardening steps.

---

## 📁 Project Structure

```
.
├── linux_audit_hardening.sh    # Main script file
├── config/
│   └── custom_checks.conf       # Optional: your own shell commands for auditing
└── logs/
    └── audit_report.txt         # Output report
```

---

## ✅ What It Does

1. **Root Check** – Ensures script runs with root privileges.
2. **User & Group Audit** – Detects UID 0 non-root users and accounts with no passwords.
3. **Permission Audit** – Finds world-writable files and SUID/SGID binaries.
4. **Services Audit** – Lists active services and SSH status.
5. **Firewall Check** – Displays current firewall rules using iptables or UFW.
6. **IP Address Summary** – Lists IPv4 configuration.
7. **Update Check** – Lists packages with security updates.
8. **SSH Login Failures** – Shows recent failed login attempts via SSH.
9. **Hardening Actions** – Disables SSH password auth, disables IPv6, and enables auto-updates.
10. **Custom Checks** – Reads and executes commands from `custom_checks.conf`.

---

## 🔧 How to Use

```bash
chmod +x linux_audit_hardening.sh
sudo ./linux_audit_hardening.sh
```

Optional: Add your own checks to `config/custom_checks.conf`

---


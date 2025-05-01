# Linux Security Audit and Hardening Script

## Overview

This Bash script performs an automated security audit and applies basic server hardening for Linux systems. It is designed to be modular, customizable, and easy to use across multiple servers.

## Features

- User and group audits
- File and directory permission scans
- Running services check
- SSH, firewall, and IPv6 configuration
- SUID/SGID and world-writable files detection
- Public vs private IP reporting
- Log monitoring (SSH failures)
- Automatic updates configuration
- Extensible custom checks

# Usage

# Prerequisites

- Bash
- Root privileges
- `unattended-upgrades`, `iptables` or `ufw`, `systemd`

# Run the Script

```bash
sudo bash audit.sh

# Output
 The audit results are saved to:

bash
Copy
Edit
logs/audit_report.txt
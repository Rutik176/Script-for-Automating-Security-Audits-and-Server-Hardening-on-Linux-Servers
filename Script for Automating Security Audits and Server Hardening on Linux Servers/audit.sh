#!/bin/bash

# ================================
# Linux Security Audit & Hardening
# ================================

REPORT_FILE="./logs/audit_report.txt"
CONFIG_FILE="./config/custom_checks.conf"

# Ensure log directory exists
mkdir -p "$(dirname "$REPORT_FILE")"

log() {
    echo "$1" | tee -a "$REPORT_FILE"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root."
        exit 1
    fi
}

audit_users_groups() {
    log "[+] Auditing Users and Groups"
    getent passwd | cut -d: -f1,3 | awk -F: '$2 == 0 && $1 != "root" { print "UID 0 but not root: " $1 }' >> "$REPORT_FILE"
    getent shadow | awk -F: 'length($2)==0 { print "User with no password: " $1 }' >> "$REPORT_FILE"
}

audit_permissions() {
    log "[+] Scanning World-Writable Files"
    find / -type f -perm -0002 -exec ls -l {} \; 2>/dev/null >> "$REPORT_FILE"
    log "[+] Scanning for SUID/SGID Files"
    find / -perm /6000 -type f 2>/dev/null >> "$REPORT_FILE"
}

audit_services() {
    log "[+] Checking Running Services"
    systemctl list-units --type=service --state=running >> "$REPORT_FILE"
    log "[+] Checking for sshd"
    systemctl is-enabled sshd >> "$REPORT_FILE"
}

audit_firewall() {
    log "[+] Firewall Status"
    iptables -L -n -v >> "$REPORT_FILE" || ufw status verbose >> "$REPORT_FILE"
}

audit_ip_config() {
    log "[+] Public vs Private IPs"
    ip -4 addr show | grep inet >> "$REPORT_FILE"
}

audit_updates() {
    log "[+] Checking for Security Updates"
    apt update && apt list --upgradable 2>/dev/null | grep security >> "$REPORT_FILE"
}

audit_logs() {
    log "[+] Recent SSH Login Failures"
    journalctl -u ssh --since "1 day ago" | grep "Failed password" >> "$REPORT_FILE"
}

apply_hardening() {
    log "[+] Applying SSH Hardening"
    sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    systemctl restart sshd

    log "[+] Disabling IPv6 (if not needed)"
    sysctl -w net.ipv6.conf.all.disable_ipv6=1
    echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
    sysctl -p

    log "[+] Enabling Automatic Updates"
    apt install -y unattended-upgrades
    dpkg-reconfigure -plow unattended-upgrades
}

run_custom_checks() {
    log "[+] Running Custom Security Checks"
    if [[ -f $CONFIG_FILE ]]; then
        while IFS= read -r cmd; do
            eval "$cmd" >> "$REPORT_FILE"
        done < "$CONFIG_FILE"
    fi
}

main() {
    check_root
    echo "Security Audit Started: $(date)" > "$REPORT_FILE"

    audit_users_groups
    audit_permissions
    audit_services
    audit_firewall
    audit_ip_config
    audit_updates
    audit_logs
    apply_hardening
    run_custom_checks

    log "[✔] Security Audit Completed: $(date)"
}

main "$@"

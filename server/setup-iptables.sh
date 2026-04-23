#!/bin/bash
# روی سرور خارج این دستور را اجرا کنید تا پورت هاپینگ کار کند

# فوروارد کردن رنج تعیین شده به سمت پورت اصلی هستریا
iptables -t nat -A PREROUTING -i eth0 -p udp --dport 20000:50000 -j REDIRECT --to-port 36712
ip6tables -t nat -A PREROUTING -i eth0 -p udp --dport 20000:50000 -j REDIRECT --to-port 36712

echo "Iptables rules applied for port hopping 20000-50000 -> 36712"

#!/bin/sh

# مقداردهی پورت‌ها در کانفیگ تمپلیت
envsubst < /etc/hysteria/client.template.yaml > /etc/hysteria/client.yaml

echo "Starting Hysteria client on PaaS..."
echo "Assigned Internal Port: $PORT"

# اجرای هستریا با فلگ دیباگ برای لاگ‌های دقیق‌تر شبکه
exec /usr/local/bin/hysteria client -c /etc/hysteria/client.yaml --log-level debug

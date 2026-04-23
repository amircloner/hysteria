FROM alpine:latest

# نصب ابزارهای مورد نیاز برای گرفتن آی‌پی و متغیرها در محیط PaaS
RUN apk add --no-cache gettext jq curl iptables

# دریافت باینری Hysteria نسخه 2
RUN curl -Lo /usr/local/bin/hysteria https://github.com/apernet/hysteria/releases/latest/download/hysteria-linux-amd64 && \
    chmod +x /usr/local/bin/hysteria

COPY client.template.yaml /etc/hysteria/client.template.yaml
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# متغیر پیش‌فرض PORT که در برخی سرویس‌های PaaS به صورت خودکار تغییر می‌کند
ENV PORT=8080 
ENV SERVER_IP=IP_SERVER_KHAREJ
ENV SERVER_PORTS=20000-50000

CMD ["/entrypoint.sh"]

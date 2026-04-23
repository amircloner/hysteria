FROM alpine:latest

# تغییر مخازن به مخزن جایگزین برای دور زدن مشکل قطعی ارتباطات
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# نصب ابزارهای مورد نیاز برای گرفتن آی‌پی و متغیرها در محیط PaaS
RUN apk add --no-cache gettext jq curl iptables

# دریافت باینری Hysteria نسخه 2 با استفاده از پروکسی گیت‌هاب برای دور زدن تحریم‌ها
RUN cu
rl --retry 3 -Lo /usr/local/bin/hysteria https://ghproxy.com/https://github.com/apernet/hysteria/releases/latest/download/hysteria-linux-amd64 && \
    chmod +x /usr/local/bin/hysteria


COPY client.template.yaml /etc/hysteria/client.template.yaml
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# متغیر پیش‌فرض PORT که در برخی سرویس‌های PaaS به صورت خودکار تغییر می‌کند
ENV PORT=8080 
ENV SERVER_IP=159.223.29.48
ENV SERVER_PORTS=20000-50000

CMD ["/entrypoint.sh"]

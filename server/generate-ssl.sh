#!/bin/bash

# SSL/TLS Certificate Generator for Hysteria V2
# این اسکریپت گواهی‌های لازم را در پوشه certs ایجاد می‌کند.

CERTS_DIR="$(pwd)/certs"
mkdir -p "$CERTS_DIR"

echo "================================================="
echo "   Hysteria V2 SSL Certificate Generator"
echo "================================================="
echo "1) تولید گواهی Self-Signed (پیشنهاد شده برای IP مستقیم و Sni Spoofing)"
echo "2) دریافت گواهی معتبر Let's Encrypt (نیازمند دامنه متصل به سرور)"
echo -n "انتخاب شما (1 یا 2): "
read CHOICE

if [ "$CHOICE" == "1" ]; then
    echo "[*] Generating Self-Signed Certificate for SNI Spoofing..."
    # ایجاد گواهینامه self-signed به مدت ۱۰ سال با نام دامنه canva.com
    openssl req -x509 -nodes -newkey rsa:2048 -days 3650 \
        -keyout "$CERTS_DIR/server.key" \
        -out "$CERTS_DIR/server.crt" \
        -subj "/C=US/ST=California/L=San Francisco/O=Cloudflare, Inc./CN=canva.com"
    
    echo "[√] Self-signed certificate generated successfully in $CERTS_DIR"
    echo "    server.crt and server.key are ready."

elif [ "$CHOICE" == "2" ]; then
    echo -n "دامنه خود را وارد کنید (مثال: sub.domain.com): "
    read MY_DOMAIN
    echo -n "ایمیل خود را وارد کنید (برای تایید Let's Encrypt): "
    read MY_EMAIL

    echo "[*] Installing acme.sh for automatic SSL..."
    curl https://get.acme.sh | sh -s email=$MY_EMAIL
    
    # اضافه کردن به مسیر اجرایی موقت
    export PATH="$HOME/.acme.sh:$PATH"

    echo "[*] Generating Let's Encrypt Certificate for $MY_DOMAIN (Standalone mode)..."
    # پورت 80 باید در سرور باز و خالی باشد
    acme.sh --issue -d "$MY_DOMAIN" --standalone
    
    echo "[*] Installing certificate to $CERTS_DIR..."
    acme.sh --install-cert -d "$MY_DOMAIN" \
        --key-file       "$CERTS_DIR/server.key" \
        --fullchain-file "$CERTS_DIR/server.crt" \
        --reloadcmd     "docker restart server-hysteria-1"
        
    echo "[√] Valid certificate generated and installed successfully."
else
    echo "[!] انتخاب نامعتبر است. خروج..."
    exit 1
fi

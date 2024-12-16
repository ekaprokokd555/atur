#!/bin/bash

# Tentukan lokasi file konfigurasi Squid (sesuaikan jika diperlukan)
SQUID_CONF="/etc/squid/squid.conf"

# Backup file konfigurasi sebelum mengubah (opsional)
cp "$SQUID_CONF" "$SQUID_CONF.bak"

# Tambahkan atau ubah aturan ACL untuk mengizinkan HTTP dan menolak HTTPS
# Pastikan tidak ada duplikasi pengaturan, maka kita akan menghapus baris yang sudah ada sebelumnya

# Menghapus aturan lama yang mungkin sudah ada
sed -i '/acl allowed_http/d' "$SQUID_CONF"
sed -i '/http_access allow allowed_http/d' "$SQUID_CONF"
sed -i '/acl denied_https/d' "$SQUID_CONF"
sed -i '/http_access deny denied_https/d' "$SQUID_CONF"

# Menambahkan aturan baru untuk mengizinkan HTTP dan menolak HTTPS
echo "acl allowed_http proto HTTP" >> "$SQUID_CONF"
echo "http_access allow allowed_http" >> "$SQUID_CONF"
echo "acl denied_https proto HTTPS" >> "$SQUID_CONF"
echo "http_access deny denied_https" >> "$SQUID_CONF"

# Restart Squid agar perubahan diterapkan
systemctl restart squid

# Verifikasi status Squid
systemctl status squid

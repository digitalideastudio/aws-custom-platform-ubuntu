#!/bin/sh

echo "[Configuration Deployment] Executed when starting configuration deployment"

. /etc/DIPlatform/platform.config

cd $LIVE_DIR
chown www-data: -R ./
chmod 777 storage/logs
find public -type d -exec chmod 777 {} \;

#!/bin/bash
cd /app && nohup yarn start &
/usr/sbin/nginx -g "daemon off;"

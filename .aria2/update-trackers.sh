#!/bin/sh
# 从 trackerslist 拉取公共 tracker 列表，写入 aria2.conf 的 bt-tracker 行
# 手动执行，或加入 crontab：0 6 * * * ~/.aria2/update-trackers.sh
set -e
url="https://cf.trackerslist.com/all.txt"
conf="$(cd "$(dirname "$0")" && pwd)/aria2.conf"
trackers=$(curl -fsSL "$url" | tr ',' '\n' | sed '/^[[:space:]]*$/d' | paste -sd, -)
if grep -q '^bt-tracker=' "$conf"; then
	sed "s|^bt-tracker=.*|bt-tracker=${trackers}|" "$conf" > "$conf.tmp" && mv "$conf.tmp" "$conf"
else
	echo "bt-tracker=${trackers}" >> "$conf"
fi
echo "已更新 $(echo "$trackers" | tr ',' '\n' | wc -l | tr -d ' ') 个 tracker"

#!/bin/sh
echo "change luci port to 81 to avoid conflict with fluidd / mainsail"
read -p "Press [ENTER] to continue...or [ctrl+c] to exit"
uci del uhttpd.main.listen_http
uci add_list uhttpd.main.listen_http='0.0.0.0:81'
uci add_list uhttpd.main.listen_http='[::]:81'
uci del uhttpd.main.listen_https
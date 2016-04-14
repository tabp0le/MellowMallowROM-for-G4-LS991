#!/system/bin/sh

ccaudit_log_prop=`getprop persist.service.ccaudit.enable`
touch /data/logger/ccaudit.log
chmod 0644 /data/logger/ccaudit.log

case "$ccaudit_log_prop" in
	6)
        /system/bin/logcat -v threadtime -b ccaudit -f /data/logger/ccaudit.log -n 5 -r 4096 *:V
	;;
	5)
        /system/bin/logcat -v threadtime -b ccaudit -f /data/logger/ccaudit.log -n 5 -r 4096 *:D
	;;
	4)
        /system/bin/logcat -v threadtime -b ccaudit -f /data/logger/ccaudit.log -n 5 -r 4096 *:I
	;;
	3)
        /system/bin/logcat -v threadtime -b ccaudit -f /data/logger/ccaudit.log -n 5 -r 4096 *:W
	;;
	2)
        /system/bin/logcat -v threadtime -b ccaudit -f /data/logger/ccaudit.log -n 5 -r 4096 *:E
	;;
	1)
        /system/bin/logcat -v threadtime -b ccaudit -f /data/logger/ccaudit.log -n 5 -r 4096
	;;
esac

#!/system/bin/sh

main_log_prop=`getprop persist.service.main.enable`
vold_prop=`getprop vold.decrypt`
vold_propress=`getprop vold.encrypt_progress`
storage_low_prop=`getprop persist.service.storage.low`

optionR="-r8192"
if [ "$storage_low_prop" = "1" ]; then
    optionR="-r1024"
else
    optionR="-r8192"
fi

touch /data/logger/main.log
chmod 0644 /data/logger/main.log

case "$main_log_prop" in
	6)
        /system/bin/logcat -v threadtime -b main -f /data/logger/main.log -n 4 -r1024
	;;
	5)
        /system/bin/logcat -v threadtime -b main -f /data/logger/main.log -n 99 $optionR
	;;
	4)
        /system/bin/logcat -v threadtime -b main -f /data/logger/main.log -n 49 $optionR
	;;
	3)
        /system/bin/logcat -v threadtime -b main -f /data/logger/main.log -n 19 $optionR
	;;
	2)
        /system/bin/logcat -v threadtime -b main -f /data/logger/main.log -n 9 $optionR
	;;
	1)
    if [ "$vold_prop" = "trigger_default_encryption" ] || [ "$vold_propress" = "0" ] ; then
        touch /cache/encryption_log/main.log
        chmod 0644 /cache/encryption_log/main.log
        /system/bin/logcat -v threadtime -b main -f /cache/encryption_log/main.log -n 4 -r8192
    else
        /system/bin/logcat -v threadtime -b main -f /data/logger/main.log -n 4 $optionR
    fi
	;;
esac

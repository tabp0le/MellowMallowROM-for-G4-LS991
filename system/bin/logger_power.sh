#!/system/bin/sh

power_log_prop=`getprop persist.service.power.enable`
vold_prop=`getprop vold.decrypt`
vold_propress=`getprop vold.encrypt_progress`

touch /data/logger/power.log
chmod 0644 /data/logger/power.log

case "$power_log_prop" in
    6)
        /system/bin/power_logger -f /data/logger/power.log -n 4 -r 1024 -t 300
    ;;
    5)
        /system/bin/power_logger -f /data/logger/power.log -n 99 -r 8192 -t 300
    ;;
    4)
        /system/bin/power_logger -f /data/logger/power.log -n 49 -r 8192 -t 300
    ;;
    3)
        /system/bin/power_logger -f /data/logger/power.log -n 19 -r 8192 -t 300
    ;;
    2)
        /system/bin/power_logger -f /data/logger/power.log -n 9 -r 8192 -t 300
    ;;
    1)
    if [ "$vold_prop" = "trigger_default_encryption" ] || [ "$vold_propress" = "0" ] ; then
        touch /cache/encryption_log/power.log
        chmod 0644 /cache/encryption_log/power.log
        /system/bin/power_logger -f /cache/encryption_log/power.log -n 4 -r 8192 -t 300
    else
        /system/bin/power_logger -f /data/logger/power.log -n 4 -r 8192 -t 300
    fi
    ;;
esac

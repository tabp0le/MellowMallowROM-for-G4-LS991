#!/system/bin/sh

memory_log_prop=`getprop persist.service.memory.enable`

touch /data/logger/memory.log
chmod 0644 /data/logger/memory.log

case "$memory_log_prop" in
    6)
        /system/bin/memory_logger -f /data/logger/memory.log -n 4 -r 1024 -t 300
    ;;
    5)
        /system/bin/memory_logger -f /data/logger/memory.log -n 99 -r 8192 -t 300
    ;;
    4)
        /system/bin/memory_logger -f /data/logger/memory.log -n 49 -r 8192 -t 300
    ;;
    3)
        /system/bin/memory_logger -f /data/logger/memory.log -n 19 -r 8192 -t 300
    ;;
    2)
        /system/bin/memory_logger -f /data/logger/memory.log -n 9 -r 8192 -t 300
    ;;
    1)
        /system/bin/memory_logger -f /data/logger/memory.log -n 4 -r 8192 -t 300
    ;;
esac

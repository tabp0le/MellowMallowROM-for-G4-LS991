#!/system/bin/sh

kernel_log_prop=`getprop persist.service.kernel.enable`
vold_prop=`getprop vold.decrypt`
vold_propress=`getprop vold.encrypt_progress`

ccmode_supported='0'
ccmode_status='0'
ccmode_audit_bit='0'

if [ -f  /proc/sys/crypto/cc_mode_flag ];then
    ccmode_supported='1'
    ccmode_status=$(cat /proc/sys/crypto/cc_mode_flag)
else
    ccmode_supported='0'
    ccmode_status='0'
fi

let "ccmode_audit_bit = ccmode_status & 2"

touch /data/logger/kernel.log
chmod 0644 /data/logger/kernel.log

if  [ "$ccmode_audit_bit" = "2" ] ; then
case "$kernel_log_prop" in
	6)
        /system/bin/kernel_logger -f /data/logger/kernel.log -u ccaudit -s 1048576 -m 5
	;;
	5)
        /system/bin/kernel_logger -f /data/logger/kernel.log -u ccaudit -s 8388608 -m 100
	;;
	4)
        /system/bin/kernel_logger -f /data/logger/kernel.log -u ccaudit -s 8388608 -m 50
	;;
	3)
        /system/bin/kernel_logger -f /data/logger/kernel.log -u ccaudit -s 8388608 -m 20
	;;
	2)
        /system/bin/kernel_logger -f /data/logger/kernel.log -u ccaudit -s 8388608 -m 10
	;;
	1)
    if [ "$vold_prop" = "trigger_default_encryption" ] || [ "$vold_propress" = "0" ] ; then
        touch /cache/encryption_log/kernel.log
        chmod 0644 /cache/encryption_log/kernel.log
        /system/bin/kernel_logger -f /cache/encryption_log/kernel.log -u ccaudit -s 8388608 -m 5
    else
        /system/bin/kernel_logger -f /data/logger/kernel.log -u ccaudit -s 8388608 -m 5
    fi
	;;
esac

else
case "$kernel_log_prop" in
	6)
        /system/bin/kernel_logger -f /data/logger/kernel.log -s 1048576 -m 5
	;;
	5)
        /system/bin/kernel_logger -f /data/logger/kernel.log -s 8388608 -m 100
	;;
	4)
        /system/bin/kernel_logger -f /data/logger/kernel.log -s 8388608 -m 50
	;;
	3)
        /system/bin/kernel_logger -f /data/logger/kernel.log -s 8388608 -m 20
	;;
	2)
        /system/bin/kernel_logger -f /data/logger/kernel.log -s 8388608 -m 10
	;;
	1)
    if [ "$vold_prop" = "trigger_default_encryption" ] || [ "$vold_propress" = "0" ] ; then
        touch /cache/encryption_log/kernel.log
        chmod 0644 /cache/encryption_log/kernel.log
        /system/bin/kernel_logger -f /cache/encryption_log/kernel.log -s 8388608 -m 5
    else
        /system/bin/kernel_logger -f /data/logger/kernel.log -s 8388608 -m 5
    fi
	;;
esac
fi

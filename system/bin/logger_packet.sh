#!/system/bin/sh

packet_log_prop=`getprop persist.service.packet.enable`

touch /data/logger/packet.pcap
chmod 0644 /data/logger/packet.pcap

if test "1" -eq "$packet_log_prop"
then
# 2013-08-08 hobbes.song@lge.com LGP_DATA_TOOL_TCPDUMP  @ver2[START]
build_type=`getprop ro.build.type`
case "$build_type" in
        "user")
            /system/xbin/tcd -i any -C 20 -W 10 -Z root -s 0 -w /data/logger/packet.pcap
        ;;
esac
case "$build_type" in
        "eng" | "userdebug")
            /system/xbin/tcpdump -i any -C 20 -W 10 -Z root -s 0 -w /data/logger/packet.pcap
        ;;
esac
# 2013-08-08 hobbes.song@lge.com LGP_DATA_TOOL_TCPDUMP  @ver2[END]
fi

#!/system/bin/sh
TIMESTAMP=`date +'%Y-%m-%d-%H-%M-%S'`

# Version info for digicl
DIGICL_VER=`getprop ro.build.version.sdk`.3.0

# LEVEL: 0 (Default), 1 (All), 9(FUT)
COPYLEVEL=0

# Build emulated storage paths when appropriate
# See storage config details at http://source.android.com/tech/storage/
EXTERNAL_ADD_STORAGE_ID=`ls /mnt/media_rw`
PATH_EXTERNAL_ADD_STORAGE="/mnt/runtime/default/$EXTERNAL_ADD_STORAGE_ID"
PATH_EXTERNAL_STORAGE=$EXTERNAL_STORAGE
echo External Storage path = $PATH_EXTERNAL_STORAGE
echo External Add Storage, for example Micro-SD, path = $PATH_EXTERNAL_ADD_STORAGE

# Set Internal storage as default path
PATH_TARGET=$PATH_EXTERNAL_STORAGE/logs_backup/logs_backup-$TIMESTAMP

# to seperate copy to internal/external storage
while getopts iealf OPTION
do
    case "$OPTION"  in
    e)
        # to external storage
        if [ ! -n "$EXTERNAL_ADD_STORAGE_ID" ]; then
            # broadcast finished intent
            # Error code -4 : EXTERNAL_ADD_STORAGE is not mounted.
            echo am broadcast --user 0 -a com.lge.android.digicl.intent.COPYLOGS_FAILED --ei error_code -4 --receiver-permission android.permission.DUMP
            am broadcast --user 0 -a com.lge.android.digicl.intent.COPYLOGS_FAILED --ei error_code -4 --receiver-permission android.permission.DUMP

            echo EXTERNAL SD Card is not mounted.
            log -p e -t digicl "EXTERNAL SD Card is not mounted."
            exit 0
        fi
            PATH_TARGET=$PATH_EXTERNAL_ADD_STORAGE/logs_backup/logs_backup-$TIMESTAMP
        ;;
    a)
        echo "Copy all logs..."
        COPYLEVEL=1
        ;;
    f)
        # running digicl.sh for FUT (copy default logs, but except  blue_coredump)
        echo "Copy FUT logs..."
        COPYLEVEL=9
        ;;
    esac
done

echo "COPYLEVEL = $COPYLEVEL"
log -p i -t digicl "COPYLEVEL = $COPYLEVEL"
echo PATH_TARGET = $PATH_TARGET
log -p i -t digicl "PATH_TARGET = $PATH_TARGET"

mkdir -p "$PATH_TARGET"

# prevent media scanning
touch "$PATH_TARGET/../.nomedia"

# Check if the target path is writable
if [ ! -e "$PATH_TARGET/../.nomedia" ]; then
    # broadcast finished intent
    # Error code -2 : Unable to wrtie $PATH_TARGET.
    echo am broadcast --user 0 -a com.lge.android.digicl.intent.COPYLOGS_FAILED --ei error_code -2 --receiver-permission android.permission.DUMP
    am broadcast --user 0 -a com.lge.android.digicl.intent.COPYLOGS_FAILED --ei error_code -2 --receiver-permission android.permission.DUMP
    echo Unable to wrtie $PATH_TARGET.
    log -p e -t digicl "Unable to wrtie $PATH_TARGET"

    exit 0
fi

PHONE_DATE=$(date | grep -v "dummy")
echo "PHONE_DATE = $PHONE_DATE"
PRODUCT_NAME=$(getprop ro.product.name | grep -v "dummy")
echo "PRODUCT_NAME = $PRODUCT_NAME"
PHONE_FINGER=$(getprop ro.build.fingerprint | grep -v "dummy")
echo "PHONE_FINGER = $PHONE_FINGER"
PHONE_SWV=$(getprop ro.lge.swversion | grep -v "dummy")
echo "PHONE_SWV = $PHONE_SWV"
PHONE_FACTORYV=$(getprop ro.lge.factoryversion | grep -v "dummy")
echo "PHONE_FACTORYV = $PHONE_FACTORYV"
PHONE_HWVER=$(getprop ro.lge.hw.revision | grep -v "dummy")
echo "PHONE_HWVER = $PHONE_HWVER"
PHONE_BUILD_TYPE=$(getprop ro.build.type | grep -v "dummy")
echo "PHONE_BUILD_TYPE = $PHONE_BUILD_TYPE"

INFO_FILE_NAME="$PRODUCT_NAME"_"$PHONE_BUILD_TYPE".txt


echo "> Profile of phone...."
echo "=======> $INFO_FILE_NAME"
echo "[ Device Date & TIME at pulling logs]" > $PATH_TARGET/$INFO_FILE_NAME
echo "==> $PHONE_DATE" >> $PATH_TARGET/$INFO_FILE_NAME
echo "" >> $PATH_TARGET/$INFO_FILE_NAME

echo "[ PRODUCT_NAME ]" >> $PATH_TARGET/$INFO_FILE_NAME
echo "==> $PRODUCT_NAME" >> $PATH_TARGET/$INFO_FILE_NAME
echo "" >> $PATH_TARGET/$INFO_FILE_NAME

echo "[ PHONE_BUILD_TYPE ]" >> $PATH_TARGET/$INFO_FILE_NAME
echo "==> $PHONE_BUILD_TYPE" >> $PATH_TARGET/$INFO_FILE_NAME
echo "" >> $PATH_TARGET/$INFO_FILE_NAME

echo "[ Factory Version ]" >> $PATH_TARGET/$INFO_FILE_NAME
echo "==> $PHONE_FACTORYV" >> $PATH_TARGET/$INFO_FILE_NAME
echo "" >> $PATH_TARGET/$INFO_FILE_NAME

echo "[ SW Version ]" >> $PATH_TARGET/$INFO_FILE_NAME
echo "==> $PHONE_SWV" >> $PATH_TARGET/$INFO_FILE_NAME
echo "" >> $PATH_TARGET/$INFO_FILE_NAME

echo "[ HW Version ]" >> $PATH_TARGET/$INFO_FILE_NAME
echo "==> $PHONE_HWVER  ($PHONE_PCB)" >> $PATH_TARGET/$INFO_FILE_NAME
echo "" >> $PATH_TARGET/$INFO_FILE_NAME

echo "[ Fingerprint ]" >> $PATH_TARGET/$INFO_FILE_NAME
echo "==> $PHONE_FINGER" >> $PATH_TARGET/$INFO_FILE_NAME
echo "" >> $PATH_TARGET/$INFO_FILE_NAME

echo "[ digicl.sh Version]" >> $PATH_TARGET/$INFO_FILE_NAME
echo "==> $DIGICL_VER" >> $PATH_TARGET/$INFO_FILE_NAME
echo "" >> $PATH_TARGET/$INFO_FILE_NAME

echo -------------------------------------------
echo ">> extract log files to $PATH_TARGET <<"
echo -------------------------------------------

# ANR
echo "> Retrieving ANR Logs(/data/anr)..."
cp -r /data/anr $PATH_TARGET/anr

# Dontpanic
# move to below

# TOMBSTONES
echo "> Retrieving Tombstones Log(/data/tombstones, /tombstones)..."
cp -r /data/tombstones $PATH_TARGET/tombstones

# Art Tool Report Log : Report*.xml, CrashedReport20120701_233950.rpt
echo "> Retrieving art report files(/data/data/com.lge.art/files/Report/)..."
cp -r /data/data/com.lge.art/files/Report $PATH_TARGET/art

# Multimedia database
echo "> Retrieving MediaDB files(/data/data/com.android.providers.media/databases/)..."
cp -r /data/data/com.android.providers.media/databases $PATH_TARGET/MediaDB

# Modem log
# move to below

# for MTK chipsets
# move to below

# BugReport or QuickDump
echo "> Retrieving BugReport or QuickDump Logs(/data/data/com.android.shell/files/quickdump and bugreports)..."
cp -r /data/data/com.android.shell/files/bugreports $PATH_TARGET/quickdump
cp -r /data/data/com.android.shell/files/bugreports $PATH_TARGET/bugreports

# DROPBOX
#PATH_DROPBOX_TMP="/data/local/tmp/dropbox"
PATH_DROPBOX_TMP="$PATH_TARGET/dropbox"
echo "> Retrieving DROPBOX..."
#rm -rf $PATH_DROPBOX_TMP
mkdir $PATH_DROPBOX_TMP

#dumpsys dropbox SYSTEM_BOOT --print > $PATH_DROPBOX_TMP/system_BOOT.txt
#dumpsys dropbox SYSTEM_RESTART --print > $PATH_DROPBOX_TMP/system_RESTART.txt
#dumpsys dropbox SYSTEM_LAST_KMSG --print > $PATH_DROPBOX_TMP/system_LAST_KMSG.txt
#dumpsys dropbox SYSTEM_RECOVERY_LOG --print > $PATH_DROPBOX_TMP/SYSTEM_RECOVERY_LOG.txt
#dumpsys dropbox APANIC_CONSOLE --print > $PATH_DROPBOX_TMP/APANIC_CONSOLE.txt
#dumpsys dropbox APANIC_THREADS --print > $PATH_DROPBOX_TMP/APANIC_THREADS.txt
#dumpsys dropbox system_app_strictmode --print > $PATH_DROPBOX_TMP/strictmode.txt
#dumpsys dropbox data_app_strictmode --print >> $PATH_DROPBOX_TMP/strictmode.txt

dumpsys dropbox SYSTEM_TOMBSTONE --print | tee $PATH_DROPBOX_TMP/SYSTEM_TOMBSTONE.txt

dumpsys dropbox system_server_anr --print | tee $PATH_DROPBOX_TMP/system_server_anr.txt
dumpsys dropbox system_app_anr --print | tee $PATH_DROPBOX_TMP/system_app_anr.txt
dumpsys dropbox data_app_anr --print | tee $PATH_DROPBOX_TMP/data_app_anr.txt

dumpsys dropbox system_server_crash --print | tee $PATH_DROPBOX_TMP/system_server_crash.txt
dumpsys dropbox system_app_crash --print | tee $PATH_DROPBOX_TMP/system_app_crash.txt
dumpsys dropbox data_app_crash --print | tee $PATH_DROPBOX_TMP/data_app_crash.txt

#adb shell dumpsys dropbox system_server_wtf --print > %PATH_TARGET%\dropbox\WTF.txt
#adb shell dumpsys dropbox system_app_wtf --print >> %PATH_TARGET%\dropbox\WTF.txt
#adb shell dumpsys dropbox data_app_wtf --print >> %PATH_TARGET%\dropbox\WTF.txt
#adb shell dumpsys dropbox BATTERY_DISCHARGE_INFO --print > %PATH_TARGET%\dropbox\BATTERY_DISCHARGE_INFO.txt

dumpsys dropbox --file | tee $PATH_DROPBOX_TMP/dropbox_files.txt
#echo cp -r $PATH_DROPBOX_TMP $PATH_TARGET/
#cp -r $PATH_DROPBOX_TMP $PATH_TARGET/
#echo rm -rf $PATH_DROPBOX_TMP
#rm -rf $PATH_DROPBOX_TMP

# Hprof_dump => ex : JNI 2000 overflow
echo "> Retrieving hprof_dump (/data/hprof_dump)..."
cp /data/hprof_dump_1701.hprof $PATH_TARGET
cp /data/hprof_dump_1801.hprof $PATH_TARGET
cp /data/hprof_dump_1901.hprof $PATH_TARGET
cp /data/hprof_dump_final.hprof $PATH_TARGET

# dump file (Vol up + down + power key Long Click)
echo "> Retrieving dump files(/data/dump, /sdcard/dumpreports)..."
cp -r /data/dump $PATH_TARGET/dump

# running digicl.sh for FUT
if [ $COPYLEVEL == 9 ]; then
    # Dontpanic
    echo "> Retrieving Dontpanic Logs(/data/dontpanic)..."
    mkdir $PATH_TARGET/dontpanic
    for FILENAME in `ls /data/dontpanic`
    do
    if [[ $FILENAME == blue_coredump* ]]; then
        echo "skip $FILENAME"
    elif [[ $FILENAME == maps* ]]; then
        echo "skip $FILENAME"
    else
            cp -v /data/dontpanic/$FILENAME $PATH_TARGET/dontpanic/
        fi
    done

    # CKErrorReport
    echo "> Retrieving and Clearing ckerror Log(/data/system/ckerror)..."
    cp -r /data/system/ckerror $PATH_TARGET/ckerror

else
    # dontpanic
    cp -r /data/dontpanic $PATH_TARGET/dontpanic

    # CKErrorReport
    echo "> Retrieving ckerror Log(/data/system/ckerror)..."
    cp -r /data/system/ckerror $PATH_TARGET/ckerror

fi

# extra logs
if [ $COPYLEVEL == 1 ]; then
    # Modem Log
    echo "> Retrieving modem event logs(/sdcard/moca_logs)..."
    cp -r $PATH_EXTERNAL_STORAGE/moca_logs $PATH_TARGET/moca_logs

    # Logs for MTK Chipset models
    echo "> Retrieving MTK logs(/sdcard/mtklog, /data/aee_exp)..."
    cp -r /data/aee_exp $PATH_TARGET/aee_exp
    cp -r $PATH_EXTERNAL_STORAGE/mtklog $PATH_TARGET/mtklog

    # ODL log
    cp -r $PATH_EXTERNAL_STORAGE/lgodm $PATH_TARGET/lgodm
fi

# Android Log
echo "> Retrieving Android Log files(/data/logger, /data/log)..."
cp -r /data/logger $PATH_TARGET/logger
cp /proc/last_kmsg $PATH_TARGET/logger/last_kmsg.log

# broadcast finished intent
echo am broadcast --user 0 -a com.lge.android.digicl.intent.COPYLOGS_COMPLETED --es path $PATH_TARGET --receiver-permission android.permission.DUMP
am broadcast --user 0 -a com.lge.android.digicl.intent.COPYLOGS_COMPLETED --es path $PATH_TARGET --receiver-permission android.permission.DUMP

log -p i -t digicl "digicl.sh completed sucessfully"

echo "------------------------------------------------------------"
echo ">> All Logs are saved into Dir : $PATH_TARGET"
echo ">> Pull logging completed sucessfully!!!"
echo "------------------------------------------------------------"


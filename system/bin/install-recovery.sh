#!/system/bin/sh
if ! applypatch -c EMMC:/dev/block/bootdevice/by-name/recovery:29399040:ba9cfebb9e8784f09874946f5b09c510b657a59e; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/bootdevice/by-name/boot:28194816:6c3d34b4c66ffc93cf3e3fd8f0fbdd030c81e838 EMMC:/dev/block/bootdevice/by-name/recovery ba9cfebb9e8784f09874946f5b09c510b657a59e 29399040 6c3d34b4c66ffc93cf3e3fd8f0fbdd030c81e838:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi

#!/system/bin/sh
# My Charging Controller
# mcc Boot 2 (201807221)
# JayminSuthar @ xda-developers

# Copyright (c) 2018 Jaymin Suthar. All rights reserved.

# This file is a part of "My Charging Controller (mcc)".

# mcc is released under the terms of the GNU GPL v3, as been
## published by the Free Software Foundation. And permission
## hereby is granted to use, modify or redistribute it maybe
## partially or entirely under GPLv3 only.

# mcc was written in a hope of being useful. And any kind of
## warranty is not provided. See GPLv3 for details.

# You should already have received a copy of GPLv3 with mcc,
## if not, see <http://www.gnu.org/licenses/>.

mod_dir=${0%/*};
log_dir=$mod_dir/log;
bin_dir=$mod_dir/bin;
sig_path=$mod_dir/pfsd_done;

while [ ! -f $sig_path ]; do sleep 0.1; done;

(
set -x 2>>$log_dir/boot.log;

umask 022;

rm $sig_path $mod_dir/lock;

$bin_dir/busybox --install $bin_dir/;

sed -i 's/^daemon_do=.*/daemon_do=default/' $mod_dir/mcc.conf;

sleep 120;
chmod 0755 $(ls /system/xbin/mcc || ls /system/bin/mcc);

disable_mcc_logs=true mcc --launch-daemon </dev/null >/dev/null 2>&1;

ps | grep -v grep | grep '{mcc}' | grep '\-\-launch\-daemon$' >&2;

) 2>>$log_dir/boot_err.log &
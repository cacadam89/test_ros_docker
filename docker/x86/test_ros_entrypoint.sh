#!/bin/bash
set -e

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"

# start avahi daemon
/etc/init.d/dbus start &>/dev/null
service avahi-daemon start &>/dev/null

exec "$@"

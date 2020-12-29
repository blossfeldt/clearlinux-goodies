#!/bin/bash
#
# fake /etc/os-release for a short amount of time.
# useful for programs that allow certain functions
# for safe-listed os. e.g. Screensharing with ZOOM
# under Wayland (here it is sufficent to start
# screenharing right after executing this script)
# /etc/fake-release (containing a os identification)
# is required

lead_time=1s
transition=3s

sudo printf ''
cd /etc
sleep $lead_time
sudo rm os-release
sudo ln -s fake-release os-release
cat os-release
echo
sleep $transition
sudo rm os-release
sudo ln -s ../usr/lib/os-release os-release
cat os-release

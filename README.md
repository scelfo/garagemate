# garagemate
Scripts to use [GarageMate](https://bluemate.com) from Linux.

The [adb.sh](https://github.com/scelfo/garagemate/blob/master/adb.sh) script is
a cheat to automate an attached android device running the [GarageMate
app](https://play.google.com/store/apps/details?id=com.bluemate.garagemate) to
open a garage door equiped with the [GarageMate
receiver](https://bluemate.com).

Eventually, when BTLE support in Linux becomes reliable, I will add a script
that communicates directly from Linux to the paired GarageMate receiver.
Unfortunately, the currently available Linux kernel drivers and
[BlueZ](http://www.bluez.org) stack are not compatible with GarageMate.  In
particular (as of 1/19/16) the kernel in [Ubuntu
15.10](http://releases.ubuntu.com/15.10) doesn't support the security protocol
used by GarageMate and the kernel in [openSUSE
Tumbleweed](https://en.opensuse.org/Portal:Tumbleweed) is able to pair with
GarageMate but the BlueZ package is missing the GATTTool binary.  I could
probably figure out why GATTTool didn't come with the BlueZ package on openSUSE
Tumbleweed but I didn't want to spend a lot of time getting something to work
on a distribution that would likely break in the near future due to bleeding
edge package updates.

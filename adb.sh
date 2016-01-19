#!/bin/bash
#
# Tony Scelfo
# scelfo@gmail.com
#
# Use an attached android device running GarageMate4.0 to open a garage door
# using the GarageMate hardware available at https://bluemate.com.
# https://play.google.com/store/apps/details?id=com.bluemate.garagemate
#
# This script works with a Nexus 7 tablet. It should work with any android
# device by might need some modifications in the unlock_the_screen_by_swiping_up
# function which simulates an upwards swipe from the bottom of the screen as is
# required to unlock the screen on a Nexus 7. The ANDROID_ID variable should
# also be updated to match your android device.
#
# This script uses Android Debug Bridge:
# http://developer.android.com/tools/help/adb.html

# This is the overall workflow to click the GarageMate button on an attached
# android device. Helper functions are used to make the bash script readable.
# This method is called from the bottom of the file.
function click_garage_mate_button {
  # As a sanity check, make sure GarageMate isn't running.
  kill_garage_mate

  # Turn the screen off and on to ensure we get the lock screen.
  turn_the_screen "OFF"
  turn_the_screen "ON"

  # Unlock the standard Nexus 7 lock screen by swiping up.
  unlock_the_screen_by_swiping_up

  # Open the GarateMate app.
  launch_garage_mate

  # This might be unnecessary but helps ensure the button is ready to click.
  sleep 1

  # Click on the GarageMate button which is in the center of the screen.
  tap_the_center_of_the_screen

  # This might also be unnecessary but helps ensure the GarageMate app isn't
  # confused by seeing the screen quickly turn off after the button is tapped.
  sleep 1

  # Tidy up.
  turn_the_screen "OFF"
  kill_garage_mate
}

# This is the ID of the attached android device. Get these IDs by running
# "adb devices".  Specifying an ID allows this script to work if more than one
# device is plugged in.
ANDROID_ID="06df6dfc"

# Gather some information about the screen size of the device.
dimension=$(adb -s ${ANDROID_ID} shell wm size | grep -w "[0-9]*x[0-9]*" -o)
width=$(echo ${dimension} | cut -dx -f 1)
height=$(echo ${dimension} | cut -dx -f 2)
center_width=$(( ${width} / 2 ))
center_height=$(( ${height} / 2 ))

# Turns the screen off or on based on passed param of "ON" or "OFF". This
# function will do nothing if the screen is already in the desired state.
function turn_the_screen {
  adb -s ${ANDROID_ID} shell dumpsys display | grep mScreenState=${1} \
    > /dev/null \
    || adb -s ${ANDROID_ID} shell input keyevent KEYCODE_POWER
}

# On a standard Nexus 7, the screen can be unlock by swiping upwards from near
# the bottom of the screen.
function unlock_the_screen_by_swiping_up {
  swipe_duration_ms=300
  swipe_start_height=$(( ${height} * 9 / 10 ))
  swipe_end_height=$(( ${height} * 3 / 4 ))
  adb -s ${ANDROID_ID} shell input swipe \
    ${center_width} ${swipe_start_height} \
    ${center_width} ${swipe_end_height} \
    ${swipe_duration_ms}
}

function kill_garage_mate {
  adb -s ${ANDROID_ID} shell am force-stop com.bluemate.garagemate
}

function launch_garage_mate {
  adb -s ${ANDROID_ID} shell am start \
    com.bluemate.garagemate/com.bluemate.garagemate.MainView
}

function tap_the_center_of_the_screen {
  adb -s ${ANDROID_ID} shell input tap ${center_width} ${center_height}
}

# Run the workflow which is defined at the top of the file for readability.
click_garage_mate_button

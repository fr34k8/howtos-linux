#!/bin/bash
# led0=green | led1=red

# Functions

led_default() {

default_trigger_led0="none [mmc0] timer oneshot heartbeat backlight gpio cpu0 default-on input rfkill0 phy0rx phy0tx phy0assoc phy0radio"
default_trigger_led1="none mmc0 timer oneshot heartbeat backlight gpio cpu0 default-on [input] rfkill0 phy0rx phy0tx phy0assoc phy0radio"

echo "$default_trigger_led0" >/sys/class/leds/led0/trigger
#echo "$default_trigger_led1" >/sys/class/leds/led1/trigger
echo 0 >/sys/class/leds/led1/trigger
} # led_default

disable_led_triggers() {

echo none >/sys/class/leds/led0/trigger
echo none >/sys/class/leds/led1/trigger
} # disable_led_triggers

led_green() {
  disable_led_triggers
  echo 1 >/sys/class/leds/led0/brightness
  echo 0 >/sys/class/leds/led1/brightness
}

led_red() {
  disable_led_triggers
  echo 0 >/sys/class/leds/led0/brightness
  echo 1 >/sys/class/leds/led1/brightness
}

# Main


if [ -z `pidof motion` ];
then
  led_default
else
  if curl -sf http://localhost:8080/0/detection/status | grep PAUSE >/dev/null;
  then
    led_green
  else
    led_red
  fi
fi

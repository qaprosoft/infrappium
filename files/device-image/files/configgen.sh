#!/bin/bash

unauthorized=true

while [[ $unauthorized ]]
do
    sleep 1
    unauthorized=`adb devices | grep unauthorized`
done

# device type
isTablet=`adb shell getprop ro.build.characteristics | grep tablet`

# abi
arm=`adb shell getprop ro.product.cpu.abi | grep arm`

# version
ANDROID_VERSION=`adb shell getprop | grep ro.build.version.release |  sed 's/^.*:.*\[\(.*\)\].*$/\1/g'`

# display size
info=`adb shell dumpsys display | grep -A 20 DisplayDeviceInfo`
width=`echo ${info} | sed 's/^.* \([0-9]\{3,4\}\) x \([0-9]\{3,4\}\).*density \([0-9]\{3\}\),.*$/\1/g'`
height=`echo ${info} | sed 's/^.* \([0-9]\{3,4\}\) x \([0-9]\{3,4\}\).*density \([0-9]\{3\}\),.*$/\2/g'`
density=`echo ${info} | sed 's/^.* \([0-9]\{3,4\}\) x \([0-9]\{3,4\}\).*density \([0-9]\{3\}\),.*$/\3/g'`
let widthDp=${width}/${density}
let heightDp=${height}/${density}
let sumW=${widthDp}*${widthDp}
let sumH=${heightDp}*${heightDp}
let sum=${sumW}+${sumH}

if [[ $softwarebuttons ]]
then
    HARDWAREBUTTONS=false
else
    HARDWAREBUTTONS=true
fi

if [[ $isTablet ]]
then
    DEVICETYPE='Tablet'
else
    DEVICETYPE='Phone'
fi

if [[ $arm ]]
then
    ABI='ARM'
else
    ABI='X86'
fi

if [[ ${sum} -ge 81 ]]
then
    DISPLAYSIZE=10
else
    DISPLAYSIZE=7
fi

# current host
HOST=`awk 'END{print $1}' /etc/hosts`

cat << EndOfMessage
{
  "capabilities":
      [
        {
          "browserName": "${DEVICENAME}",
          "version":"${ANDROID_VERSION}",
          "maxInstances": 1,
          "platform":"ANDROID",
	  "deviceName": "${DEVICENAME}",
          "platformName":"ANDROID",
          "platformVersion":"${ANDROID_VERSION}",
	  "udid": "${DEVICEUDID}",
	  "adb_port": ${ADB_PORT}
        }
      ],
  "configuration":
  {
    "proxy": "com.qaprosoft.carina.grid.MobileRemoteProxy",
    "url":"http://${HOST}:${PORT}/wd/hub",
    "port": ${PORT},
    "host": "${HOST}",
    "hubPort": 4445,
    "hubHost": "smule.qaprosoft.com",
    "register": true,
    "registerCycle": 5000,
    "cleanUpCycle": 5000,
    "timeout": 60,
    "browserTimeout": 60,
    "nodeStatusCheckTimeout": 5000,
    "nodePolling": 5000,
    "role": "node",
    "unregisterIfStillDownAfter": 60000,
    "downPollingLimit": 2,
    "debug": true,
    "servlets" : [],
    "withoutServlets": [],
    "custom": {}
  }
}
EndOfMessage

#!/bin/bash
# adb tcpip 5555

PHONE_IP="10.91.131.88"

adb connect "$PHONE_IP:5555"
flutter run -d "$PHONE_IP:5555" --debug --hot

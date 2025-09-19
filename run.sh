#!/bin/bash
# adb tcpip 5555

PHONE_IP="10.50.153.168"

adb connect "$PHONE_IP:5555"
flutter run -d "$PHONE_IP:5555" --debug --hot

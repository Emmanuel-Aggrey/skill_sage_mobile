#!/bin/bash
PHONE_IP="10.135.223.225"

adb connect "$PHONE_IP:5555"
flutter run -d "$PHONE_IP:5555" --debug --hot

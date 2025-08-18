#!/bin/bash
PHONE_IP="10.20.133.71"

adb connect "$PHONE_IP:5555"
flutter run -d "$PHONE_IP:5555" --debug --hot

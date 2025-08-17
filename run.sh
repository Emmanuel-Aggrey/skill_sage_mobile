#!/bin/bash
PHONE_IP="10.51.88.49"

adb connect "$PHONE_IP:5555"
flutter run -d "$PHONE_IP:5555" --debug --hot

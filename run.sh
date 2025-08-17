#!/bin/bash
PHONE_IP="10.71.187.149"

adb connect "$PHONE_IP:5555"
flutter run -d "$PHONE_IP:5555" --debug --hot

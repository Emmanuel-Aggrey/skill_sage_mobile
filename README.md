# Skill Sage

A Flutter app for Skill Sage.

### Install dependencies

```bash
flutter pub get
```

### Android Wireless Debugging

1. Enable Developer Options and USB debugging on Android device

```bash
adb devices
```

2. Enable TCP/IP mode:

```bash
adb tcpip 5555
```

3. Disconnect USB and connect wirelessly:

```bash
adb connect <PHONE_IP>:5555
```

4. Verify:

```bash
flutter devices
```

5. Run the app:

```bash
flutter run -d <PHONE_IP>:5555
```

6. Disconnect:

```bash
adb disconnect <PHONE_IP>:5555
```

## Development

### List all connected devices

```bash
flutter devices
```

### Run the app on all connected devices

```bash
flutter run
```

### Run the app on a specific device

```bash
flutter run -d <device_id>
```

### Build an APK (Android)

```bash
flutter build apk
```

### Build an App Bundle (Android)

```bash
flutter build appbundle
```

### Build the app for iOS

```bash
flutter build ios
```

# Flutter Compass App

A simple and elegant compass application built using Flutter. This app utilizes the device's magnetometer and accelerometer sensors to provide accurate directional readings.

## Features
- Real-time compass direction updates
- Smooth UI animations
- Displays heading in degrees
- Works without an internet connection
- Supports both portrait and landscape modes

## Screenshots

<img src="https://private-user-images.githubusercontent.com/18459313/461526412-40a7d0e6-c936-4058-b371-ae98551498d8.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NTE0NjA1ODUsIm5iZiI6MTc1MTQ2MDI4NSwicGF0aCI6Ii8xODQ1OTMxMy80NjE1MjY0MTItNDBhN2QwZTYtYzkzNi00MDU4LWIzNzEtYWU5ODU1MTQ5OGQ4LnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTA3MDIlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwNzAyVDEyNDQ0NVomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPWM5ODkzNTc0ZDhhOTM4ZDMzZTk3Nzg3YzRiNDA5MWQ1Y2I5MDI0NmU3YjBhOTZhY2NkNTg2NWRhYmRjYTZmOGUmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.OnI5eIDIOexKVDpEoc6DAHnxO5PogiWhd6rp0s9VbxU" width="400"/>

## Getting Started
### Prerequisites
Ensure you have Flutter installed. You can download it from the official [Flutter website](https://flutter.dev/).

### Installation
Clone the repository:
```sh
git clone https://github.com/AminMemariani/flutter-compass.git
cd flutter-compass
```

Install dependencies:
```sh
flutter pub get
```

Run the app:
```sh
flutter run
```

## Dependencies
This project uses the following Flutter plugins:
- [flutter_compass](https://pub.dev/packages/flutter_compass)
- [permission_handler](https://pub.dev/packages/permission_handler)

## Permissions
For Android, ensure the following permissions are added in `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
```

For iOS, add the following to `Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need access to your location to show the compass direction</string>
```

## Contribution
Contributions are welcome! Feel free to submit a pull request.

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.

## Contact
For any queries, please consider opening an issue.


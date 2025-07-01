# Flutter Compass App

A simple and elegant compass application built using Flutter. This app utilizes the device's magnetometer and accelerometer sensors to provide accurate directional readings.

## Features
- Real-time compass direction updates
- Smooth UI animations
- Displays heading in degrees
- Works without an internet connection
- Supports both portrait and landscape modes

## Screenshots

![Compass App Screenshot](https://private-user-images.githubusercontent.com/18459313/461164435-002a865c-f5bc-4282-b9e4-881854d1eecc.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NTEzOTAzNzYsIm5iZiI6MTc1MTM5MDA3NiwicGF0aCI6Ii8xODQ1OTMxMy80NjExNjQ0MzUtMDAyYTg2NWMtZjViYy00MjgyLWI5ZTQtODgxODU0ZDFlZWNjLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTA3MDElMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwNzAxVDE3MTQzNlomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTNiNTNkYWM2N2I5NjI0N2RiYzNhNGY3MTJhYWI4OTAzNDMyYzc4YWFiOTk4ZmFkMGY5MTY1NDgxZDM1YjQ1YzEmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.KqpMF8VxSgDQq9JDYotpB5FE3Iv5o09B2tt7bMg_fbA)

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


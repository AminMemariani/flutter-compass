# Flutter Compass App

A simple and elegant compass application built using Flutter. This app utilizes the device's magnetometer and accelerometer sensors to provide accurate directional readings.

## Features
- Real-time compass direction updates
- Smooth UI animations
- Displays heading in degrees
- Works without an internet connection
- Supports both portrait and landscape modes

## Screenshots
<!-- Add screenshots here -->

## Getting Started
### Prerequisites
Ensure you have Flutter installed. You can download it from the official [Flutter website](https://flutter.dev/).

### Installation
Clone the repository:
```sh
git clone https://github.com/yourusername/flutter-compass-app.git
cd flutter-compass-app
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
For any queries, contact [your email or GitHub profile].


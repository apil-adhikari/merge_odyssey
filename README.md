# Merge Odyssey

A viral hybrid casual merge adventure game built with Flutter and Flame.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

## Firebase Setup

Before running the app, you need to configure Firebase:

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add your Android app with package name `com.example.mergeodyssey`
3. Add your iOS app with bundle ID `com.example.mergeodyssey`
4. Download configuration files:
   - Android: `google-services.json` → place in `android/app/`
   - iOS: `GoogleService-Info.plist` → place in `ios/Runner/`
5. Install FlutterFire CLI: `dart pub global activate flutterfire_cli`
6. Run: `flutterfire configure` to generate `firebase_options.dart`

### Firebase Services Used

- Authentication (Anonymous + Google)
- Cloud Firestore (Player progress, challenges)
- Realtime Database
- Analytics
- Dynamic Links (Challenge sharing)
- Remote Config (A/B testing, feature flags)

### Local Development

For local development with Firebase emulators:

1. Install Firebase CLI: `npm install -g firebase-tools`
2. Initialize emulators: `firebase init emulators`
3. Start emulators: `firebase emulators:start`

The app will automatically use emulators when running in debug mode if they are available.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

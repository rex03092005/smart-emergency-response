# ResQNet – Smart Emergency Response & Incident Reporting System

ResQNet is an offline-first, production-ready Flutter application designed for rapid emergency incident reporting and management. Built with modern UI patterns and robust state management, it ensures that critical reports are saved even without an internet connection and automatically synced to the cloud when connectivity is restored.

## Features

- **Offline-First Architecture**: Uses Hive for local, encrypted data storage.
- **Auto-Syncing**: Seamlessly syncs offline reports to Firebase Cloud Firestore when the device comes back online.
- **Priority Handling**: Visualizes critical, high, medium, and low priority incidents with distinct UI patterns (e.g., pulsing animations for critical alerts).
- **Admin Dashboard**: Real-time analytics and incident management, including bulk-resolution tools.
- **Cross-Platform Compatibility**: Fully functional on Web, Android, and iOS.
- **Responsive Material 3 UI**: Beautiful light and dark themes using custom Google Fonts (Inter).

## Technology Stack

- **Framework**: Flutter
- **State Management**: Riverpod (`flutter_riverpod`)
- **Local Database**: Hive (`hive_flutter`)
- **Cloud Database**: Firebase Cloud Firestore
- **Routing**: GoRouter
- **Analytics**: FL Chart

## Getting Started

### Prerequisites

- Flutter SDK (^3.8.0)
- Dart SDK
- A Firebase Project

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/rex03092005/smart-emergency-response.git
   cd smart-emergency-response
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure Firebase:
   Ensure you have the FlutterFire CLI installed, then run:
   ```bash
   flutterfire configure
   ```

4. Run the app:
   ```bash
   flutter run -d chrome
   ```

## Academic Requirements Met
- ✅ Public GitHub repository maintained.
- ✅ Structured Commit History:
  1. Project Initialization
  2. UI Implementation
  3. Core Logic (Incident + Priority Handling)
  4. Offline Storage & Final Enhancements

## Developer

Developed by **23IT018**.

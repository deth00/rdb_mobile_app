# Biometric Authentication Implementation

This document describes the biometric authentication system implemented in the mobile banking app.

## Overview

The biometric authentication system provides secure access to the banking app using fingerprint, Face ID, or other biometric methods supported by the device. It's built using the `local_auth` package and integrated with Riverpod for state management.

## Features

- **Multi-platform support**: Works on both Android and iOS
- **Multiple biometric types**: Supports fingerprint, Face ID, and iris scanning
- **Automatic detection**: Automatically detects available biometric methods on the device
- **User preferences**: Users can enable/disable biometric authentication
- **Secure storage**: Biometric settings are stored securely using SharedPreferences
- **Error handling**: Comprehensive error handling with user-friendly messages
- **Localization**: Supports Lao language for user interface

## Architecture

### Core Components

1. **BiometricService** (`lib/core/services/biometric_service.dart`)
   - Core service for biometric operations
   - Handles device capability detection
   - Manages user preferences
   - Provides authentication methods

2. **BiometricProvider** (`lib/features/auth/logic/biometric_provider.dart`)
   - Riverpod state management for biometric features
   - Manages biometric state and operations
   - Provides reactive UI updates

3. **BiometricAuthWidget** (`lib/widgets/biometric_auth_widget.dart`)
   - Reusable UI component for biometric authentication
   - Handles authentication flow and user feedback
   - Supports customization for different use cases

## Setup

### Dependencies

The following dependencies are already included in `pubspec.yaml`:

```yaml
dependencies:
  local_auth: ^2.3.0
  shared_preferences: ^2.5.3
  flutter_riverpod: ^2.6.1
```

### Permissions

#### Android
Add the following permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC" />
<uses-permission android:name="android.permission.USE_FINGERPRINT" />
```

#### iOS
Add the following to `ios/Runner/Info.plist`:

```xml
<key>NSFaceIDUsageDescription</key>
<string>This app uses Face ID to securely authenticate you for banking transactions.</string>
```

## Usage

### Basic Authentication

```dart
import 'package:moblie_banking/core/services/biometric_service.dart';

// Check if biometric is available
bool isAvailable = await BiometricService.isBiometricAvailable();

// Authenticate user
bool isAuthenticated = await BiometricService.authenticate(
  reason: 'Please authenticate to continue',
);
```

### Using the Provider

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/features/auth/logic/biometric_provider.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biometricState = ref.watch(biometricProvider);
    
    return Column(
      children: [
        if (biometricState.isAvailable)
          Switch(
            value: biometricState.isEnabled,
            onChanged: (value) {
              if (value) {
                ref.read(biometricProvider.notifier).enableBiometric();
              } else {
                ref.read(biometricProvider.notifier).disableBiometric();
              }
            },
          ),
      ],
    );
  }
}
```

### Using the Widget

```dart
import 'package:moblie_banking/widgets/biometric_auth_widget.dart';

BiometricAuthWidget(
  title: 'Authenticate',
  subtitle: 'Use fingerprint or Face ID',
  onSuccess: () {
    // Handle successful authentication
    print('Authentication successful');
  },
  onFailure: () {
    // Handle authentication failure
    print('Authentication failed');
  },
)
```

### Integration in Screens

#### Login Screen
The login screen includes a biometric authentication button that appears when biometric authentication is available and enabled.

#### Settings Screen
The settings screen allows users to enable/disable biometric authentication with proper error handling and user feedback.

#### Transaction Screens
Sensitive operations like money transfers can require biometric authentication using the `BiometricAuthWidget`.

## Implementation Details

### BiometricService Methods

- `isBiometricAvailable()`: Check if device supports biometric authentication
- `getAvailableBiometrics()`: Get list of available biometric types
- `isBiometricEnabled()`: Check if user has enabled biometric authentication
- `setBiometricEnabled(bool)`: Enable or disable biometric authentication
- `authenticate()`: Perform biometric authentication
- `getBestAvailableBiometricType()`: Get the best available biometric type for the device

### BiometricProvider State

```dart
class BiometricState {
  final bool isLoading;
  final bool isAvailable;
  final bool isEnabled;
  final List<BiometricType> availableBiometrics;
  final BiometricType? bestBiometricType;
  final String? error;
}
```

### Error Handling

The system handles various error scenarios:

- Device not supporting biometric authentication
- User not enrolled in biometric authentication
- Authentication failure
- Permission denied
- Hardware errors

### Security Considerations

1. **Secure Storage**: Biometric preferences are stored using SharedPreferences
2. **Fallback**: Users can still use traditional login methods
3. **Error Messages**: User-friendly error messages in Lao language
4. **Timeout**: Authentication sessions have appropriate timeouts

## Testing

### Android Testing
1. Use Android emulator with fingerprint sensor
2. Configure fingerprint in device settings
3. Test with different biometric types

### iOS Testing
1. Use iOS simulator with Face ID support
2. Configure Face ID in device settings
3. Test with Touch ID on physical devices

### Test Scenarios
1. Enable biometric authentication
2. Disable biometric authentication
3. Authentication success
4. Authentication failure
5. Device without biometric support
6. User not enrolled in biometric authentication

## Troubleshooting

### Common Issues

1. **Biometric not available**
   - Check device capabilities
   - Verify permissions are properly set
   - Ensure biometric is enrolled on device

2. **Authentication fails**
   - Check if user has enrolled biometric data
   - Verify device settings
   - Check for hardware issues

3. **App crashes**
   - Check for missing permissions
   - Verify local_auth package version
   - Check platform-specific configurations

### Debug Information

Enable debug logging to troubleshoot issues:

```dart
// In BiometricService
print('Biometric availability: $isAvailable');
print('Available biometrics: $availableBiometrics');
print('Authentication result: $isAuthenticated');
```

## Future Enhancements

1. **Additional biometric types**: Support for iris scanning, voice recognition
2. **Multi-factor authentication**: Combine biometric with PIN/password
3. **Biometric encryption**: Encrypt sensitive data with biometric keys
4. **Advanced security**: Implement anti-spoofing measures
5. **Analytics**: Track biometric usage and success rates

## Support

For issues or questions regarding the biometric authentication implementation, please refer to:

- [local_auth package documentation](https://pub.dev/packages/local_auth)
- [Flutter biometric authentication guide](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple)
- [Platform-specific biometric documentation](https://developer.android.com/training/sign-in/biometric-auth) 
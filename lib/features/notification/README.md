# Notification Feature

This feature provides a comprehensive notification system for the mobile banking app.

## Features

- **Real-time Notifications**: Display notifications with different types (transaction, security, promotion, system)
- **Unread Count Badge**: Shows unread notification count in the navigation bar
- **Mark as Read**: Individual and bulk mark as read functionality
- **Swipe to Delete**: Swipe left to delete notifications
- **Pull to Refresh**: Refresh notifications list
- **Time Formatting**: Smart time display (just now, minutes ago, hours ago, etc.)
- **Notification Actions**: Handle different notification types with appropriate actions

## File Structure

```
lib/features/notification/
├── logic/
│   ├── notification_state.dart      # State management
│   ├── notification_notifier.dart   # Business logic
│   └── notification_provider.dart   # Riverpod providers
├── presentation/
│   └── notification_screen.dart     # UI implementation
└── README.md                        # This file
```

## Models

### NotificationModel
- `id`: Unique identifier
- `title`: Notification title
- `message`: Notification message
- `type`: Type of notification (transaction, security, promotion, system)
- `createdAt`: Timestamp
- `isRead`: Read status
- `actionUrl`: Optional action URL
- `metadata`: Additional data

## Usage

### Accessing Notifications
```dart
// Watch notification state
final notificationState = ref.watch(notificationNotifierProvider);

// Access notifications
final notifications = notificationState.notifications;
final unreadCount = notificationState.unreadCount;
```

### Navigation
```dart
// Navigate to notifications screen
context.goNamed('notifications');
```

### API Integration

To integrate with real API endpoints, update the following methods in `notification_notifier.dart`:

1. **Get Notifications**
```dart
// Replace mock data with API call
final response = await _apiService.client.get('notifications');
final notifications = (response.data as List)
    .map((json) => NotificationModel.fromJson(json))
    .toList();
```

2. **Mark as Read**
```dart
await _apiService.client.put('notifications/$notificationId/read');
```

3. **Mark All as Read**
```dart
await _apiService.client.put('notifications/mark-all-read');
```

4. **Delete Notification**
```dart
await _apiService.client.delete('notifications/$notificationId');
```

## UI Components

### Notification Tile
- Color-coded icons based on notification type
- Unread indicator (red dot)
- Swipe to delete functionality
- Tap to mark as read and handle action

### Navigation Badge
- Shows unread count on notification tab
- Displays "99+" for counts over 99
- Updates automatically when notifications change

## Notification Types

1. **Transaction** (Green)
   - Icon: `Icons.account_balance_wallet`
   - Action: Navigate to transactions screen

2. **Security** (Red)
   - Icon: `Icons.security`
   - Action: Show security alert

3. **Promotion** (Orange)
   - Icon: `Icons.local_offer`
   - Action: Navigate to services screen

4. **System** (Blue)
   - Icon: `Icons.system_update`
   - Action: Show system message

## Localization

All text is in Lao language:
- "ການແຈ້ງເຕືອນ" - Notifications
- "ກຳລັງໂຫຼດການແຈ້ງເຕືອນ..." - Loading notifications...
- "ບໍ່ມີການແຈ້ງເຕືອນ" - No notifications
- "ມາກທັງໝົດວ່າອ່ານແລ້ວ" - Mark all as read

## Future Enhancements

1. **Push Notifications**: Integrate with Firebase Cloud Messaging
2. **Notification Preferences**: Allow users to customize notification settings
3. **Rich Notifications**: Support for images and action buttons
4. **Notification History**: Pagination for large notification lists
5. **Offline Support**: Cache notifications for offline viewing 
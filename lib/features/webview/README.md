# WebView Feature

This feature provides a web view functionality for the mobile banking app, allowing users to view web content within the app.

## Features

- **Web Content Display**: Load and display web pages within the app
- **Navigation Controls**: Back, forward, refresh, and home buttons
- **Loading States**: Visual feedback during page loading
- **Error Handling**: User-friendly error messages and retry functionality
- **Responsive Design**: Adapts to different screen sizes

## Usage

### Navigation

To navigate to the web view screen, use the following code:

```dart
// Basic usage with URL only
context.pushNamed('webview', queryParameters: {
  'url': 'https://example.com',
});

// With custom title
context.pushNamed('webview', queryParameters: {
  'url': 'https://example.com',
  'title': 'ຊື່ໜ້າເວັບ',
});
```

### Example from Home Screen

The web view is currently used in the home screen to open the fund website:

```dart
GestureDetector(
  onTap: () {
    context.pushNamed(
      'webview',
      queryParameters: {'url': 'https://fund.nbb.com.la'},
    );
  },
  child: // ... widget content
),
```

## Route Configuration

The web view route is configured in `lib/app/routes/app_router.dart`:

```dart
GoRoute(
  path: '/webview',
  name: 'webview',
  builder: (context, state) {
    final url = state.uri.queryParameters['url'] ?? '';
    final title = state.uri.queryParameters['title'] ?? 'ເວັບໄຊທ໌';
    return WebViewScreen(url: url, title: title);
  },
),
```

## Dependencies

- `webview_flutter: ^4.7.0` - For web view functionality

## Security Considerations

- JavaScript is enabled for full web functionality
- Users can navigate to any URL passed to the web view
- Consider implementing URL validation if needed for security

## Customization

The web view screen can be customized by:

1. **Modifying the navigation toolbar** - Add or remove navigation buttons
2. **Changing the loading indicator** - Customize the loading animation
3. **Updating error handling** - Modify error messages and retry logic
4. **Adding additional features** - Such as bookmarking, sharing, etc.

## Files

- `lib/features/webview/presentation/webview_screen.dart` - Main web view screen
- `lib/features/webview/README.md` - This documentation file 
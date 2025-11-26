# Notification Detail Feature

This feature displays detailed information about a specific notification, typically showing transaction details with a clean, organized layout.

## Files

- `notification_detail_screen.dart` - Main screen for displaying notification details
- `README.md` - This documentation file

## Features

- **Date and Time Display**: Prominently shows the notification timestamp
- **Reference ID**: Displays the transaction reference number
- **Account Information**: Shows source and destination account details
- **Transaction Summary**: Displays amount, fees, and description
- **Visual Design**: Clean, card-based layout with proper spacing
- **Responsive Design**: Uses `flutter_screenutil` for responsive UI
- **Lao Language Support**: All text is in Lao language

## Screen Layout

### 1. Date and Time Section
- **Icon**: Clock icon in primary color
- **Content**: Date and time in large, bold text
- **Design**: Centered layout with card styling

### 2. Reference ID Section
- **Icon**: Receipt icon
- **Label**: "ເລກທີອ້າງອີງ" (Reference ID)
- **Value**: Reference number in monospace font
- **Design**: Highlighted background with border

### 3. Account Information Section
- **Title**: "ຂໍ້ມູນບັນຊີ" (Account Information)
- **Source Account**: 
  - Logo: BCEL (blue theme)
  - Label: "ຕົ້ນທາງ" (Source)
  - Account details with truncated name
- **Destination Account**:
  - Logo: RDB (green theme)
  - Label: "ປາຍທາງ" (Destination)
  - Full account details

### 4. Transaction Summary Section
- **Title**: "ສະຫຼຸບການເຄື່ອນໄຫວ" (Transaction Summary)
- **Amount**: "ຈໍານວນເງິນ" (Amount) - highlighted in green
- **Fee**: "ຄ່າທໍານຽມ" (Fee) - displayed in grey
- **Description**: "ລາຍລະອຽດ" (Description) - shows transaction purpose

## Design Elements

### Color Scheme
- **Primary Color**: Uses `AppColors.color1` for icons and highlights
- **Source Account**: Blue theme (blue.shade50, blue.shade200, blue.shade700)
- **Destination Account**: Green theme (green.shade50, green.shade200, green.shade700)
- **Text Colors**: Black87 for headings, grey shades for secondary text

### Typography
- **Headings**: 18sp, bold weight
- **Body Text**: 16sp, medium weight
- **Reference ID**: 18sp, bold, monospace font
- **Amount**: 18sp, bold, green color

### Layout
- **Card Design**: Rounded corners (16.r), subtle shadows, borders
- **Spacing**: Consistent 24.h spacing between sections
- **Padding**: 20.w internal padding for content
- **Responsive**: Uses `flutter_screenutil` for adaptive sizing

## Navigation

### Route
```dart
// Navigate to notification detail
context.pushNamed(
  RouteConstants.notificationDetail,
  pathParameters: {'id': notificationId},
);
```

### Route Definition
```dart
GoRoute(
  path: '/notification-detail/:id',
  name: RouteConstants.notificationDetail,
  builder: (context, state) {
    final notificationId = state.pathParameters['id'];
    return NotificationDetailScreen(notificationId: notificationId);
  },
),
```

## Customization

### Colors
- Modify `AppColors.color1` for primary color changes
- Adjust blue/green shades for account themes
- Customize text colors for different emphasis levels

### Layout
- Change spacing by modifying `SizedBox` heights
- Adjust card padding by changing padding values
- Modify border radius for different corner styles

### Content
- Update hardcoded text for different languages
- Modify account logos and names
- Change transaction details as needed

## Future Enhancements

- [ ] Dynamic data loading from API
- [ ] Real-time notification updates
- [ ] Interactive elements (copy reference ID, share details)
- [ ] Multiple notification types support
- [ ] Push notification integration
- [ ] Notification history
- [ ] Custom notification preferences 
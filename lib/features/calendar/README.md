# Calendar Feature

This directory contains the calendar feature implementation for the mobile banking app.

## Structure

```
calendar/
├── logic/
│   ├── calendar_event.dart      # Calendar event model
│   ├── calendar_state.dart      # Calendar state management
│   ├── calendar_notifier.dart   # Calendar state notifier
│   └── calendar_provider.dart   # Riverpod provider
└── presentation/
    └── calendar_screen.dart     # Calendar UI screen
```

## Features

### Calendar Screen
- **Monthly Calendar View**: Displays a full month calendar with Lao language day headers
- **Date Navigation**: Navigate between months using arrow buttons
- **Date Selection**: Tap on any date to select it
- **Today Highlighting**: Current date is highlighted with a border
- **Event Indicators**: Small dots show dates with events
- **Event Management**: Add, view, and delete events for selected dates

### Event Management
- **Add Events**: Create new events with title and description
- **View Events**: See all events for a selected date
- **Delete Events**: Remove events with a delete button
- **Event Persistence**: Events are stored in memory (can be extended to use local storage)

### UI Features
- **Modern Design**: Clean, modern UI with shadows and rounded corners
- **Responsive Layout**: Adapts to different screen sizes using ScreenUtil
- **Lao Language Support**: All text is in Lao language
- **Color Scheme**: Uses the app's color scheme (AppColors.color1)
- **Smooth Animations**: Page transitions and state changes

## Usage

### Navigation
The calendar can be accessed from the login screen by tapping the "calendar" button.

### Adding Events
1. Tap the "+" button in the app bar or the add button in the events section
2. Enter event title and description
3. Tap "ບັນທຶກ" (Save) to create the event

### Viewing Events
- Select any date to view events for that day
- Events are displayed in a scrollable list below the calendar

### Deleting Events
- Tap the delete icon (🗑️) next to any event to remove it

## Technical Details

### State Management
- Uses Riverpod for state management
- CalendarState holds the list of events and loading states
- CalendarNotifier provides methods to add, delete, and update events

### Dependencies
- `flutter_riverpod`: State management
- `flutter_screenutil`: Responsive design
- `intl`: Date formatting and localization
- `go_router`: Navigation

### Localization
- Date formatting uses Lao locale ('lo')
- All UI text is in Lao language
- Day headers: ອາ, ຈ, ອ, ພ, ພຫ, ສຸ, ອາ (Sunday to Saturday)

## Future Enhancements
- Persistent storage for events
- Event categories and colors
- Recurring events
- Event reminders and notifications
- Calendar export/import functionality
- Integration with device calendar 
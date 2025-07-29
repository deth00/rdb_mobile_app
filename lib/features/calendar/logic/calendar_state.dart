import 'package:moblie_banking/features/calendar/logic/calendar_event.dart';

class CalendarState {
  final List<CalendarEvent> events;
  final bool isLoading;
  final String? error;

  CalendarState({this.events = const [], this.isLoading = false, this.error});

  CalendarState copyWith({
    List<CalendarEvent>? events,
    bool? isLoading,
    String? error,
  }) {
    return CalendarState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

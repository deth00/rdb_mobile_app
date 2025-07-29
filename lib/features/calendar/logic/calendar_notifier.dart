import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/features/calendar/logic/calendar_event.dart';
import 'package:moblie_banking/features/calendar/logic/calendar_state.dart';

class CalendarNotifier extends StateNotifier<CalendarState> {
  CalendarNotifier() : super(CalendarState());

  void addEvent(CalendarEvent event) {
    final updatedEvents = List<CalendarEvent>.from(state.events)..add(event);
    state = state.copyWith(events: updatedEvents);
  }

  void deleteEvent(String eventId) {
    final updatedEvents = state.events
        .where((event) => event.id != eventId)
        .toList();
    state = state.copyWith(events: updatedEvents);
  }

  void updateEvent(CalendarEvent updatedEvent) {
    final updatedEvents = state.events.map((event) {
      if (event.id == updatedEvent.id) {
        return updatedEvent;
      }
      return event;
    }).toList();
    state = state.copyWith(events: updatedEvents);
  }

  void clearEvents() {
    state = state.copyWith(events: []);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }
}

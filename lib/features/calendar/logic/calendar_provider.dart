import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moblie_banking/features/calendar/logic/calendar_event.dart';
import 'package:moblie_banking/features/calendar/logic/calendar_notifier.dart';
import 'package:moblie_banking/features/calendar/logic/calendar_state.dart';

final calendarProvider = StateNotifierProvider<CalendarNotifier, CalendarState>(
  (ref) {
    return CalendarNotifier();
  },
);

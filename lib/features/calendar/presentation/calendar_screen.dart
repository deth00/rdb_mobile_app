import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';
import 'package:moblie_banking/core/utils/svg_icons.dart';
import 'package:moblie_banking/features/calendar/logic/calendar_event.dart';
import 'package:moblie_banking/features/calendar/logic/calendar_provider.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final calendarState = ref.watch(calendarProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.color1,
        elevation: 0,
        title: Text(
          'ປະຕິທິນ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _showAddEventDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with month/year and navigation
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            decoration: BoxDecoration(
              color: AppColors.color1,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _focusedDay = DateTime(
                        _focusedDay.year,
                        _focusedDay.month - 1,
                      );
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    });
                  },
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                ),
                Text(
                  _formatDate(_focusedDay, 'MMMM yyyy'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _focusedDay = DateTime(
                        _focusedDay.year,
                        _focusedDay.month + 1,
                      );
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    });
                  },
                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                ),
              ],
            ),
          ),

          // Calendar grid
          Expanded(
            child: Container(
              margin: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Day headers
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    decoration: BoxDecoration(
                      color: AppColors.color1.withOpacity(0.1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.r),
                        topRight: Radius.circular(15.r),
                      ),
                    ),
                    child: Row(
                      children: ['ອາ', 'ຈ', 'ອ', 'ພ', 'ພຫ', 'ສຸ', 'ອາ']
                          .map(
                            (day) => Expanded(
                              child: Center(
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.color1,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),

                  // Calendar days
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _focusedDay = DateTime(
                            _focusedDay.year,
                            _focusedDay.month + index,
                          );
                        });
                      },
                      itemBuilder: (context, index) {
                        final month = DateTime(
                          _focusedDay.year,
                          _focusedDay.month + index,
                        );
                        return _buildCalendarGrid(month);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Events section
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ກິດຈະກຳວັນທີ ${_formatDate(_selectedDay, 'd MMMM yyyy')}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.color1,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showAddEventDialog(context),
                      icon: Icon(Icons.add_circle, color: AppColors.color1),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                _buildEventsList(_selectedDay),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final firstWeekday = firstDay.weekday;
    final daysInMonth = lastDay.day;

    final calendarState = ref.watch(calendarProvider);

    return GridView.builder(
      padding: EdgeInsets.all(10.w),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: 42, // 6 weeks * 7 days
      itemBuilder: (context, index) {
        final dayOffset = index - (firstWeekday - 1);
        final day = dayOffset + 1;

        if (dayOffset < 0 || day > daysInMonth) {
          return Container();
        }

        final date = DateTime(month.year, month.month, day);
        final isSelected =
            _selectedDay.year == date.year &&
            _selectedDay.month == date.month &&
            _selectedDay.day == date.day;
        final isToday =
            DateTime.now().year == date.year &&
            DateTime.now().month == date.month &&
            DateTime.now().day == date.day;
        final hasEvents = calendarState.events.any(
          (event) =>
              event.date.year == date.year &&
              event.date.month == date.month &&
              event.date.day == date.day,
        );

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDay = date;
            });
          },
          child: Container(
            margin: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.color1
                  : isToday
                  ? AppColors.color1.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
              border: isToday
                  ? Border.all(color: AppColors.color1, width: 2)
                  : null,
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : isToday
                          ? AppColors.color1
                          : Colors.black87,
                      fontWeight: isSelected || isToday
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                if (hasEvents)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 6.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : AppColors.color1,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventsList(DateTime date) {
    final calendarState = ref.watch(calendarProvider);
    final dayEvents = calendarState.events
        .where(
          (event) =>
              event.date.year == date.year &&
              event.date.month == date.month &&
              event.date.day == date.day,
        )
        .toList();

    if (dayEvents.isEmpty) {
      return Container(
        height: 60.h,
        child: Center(
          child: Text(
            'ບໍ່ມີກິດຈະກຳໃນວັນນີ້',
            style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
          ),
        ),
      );
    }

    return Container(
      height: 120.h,
      child: ListView.builder(
        itemCount: dayEvents.length,
        itemBuilder: (context, index) {
          final event = dayEvents[index];
          return Container(
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.color1.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.color1.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 4.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: AppColors.color1,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        event.description,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _deleteEvent(event.id),
                  icon: Icon(Icons.delete, color: Colors.red, size: 20.sp),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'ເພີ່ມກິດຈະກຳ',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'ຫົວຂໍ້',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'ຄຳອະທິບາຍ',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ຍົກເລີກ'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                ref
                    .read(calendarProvider.notifier)
                    .addEvent(
                      CalendarEvent(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleController.text,
                        description: descriptionController.text,
                        date: _selectedDay,
                      ),
                    );
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.color1,
              foregroundColor: Colors.white,
            ),
            child: Text('ບັນທຶກ'),
          ),
        ],
      ),
    );
  }

  void _deleteEvent(String eventId) {
    ref.read(calendarProvider.notifier).deleteEvent(eventId);
  }

  String _formatDate(DateTime date, String pattern) {
    try {
      return DateFormat(pattern, 'lo').format(date);
    } catch (e) {
      // Fallback to default locale if Lao locale is not available
      return DateFormat(pattern).format(date);
    }
  }
}

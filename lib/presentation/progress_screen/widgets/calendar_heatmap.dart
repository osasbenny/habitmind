import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CalendarHeatmap extends StatefulWidget {
  final Map<DateTime, double> completionData;

  const CalendarHeatmap({
    super.key,
    required this.completionData,
  });

  @override
  State<CalendarHeatmap> createState() => _CalendarHeatmapState();
}

class _CalendarHeatmapState extends State<CalendarHeatmap> {
  late DateTime currentMonth;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
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
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'calendar_month',
                    color: AppTheme.primaryTeal,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Habit Calendar',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textHighEmphasisLight,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: _previousMonth,
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: AppTheme.softGray,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: 'chevron_left',
                        color: AppTheme.textMediumEmphasisLight,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  GestureDetector(
                    onTap: _nextMonth,
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: AppTheme.softGray,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: 'chevron_right',
                        color: AppTheme.textMediumEmphasisLight,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            _getMonthYearString(currentMonth),
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.textHighEmphasisLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          _buildWeekdayHeaders(),
          SizedBox(height: 1.h),
          _buildCalendarGrid(),
          SizedBox(height: 2.h),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders() {
    const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
      children: weekdays
          .map((day) => Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMediumEmphasisLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0);
    final firstDayWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    List<Widget> dayWidgets = [];

    // Add empty cells for days before the first day of the month
    for (int i = 0; i < firstDayWeekday; i++) {
      dayWidgets.add(const SizedBox());
    }

    // Add day cells
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(currentMonth.year, currentMonth.month, day);
      final completion = widget.completionData[_normalizeDate(date)] ?? 0.0;

      dayWidgets.add(
        GestureDetector(
          onLongPress: () => _showDayDetails(date, completion),
          child: Container(
            margin: EdgeInsets.all(0.5.w),
            decoration: BoxDecoration(
              color: _getCompletionColor(completion),
              borderRadius: BorderRadius.circular(8),
              border: _isToday(date)
                  ? Border.all(
                      color: AppTheme.primaryTeal,
                      width: 2,
                    )
                  : null,
            ),
            child: Center(
              child: Text(
                day.toString(),
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: completion > 0.5
                      ? AppTheme.pureWhite
                      : AppTheme.textHighEmphasisLight,
                  fontWeight:
                      _isToday(date) ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1,
      children: dayWidgets,
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Less',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textMediumEmphasisLight,
          ),
        ),
        SizedBox(width: 2.w),
        Row(
          children: [0.0, 0.25, 0.5, 0.75, 1.0]
              .map((intensity) => Container(
                    width: 3.w,
                    height: 3.w,
                    margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                    decoration: BoxDecoration(
                      color: _getCompletionColor(intensity),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ))
              .toList(),
        ),
        SizedBox(width: 2.w),
        Text(
          'More',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textMediumEmphasisLight,
          ),
        ),
      ],
    );
  }

  Color _getCompletionColor(double completion) {
    if (completion == 0) return AppTheme.softGray;
    if (completion <= 0.25) return AppTheme.lightTeal.withValues(alpha: 0.3);
    if (completion <= 0.5) return AppTheme.lightTeal.withValues(alpha: 0.6);
    if (completion <= 0.75) return AppTheme.primaryTeal.withValues(alpha: 0.8);
    return AppTheme.primaryTeal;
  }

  bool _isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _getMonthYearString(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  void _previousMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    });
  }

  void _showDayDetails(DateTime date, double completion) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              '${date.day}/${date.month}/${date.year}',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textHighEmphasisLight,
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Container(
                  width: 4.w,
                  height: 4.w,
                  decoration: BoxDecoration(
                    color: _getCompletionColor(completion),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  '${(completion * 100).toInt()}% habits completed',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              completion > 0.8
                  ? 'Excellent day! Keep up the momentum.'
                  : completion > 0.5
                      ? 'Good progress! You\'re on the right track.'
                      : completion > 0
                          ? 'Some progress is better than none.'
                          : 'No habits completed this day.',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textMediumEmphasisLight,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}

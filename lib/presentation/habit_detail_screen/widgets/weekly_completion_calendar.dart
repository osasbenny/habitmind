import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class WeeklyCompletionCalendar extends StatefulWidget {
  final List<Map<String, dynamic>> weeklyData;
  final Function(int dayIndex, bool isCompleted) onDayToggle;

  const WeeklyCompletionCalendar({
    super.key,
    required this.weeklyData,
    required this.onDayToggle,
  });

  @override
  State<WeeklyCompletionCalendar> createState() =>
      _WeeklyCompletionCalendarState();
}

class _WeeklyCompletionCalendarState extends State<WeeklyCompletionCalendar> {
  final List<String> _weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  void _handleDayTap(int dayIndex) {
    HapticFeedback.lightImpact();
    final currentStatus = widget.weeklyData[dayIndex]['completed'] as bool;
    widget.onDayToggle(dayIndex, !currentStatus);
  }

  Color _getDayColor(Map<String, dynamic> dayData) {
    final completed = dayData['completed'] as bool;
    final partial = dayData['partial'] as bool? ?? false;

    if (completed) {
      return AppTheme.primaryTeal;
    } else if (partial) {
      return AppTheme.lightTeal;
    } else {
      return AppTheme.borderLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.pureWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Week',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: 7,
            itemBuilder: (context, index) {
              final dayData = widget.weeklyData[index];
              return GestureDetector(
                onTap: () => _handleDayTap(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: _getDayColor(dayData),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getDayColor(dayData) == AppTheme.borderLight
                          ? AppTheme.borderLight
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _weekDays[index],
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: _getDayColor(dayData) == AppTheme.borderLight
                              ? AppTheme.mediumGray
                              : AppTheme.pureWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '${dayData['day']}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: _getDayColor(dayData) == AppTheme.borderLight
                              ? AppTheme.mediumGray
                              : AppTheme.pureWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem('Completed', AppTheme.primaryTeal),
              _buildLegendItem('Partial', AppTheme.lightTeal),
              _buildLegendItem('Missed', AppTheme.borderLight),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.mediumGray,
          ),
        ),
      ],
    );
  }
}

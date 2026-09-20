import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './frequency_selection_widget.dart';

class GoalDurationPickerWidget extends StatelessWidget {
  final HabitFrequency frequency;
  final int selectedDuration;
  final Function(int) onDurationChanged;

  const GoalDurationPickerWidget({
    Key? key,
    required this.frequency,
    required this.selectedDuration,
    required this.onDurationChanged,
  }) : super(key: key);

  List<int> get _durationOptions {
    return frequency == HabitFrequency.daily
        ? [7, 14, 30, 90] // days
        : [4, 8, 12, 24]; // weeks
  }

  String get _unitLabel {
    return frequency == HabitFrequency.daily ? 'days' : 'weeks';
  }

  String _getDurationLabel(int duration) {
    if (frequency == HabitFrequency.daily) {
      switch (duration) {
        case 7:
          return '1 Week';
        case 14:
          return '2 Weeks';
        case 30:
          return '1 Month';
        case 90:
          return '3 Months';
        default:
          return '$duration Days';
      }
    } else {
      switch (duration) {
        case 4:
          return '1 Month';
        case 8:
          return '2 Months';
        case 12:
          return '3 Months';
        case 24:
          return '6 Months';
        default:
          return '$duration Weeks';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Goal Duration',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 4.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: AppTheme.borderLight,
                  width: 1.0,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'flag',
                        color: AppTheme.primaryTeal,
                        size: 24,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        _getDurationLabel(selectedDuration),
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          color: AppTheme.primaryTeal,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _durationOptions.map((duration) {
                      final bool isSelected = selectedDuration == duration;
                      return GestureDetector(
                        onTap: () => onDurationChanged(duration),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.5.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryTeal
                                : AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryTeal
                                  : AppTheme.borderLight,
                              width: 2.0,
                            ),
                          ),
                          child: Text(
                            _getDurationLabel(duration),
                            style: AppTheme.lightTheme.textTheme.labelLarge
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.pureWhite
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryTeal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'info',
                          color: AppTheme.primaryTeal,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Track progress for $selectedDuration $_unitLabel',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.primaryTeal,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

enum HabitFrequency { daily, weekly }

class FrequencySelectionWidget extends StatelessWidget {
  final HabitFrequency selectedFrequency;
  final Function(HabitFrequency) onFrequencyChanged;

  const FrequencySelectionWidget({
    Key? key,
    required this.selectedFrequency,
    required this.onFrequencyChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequency',
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
              padding: EdgeInsets.all(1.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: AppTheme.borderLight,
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildFrequencyOption(
                      frequency: HabitFrequency.daily,
                      title: 'Daily',
                      subtitle: 'Every day',
                      icon: 'today',
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: _buildFrequencyOption(
                      frequency: HabitFrequency.weekly,
                      title: 'Weekly',
                      subtitle: 'Once a week',
                      icon: 'date_range',
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

  Widget _buildFrequencyOption({
    required HabitFrequency frequency,
    required String title,
    required String subtitle,
    required String icon,
  }) {
    final bool isSelected = selectedFrequency == frequency;

    return GestureDetector(
      onTap: () => onFrequencyChanged(frequency),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryTeal.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isSelected ? AppTheme.primaryTeal : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryTeal
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: isSelected
                    ? AppTheme.pureWhite
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: isSelected
                    ? AppTheme.primaryTeal
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              subtitle,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? AppTheme.primaryTeal
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

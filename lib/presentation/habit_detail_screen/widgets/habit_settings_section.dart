import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class HabitSettingsSection extends StatelessWidget {
  final String frequency;
  final int goalDuration;
  final Function() onEditFrequency;
  final Function() onEditGoalDuration;

  const HabitSettingsSection({
    super.key,
    required this.frequency,
    required this.goalDuration,
    required this.onEditFrequency,
    required this.onEditGoalDuration,
  });

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
            'Habit Settings',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          _buildSettingItem(
            'Frequency',
            frequency,
            CustomIconWidget(
              iconName: 'schedule',
              color: AppTheme.primaryTeal,
              size: 24,
            ),
            onEditFrequency,
          ),
          SizedBox(height: 2.h),
          _buildSettingItem(
            'Goal Duration',
            '$goalDuration days',
            CustomIconWidget(
              iconName: 'flag',
              color: AppTheme.warningAmber,
              size: 24,
            ),
            onEditGoalDuration,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    String title,
    String value,
    Widget icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.softGray,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.borderLight,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            icon,
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.mediumGray,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    value,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'edit',
              color: AppTheme.mediumGray,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StreakListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> streakData;

  const StreakListWidget({
    super.key,
    required this.streakData,
  });

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
            children: [
              CustomIconWidget(
                iconName: 'local_fire_department',
                color: AppTheme.warningAmber,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Current Streaks',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textHighEmphasisLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          streakData.isEmpty ? _buildEmptyState() : _buildStreakList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'local_fire_department',
            color: AppTheme.textDisabledLight,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No active streaks',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.textDisabledLight,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Complete habits consistently to build streaks',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textDisabledLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStreakList() {
    return Column(
      children: streakData.asMap().entries.map((entry) {
        final index = entry.key;
        final streak = entry.value;
        final isLast = index == streakData.length - 1;

        return Column(
          children: [
            _buildStreakItem(streak),
            if (!isLast) SizedBox(height: 2.h),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildStreakItem(Map<String, dynamic> streak) {
    final habitName = streak['habitName'] as String;
    final currentStreak = streak['currentStreak'] as int;
    final bestStreak = streak['bestStreak'] as int;
    final isActive = streak['isActive'] as bool? ?? true;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.primaryTeal.withValues(alpha: 0.05)
            : AppTheme.softGray,
        borderRadius: BorderRadius.circular(12),
        border: isActive
            ? Border.all(
                color: AppTheme.primaryTeal.withValues(alpha: 0.2),
                width: 1,
              )
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color:
                  isActive ? AppTheme.warningAmber : AppTheme.textDisabledLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: 'local_fire_department',
              color: AppTheme.pureWhite,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habitName,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textHighEmphasisLight,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Text(
                      'Current: ',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textMediumEmphasisLight,
                      ),
                    ),
                    Text(
                      '$currentStreak days',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: isActive
                            ? AppTheme.primaryTeal
                            : AppTheme.textMediumEmphasisLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      width: 1,
                      height: 12,
                      color: AppTheme.borderLight,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Best: ',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textMediumEmphasisLight,
                      ),
                    ),
                    Text(
                      '$bestStreak days',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.warningAmber,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (currentStreak >= bestStreak && currentStreak > 0)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.successGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'New Record!',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.pureWhite,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

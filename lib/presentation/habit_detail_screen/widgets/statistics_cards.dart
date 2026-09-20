import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class StatisticsCards extends StatelessWidget {
  final int totalCompletions;
  final int longestStreak;
  final int currentStreak;
  final double successRate;

  const StatisticsCards({
    super.key,
    required this.totalCompletions,
    required this.longestStreak,
    required this.currentStreak,
    required this.successRate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistics',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Completions',
                totalCompletions.toString(),
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.successGreen,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildStatCard(
                'Longest Streak',
                '$longestStreak days',
                CustomIconWidget(
                  iconName: 'local_fire_department',
                  color: AppTheme.warningAmber,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 3.w),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Current Streak',
                '$currentStreak days',
                CustomIconWidget(
                  iconName: 'trending_up',
                  color: AppTheme.primaryTeal,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildStatCard(
                'Success Rate',
                '${successRate.toInt()}%',
                CustomIconWidget(
                  iconName: 'analytics',
                  color: AppTheme.deepTeal,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Widget icon) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.mediumGray,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              icon,
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.darkGray,
            ),
          ),
        ],
      ),
    );
  }
}

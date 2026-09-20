import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressSummaryCard extends StatelessWidget {
  final double completionPercentage;
  final int currentStreak;
  final int longestStreak;
  final String aiInsight;

  const ProgressSummaryCard({
    super.key,
    required this.completionPercentage,
    required this.currentStreak,
    required this.longestStreak,
    required this.aiInsight,
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
                iconName: 'insights',
                color: AppTheme.primaryTeal,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Progress Summary',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textHighEmphasisLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Completion Rate',
                  '${completionPercentage.toStringAsFixed(1)}%',
                  'trending_up',
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildStatItem(
                  'Current Streak',
                  '$currentStreak days',
                  'local_fire_department',
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Best Streak',
                  '$longestStreak days',
                  'emoji_events',
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Container(),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryTeal.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'psychology',
                      color: AppTheme.primaryTeal,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'AI Insight',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryTeal,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  aiInsight,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String iconName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.primaryTeal,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Expanded(
              child: Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.textHighEmphasisLight,
          ),
        ),
      ],
    );
  }
}

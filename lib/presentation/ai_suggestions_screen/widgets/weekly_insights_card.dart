import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class WeeklyInsightsCard extends StatelessWidget {
  final String insightText;
  final bool isLoading;

  const WeeklyInsightsCard({
    Key? key,
    required this.insightText,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryTeal.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryTeal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'psychology',
                    color: AppTheme.primaryTeal,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Weekly Insights',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textHighEmphasisLight,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            isLoading
                ? _buildSkeletonLoader()
                : Text(
                    insightText,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textMediumEmphasisLight,
                      height: 1.5,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Column(
      children: [
        Container(
          height: 2.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme.mediumGray.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          height: 2.h,
          width: 80.w,
          decoration: BoxDecoration(
            color: AppTheme.mediumGray.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          height: 2.h,
          width: 60.w,
          decoration: BoxDecoration(
            color: AppTheme.mediumGray.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

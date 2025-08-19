import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class CompletionHistory extends StatelessWidget {
  final List<Map<String, dynamic>> historyData;
  final Function(int index) onEditEntry;
  final Function(int index) onDeleteEntry;

  const CompletionHistory({
    super.key,
    required this.historyData,
    required this.onEditEntry,
    required this.onDeleteEntry,
  });

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final hour = dateTime.hour > 12
        ? dateTime.hour - 12
        : dateTime.hour == 0
            ? 12
            : dateTime.hour;
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year} at $hour:${dateTime.minute.toString().padLeft(2, '0')} $period';
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
            'Completion History',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          historyData.isEmpty
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'history',
                        color: AppTheme.mediumGray,
                        size: 32,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'No completion history yet',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.mediumGray,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: historyData.length > 10 ? 10 : historyData.length,
                  separatorBuilder: (context, index) => SizedBox(height: 2.h),
                  itemBuilder: (context, index) {
                    final entry = historyData[index];
                    return Dismissible(
                      key: Key('history_${entry['id']}'),
                      background: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryTeal,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.centerLeft,
                        child: CustomIconWidget(
                          iconName: 'edit',
                          color: AppTheme.pureWhite,
                          size: 24,
                        ),
                      ),
                      secondaryBackground: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        decoration: BoxDecoration(
                          color: AppTheme.errorRed,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.centerRight,
                        child: CustomIconWidget(
                          iconName: 'delete',
                          color: AppTheme.pureWhite,
                          size: 24,
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          onEditEntry(index);
                          return false;
                        } else {
                          return await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    'Delete Entry',
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium,
                                  ),
                                  content: Text(
                                    'Are you sure you want to delete this completion entry?',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                            color: AppTheme.mediumGray),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text(
                                        'Delete',
                                        style:
                                            TextStyle(color: AppTheme.errorRed),
                                      ),
                                    ),
                                  ],
                                ),
                              ) ??
                              false;
                        }
                      },
                      onDismissed: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          onDeleteEntry(index);
                        }
                      },
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
                            Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: AppTheme.successGreen,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: CustomIconWidget(
                                iconName: 'check',
                                color: AppTheme.pureWhite,
                                size: 16,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Completed',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    _formatDateTime(
                                        entry['timestamp'] as DateTime),
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.mediumGray,
                                    ),
                                  ),
                                  if (entry['note'] != null &&
                                      (entry['note'] as String).isNotEmpty) ...[
                                    SizedBox(height: 0.5.h),
                                    Text(
                                      entry['note'] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.darkGray,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            CustomIconWidget(
                              iconName: 'more_vert',
                              color: AppTheme.mediumGray,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          if (historyData.length > 10) ...[
            SizedBox(height: 2.h),
            Center(
              child: TextButton(
                onPressed: () {
                  // Show all history in a new screen or bottom sheet
                },
                child: Text(
                  'View All History (${historyData.length})',
                  style: TextStyle(
                    color: AppTheme.primaryTeal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

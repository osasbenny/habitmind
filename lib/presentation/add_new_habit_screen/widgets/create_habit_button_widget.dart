import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CreateHabitButtonWidget extends StatelessWidget {
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback onPressed;

  const CreateHabitButtonWidget({
    Key? key,
    required this.isEnabled,
    required this.isLoading,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? AppTheme.primaryTeal
              : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.12),
          foregroundColor: AppTheme.pureWhite,
          disabledBackgroundColor: AppTheme
              .lightTheme.colorScheme.onSurfaceVariant
              .withValues(alpha: 0.12),
          disabledForegroundColor: AppTheme
              .lightTheme.colorScheme.onSurfaceVariant
              .withValues(alpha: 0.38),
          elevation: isEnabled ? 4.0 : 0.0,
          shadowColor: AppTheme.primaryTeal.withValues(alpha: 0.3),
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppTheme.pureWhite),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'add_circle',
                    color: isEnabled
                        ? AppTheme.pureWhite
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.38),
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Create Habit',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: isEnabled
                          ? AppTheme.pureWhite
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.38),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

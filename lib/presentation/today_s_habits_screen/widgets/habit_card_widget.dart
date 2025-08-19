import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HabitCardWidget extends StatefulWidget {
  final Map<String, dynamic> habit;
  final Function(String) onToggleComplete;
  final Function(String) onEdit;
  final Function(String) onDelete;
  final Function(String) onViewDetails;
  final Function(String) onSkipToday;

  const HabitCardWidget({
    Key? key,
    required this.habit,
    required this.onToggleComplete,
    required this.onEdit,
    required this.onDelete,
    required this.onViewDetails,
    required this.onSkipToday,
  }) : super(key: key);

  @override
  State<HabitCardWidget> createState() => _HabitCardWidgetState();
}

class _HabitCardWidgetState extends State<HabitCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            _buildContextMenuItem(
              icon: 'edit',
              title: 'Edit Habit',
              onTap: () {
                Navigator.pop(context);
                widget.onEdit(widget.habit['id'].toString());
              },
            ),
            _buildContextMenuItem(
              icon: 'visibility',
              title: 'View Details',
              onTap: () {
                Navigator.pop(context);
                widget.onViewDetails(widget.habit['id'].toString());
              },
            ),
            _buildContextMenuItem(
              icon: 'skip_next',
              title: 'Skip Today',
              onTap: () {
                Navigator.pop(context);
                widget.onSkipToday(widget.habit['id'].toString());
              },
            ),
            _buildContextMenuItem(
              icon: 'delete',
              title: 'Delete Habit',
              onTap: () {
                Navigator.pop(context);
                widget.onDelete(widget.habit['id'].toString());
              },
              isDestructive: true,
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isDestructive
                  ? AppTheme.errorRed
                  : AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            SizedBox(width: 4.w),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: isDestructive
                    ? AppTheme.errorRed
                    : AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = widget.habit['isCompleted'] ?? false;
    final int currentStreak = widget.habit['currentStreak'] ?? 0;
    final double progress = widget.habit['progress'] ?? 0.0;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onLongPress: () => _showContextMenu(context),
            onTapDown: (_) {
              setState(() => _isPressed = true);
              _animationController.forward();
            },
            onTapUp: (_) {
              setState(() => _isPressed = false);
              _animationController.reverse();
            },
            onTapCancel: () {
              setState(() => _isPressed = false);
              _animationController.reverse();
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppTheme.primaryTeal.withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isCompleted
                      ? AppTheme.primaryTeal
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                  width: isCompleted ? 2 : 1,
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
                child: Row(
                  children: [
                    // Completion Checkbox
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        widget.onToggleComplete(widget.habit['id'].toString());
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppTheme.primaryTeal
                              : Colors.transparent,
                          border: Border.all(
                            color: isCompleted
                                ? AppTheme.primaryTeal
                                : AppTheme.lightTheme.colorScheme.outline,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: isCompleted
                            ? CustomIconWidget(
                                iconName: 'check',
                                color: AppTheme.pureWhite,
                                size: 20,
                              )
                            : null,
                      ),
                    ),
                    SizedBox(width: 4.w),

                    // Habit Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.habit['name'] ?? 'Unnamed Habit',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: isCompleted
                                  ? AppTheme.lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.6)
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 1.h),

                          // Progress Bar
                          Container(
                            height: 0.8.h,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: progress.clamp(0.0, 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryTeal,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 1.h),

                          // Streak and Progress Info
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'local_fire_department',
                                color: currentStreak > 0
                                    ? AppTheme.warningAmber
                                    : AppTheme.lightTheme.colorScheme.outline,
                                size: 16,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                '$currentStreak day streak',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.primaryTeal,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // More Options Button
                    GestureDetector(
                      onTap: () => _showContextMenu(context),
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        child: CustomIconWidget(
                          iconName: 'more_vert',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

enum HabitCategory { health, productivity, learning, fitness, mindfulness }

class CategorySelectionWidget extends StatelessWidget {
  final HabitCategory selectedCategory;
  final Function(HabitCategory) onCategoryChanged;

  const CategorySelectionWidget({
    Key? key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  }) : super(key: key);

  List<Map<String, dynamic>> get _categories {
    return [
      {
        'category': HabitCategory.health,
        'title': 'Health',
        'icon': 'favorite',
        'color': const Color(0xFFE91E63),
      },
      {
        'category': HabitCategory.productivity,
        'title': 'Productivity',
        'icon': 'trending_up',
        'color': const Color(0xFF2196F3),
      },
      {
        'category': HabitCategory.learning,
        'title': 'Learning',
        'icon': 'school',
        'color': const Color(0xFF9C27B0),
      },
      {
        'category': HabitCategory.fitness,
        'title': 'Fitness',
        'icon': 'fitness_center',
        'color': const Color(0xFFFF9800),
      },
      {
        'category': HabitCategory.mindfulness,
        'title': 'Mindfulness',
        'icon': 'self_improvement',
        'color': const Color(0xFF4CAF50),
      },
    ];
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
            'Category',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            height: 12.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              itemCount: _categories.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final categoryData = _categories[index];
                final HabitCategory category = categoryData['category'];
                final bool isSelected = selectedCategory == category;

                return GestureDetector(
                  onTap: () => onCategoryChanged(category),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 20.w,
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryTeal.withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryTeal
                            : AppTheme.borderLight,
                        width: isSelected ? 2.0 : 1.0,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color:
                                    AppTheme.primaryTeal.withValues(alpha: 0.2),
                                blurRadius: 8.0,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: AppTheme.shadowLight,
                                blurRadius: 4.0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryTeal
                                : categoryData['color'].withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: CustomIconWidget(
                            iconName: categoryData['icon'],
                            color: isSelected
                                ? AppTheme.pureWhite
                                : categoryData['color'],
                            size: 20,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          categoryData['title'],
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? AppTheme.primaryTeal
                                : AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

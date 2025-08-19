import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_selection_widget.dart';
import './widgets/create_habit_button_widget.dart';
import './widgets/frequency_selection_widget.dart';
import './widgets/goal_duration_picker_widget.dart';
import './widgets/habit_name_input_widget.dart';

class AddNewHabitScreen extends StatefulWidget {
  const AddNewHabitScreen({Key? key}) : super(key: key);

  @override
  State<AddNewHabitScreen> createState() => _AddNewHabitScreenState();
}

class _AddNewHabitScreenState extends State<AddNewHabitScreen>
    with TickerProviderStateMixin {
  final TextEditingController _habitNameController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  HabitFrequency _selectedFrequency = HabitFrequency.daily;
  int _selectedDuration = 7;
  HabitCategory _selectedCategory = HabitCategory.health;

  String? _habitNameError;
  bool _isLoading = false;
  bool _isFormValid = false;

  // Mock habit data storage
  final List<Map<String, dynamic>> _mockHabits = [];

  @override
  void initState() {
    super.initState();
    _habitNameController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _habitNameController.removeListener(_validateForm);
    _habitNameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      final habitName = _habitNameController.text.trim();

      if (habitName.isEmpty) {
        _habitNameError = 'Habit name is required';
        _isFormValid = false;
      } else if (habitName.length > 50) {
        _habitNameError = 'Habit name must be 50 characters or less';
        _isFormValid = false;
      } else if (habitName.length < 3) {
        _habitNameError = 'Habit name must be at least 3 characters';
        _isFormValid = false;
      } else {
        _habitNameError = null;
        _isFormValid = true;
      }
    });
  }

  void _onFrequencyChanged(HabitFrequency frequency) {
    setState(() {
      _selectedFrequency = frequency;
      // Reset duration to first option when frequency changes
      _selectedDuration = frequency == HabitFrequency.daily ? 7 : 4;
    });
  }

  void _onDurationChanged(int duration) {
    setState(() {
      _selectedDuration = duration;
    });
  }

  void _onCategoryChanged(HabitCategory category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  String _getCategoryName(HabitCategory category) {
    switch (category) {
      case HabitCategory.health:
        return 'Health';
      case HabitCategory.productivity:
        return 'Productivity';
      case HabitCategory.learning:
        return 'Learning';
      case HabitCategory.fitness:
        return 'Fitness';
      case HabitCategory.mindfulness:
        return 'Mindfulness';
    }
  }

  Future<void> _createHabit() async {
    if (!_isFormValid || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call and local storage
    try {
      await Future.delayed(const Duration(milliseconds: 1500));

      final newHabit = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': _habitNameController.text.trim(),
        'frequency': _selectedFrequency.toString().split('.').last,
        'duration': _selectedDuration,
        'category': _getCategoryName(_selectedCategory),
        'createdAt': DateTime.now().toIso8601String(),
        'completedDates': <String>[],
        'streak': 0,
        'isCompleted': false,
      };

      _mockHabits.add(newHabit);

      // Show success toast
      Fluttertoast.showToast(
        msg: "Habit '${newHabit['name']}' created successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.successGreen,
        textColor: AppTheme.pureWhite,
        fontSize: 14.sp,
      );

      // Navigate back to Today's Habits screen
      if (mounted) {
        Navigator.pop(context, newHabit);
      }
    } catch (e) {
      // Show error toast
      Fluttertoast.showToast(
        msg: "Failed to create habit. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.errorRed,
        textColor: AppTheme.pureWhite,
        fontSize: 14.sp,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 4.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CustomIconWidget(
              iconName: Theme.of(context).platform == TargetPlatform.iOS
                  ? 'close'
                  : 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 20,
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(1.5.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryTeal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: CustomIconWidget(
                iconName: 'psychology',
                color: AppTheme.primaryTeal,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              'New Habit',
              style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
            ),
          ],
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: GestureDetector(
        onTap: _dismissKeyboard,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),

                      // Motivational Header
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primaryTeal.withValues(alpha: 0.1),
                              AppTheme.lightTeal.withValues(alpha: 0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: AppTheme.primaryTeal.withValues(alpha: 0.2),
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            CustomIconWidget(
                              iconName: 'emoji_events',
                              color: AppTheme.primaryTeal,
                              size: 32,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Build Your New Habit',
                              style: AppTheme.lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                color: AppTheme.primaryTeal,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              'Small consistent actions lead to remarkable transformations',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // Habit Name Input
                      HabitNameInputWidget(
                        controller: _habitNameController,
                        onChanged: (value) => _validateForm(),
                        errorText: _habitNameError,
                      ),

                      SizedBox(height: 2.h),

                      // Category Selection
                      CategorySelectionWidget(
                        selectedCategory: _selectedCategory,
                        onCategoryChanged: _onCategoryChanged,
                      ),

                      SizedBox(height: 2.h),

                      // Frequency Selection
                      FrequencySelectionWidget(
                        selectedFrequency: _selectedFrequency,
                        onFrequencyChanged: _onFrequencyChanged,
                      ),

                      SizedBox(height: 2.h),

                      // Goal Duration Picker
                      GoalDurationPickerWidget(
                        frequency: _selectedFrequency,
                        selectedDuration: _selectedDuration,
                        onDurationChanged: _onDurationChanged,
                      ),

                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),

              // Create Habit Button (Fixed at bottom)
              Container(
                padding: EdgeInsets.only(
                  bottom:
                      MediaQuery.of(context).viewInsets.bottom > 0 ? 1.h : 2.h,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowLight,
                      blurRadius: 8.0,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: CreateHabitButtonWidget(
                  isEnabled: _isFormValid,
                  isLoading: _isLoading,
                  onPressed: _createHabit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

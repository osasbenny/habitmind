import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/completion_history.dart';
import './widgets/habit_progress_circle.dart';
import './widgets/habit_settings_section.dart';
import './widgets/notes_section.dart';
import './widgets/statistics_cards.dart';
import './widgets/weekly_completion_calendar.dart';

class HabitDetailScreen extends StatefulWidget {
  const HabitDetailScreen({super.key});

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  // Mock habit data
  final Map<String, dynamic> habitData = {
    "id": 1,
    "name": "Morning Meditation",
    "description":
        "10 minutes of mindfulness meditation to start the day with clarity and focus",
    "frequency": "Daily",
    "goalDuration": 30,
    "currentStreak": 12,
    "longestStreak": 18,
    "totalCompletions": 45,
    "completionPercentage": 78.5,
    "successRate": 85.2,
    "isCompletedToday": false,
    "createdDate": DateTime.now().subtract(const Duration(days: 60)),
  };

  List<Map<String, dynamic>> weeklyData = [
    {"day": 12, "completed": true, "partial": false},
    {"day": 13, "completed": true, "partial": false},
    {"day": 14, "completed": false, "partial": true},
    {"day": 15, "completed": true, "partial": false},
    {"day": 16, "completed": false, "partial": false},
    {"day": 17, "completed": true, "partial": false},
    {"day": 18, "completed": false, "partial": false},
  ];

  List<Map<String, dynamic>> notes = [
    {
      "id": 1,
      "content":
          "Felt really centered after today's session. The breathing exercises helped me stay focused during the morning meeting.",
      "date": DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      "id": 2,
      "content":
          "Struggled to concentrate today, but pushed through the full 10 minutes. Progress over perfection!",
      "date": DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      "id": 3,
      "content":
          "Amazing session today! Used the body scan technique and felt completely relaxed afterwards.",
      "date": DateTime.now().subtract(const Duration(days: 5)),
    },
  ];

  List<Map<String, dynamic>> completionHistory = [
    {
      "id": 1,
      "timestamp": DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      "note": "Great morning session with guided meditation",
    },
    {
      "id": 2,
      "timestamp": DateTime.now().subtract(const Duration(days: 2, hours: 1)),
      "note": null,
    },
    {
      "id": 3,
      "timestamp": DateTime.now().subtract(const Duration(days: 4, hours: 3)),
      "note": "Used breathing app - very helpful",
    },
    {
      "id": 4,
      "timestamp": DateTime.now().subtract(const Duration(days: 5, hours: 1)),
      "note": null,
    },
    {
      "id": 5,
      "timestamp": DateTime.now().subtract(const Duration(days: 6, hours: 2)),
      "note": "Meditation in the garden - so peaceful",
    },
  ];

  void _handleDayToggle(int dayIndex, bool isCompleted) {
    setState(() {
      weeklyData[dayIndex]['completed'] = isCompleted;
      weeklyData[dayIndex]['partial'] = false;
    });

    // Update statistics based on the change
    if (isCompleted) {
      setState(() {
        habitData['totalCompletions'] =
            (habitData['totalCompletions'] as int) + 1;
        habitData['completionPercentage'] =
            ((habitData['totalCompletions'] as int) / 60 * 100)
                .clamp(0.0, 100.0);
      });
    } else {
      setState(() {
        habitData['totalCompletions'] =
            ((habitData['totalCompletions'] as int) - 1)
                .clamp(0, double.infinity)
                .toInt();
        habitData['completionPercentage'] =
            ((habitData['totalCompletions'] as int) / 60 * 100)
                .clamp(0.0, 100.0);
      });
    }
  }

  void _addNote(String noteContent) {
    setState(() {
      notes.insert(0, {
        "id": notes.length + 1,
        "content": noteContent,
        "date": DateTime.now(),
      });
    });
  }

  void _editHistoryEntry(int index) {
    // Show edit dialog or bottom sheet
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit Entry',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          'Edit functionality would be implemented here',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(color: AppTheme.primaryTeal),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteHistoryEntry(int index) {
    setState(() {
      completionHistory.removeAt(index);
      habitData['totalCompletions'] =
          ((habitData['totalCompletions'] as int) - 1)
              .clamp(0, double.infinity)
              .toInt();
      habitData['completionPercentage'] =
          ((habitData['totalCompletions'] as int) / 60 * 100).clamp(0.0, 100.0);
    });
  }

  void _editFrequency() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Frequency',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              title: const Text('Daily'),
              trailing: habitData['frequency'] == 'Daily'
                  ? CustomIconWidget(
                      iconName: 'check',
                      color: AppTheme.primaryTeal,
                      size: 24,
                    )
                  : null,
              onTap: () {
                setState(() {
                  habitData['frequency'] = 'Daily';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Weekly'),
              trailing: habitData['frequency'] == 'Weekly'
                  ? CustomIconWidget(
                      iconName: 'check',
                      color: AppTheme.primaryTeal,
                      size: 24,
                    )
                  : null,
              onTap: () {
                setState(() {
                  habitData['frequency'] = 'Weekly';
                });
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _editGoalDuration() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Goal Duration',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            ...['21 days', '30 days', '60 days', '90 days'].map((duration) {
              final days = int.parse(duration.split(' ')[0]);
              return ListTile(
                title: Text(duration),
                trailing: habitData['goalDuration'] == days
                    ? CustomIconWidget(
                        iconName: 'check',
                        color: AppTheme.primaryTeal,
                        size: 24,
                      )
                    : null,
                onTap: () {
                  setState(() {
                    habitData['goalDuration'] = days;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _markCompleteToday() {
    HapticFeedback.mediumImpact();
    setState(() {
      habitData['isCompletedToday'] = true;
      habitData['currentStreak'] = (habitData['currentStreak'] as int) + 1;
      habitData['totalCompletions'] =
          (habitData['totalCompletions'] as int) + 1;
      habitData['completionPercentage'] =
          ((habitData['totalCompletions'] as int) / 60 * 100).clamp(0.0, 100.0);

      // Add to completion history
      completionHistory.insert(0, {
        "id": completionHistory.length + 1,
        "timestamp": DateTime.now(),
        "note": null,
      });
    });
  }

  void _shareProgress() {
    // Implement share functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Share Progress',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          'Share functionality would be implemented here',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(color: AppTheme.primaryTeal),
            ),
          ),
        ],
      ),
    );
  }

  void _editHabit() {
    Navigator.pushNamed(context, '/add-new-habit-screen');
  }

  void _deleteHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Habit',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          'Are you sure you want to delete "${habitData['name']}"? This action cannot be undone.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.mediumGray),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppTheme.errorRed),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.softGray,
      appBar: AppBar(
        backgroundColor: AppTheme.pureWhite,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.darkGray,
            size: 24,
          ),
        ),
        title: Text(
          habitData['name'] as String,
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _editHabit,
            icon: CustomIconWidget(
              iconName: 'edit',
              color: AppTheme.primaryTeal,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: _deleteHabit,
            icon: CustomIconWidget(
              iconName: 'delete',
              color: AppTheme.errorRed,
              size: 24,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            // Progress Circle
            HabitProgressCircle(
              completionPercentage: habitData['completionPercentage'] as double,
              currentStreak: habitData['currentStreak'] as int,
              habitName: habitData['name'] as String,
            ),
            SizedBox(height: 4.h),

            // Weekly Calendar
            WeeklyCompletionCalendar(
              weeklyData: weeklyData,
              onDayToggle: _handleDayToggle,
            ),
            SizedBox(height: 4.h),

            // Statistics Cards
            StatisticsCards(
              totalCompletions: habitData['totalCompletions'] as int,
              longestStreak: habitData['longestStreak'] as int,
              currentStreak: habitData['currentStreak'] as int,
              successRate: habitData['successRate'] as double,
            ),
            SizedBox(height: 4.h),

            // Habit Settings
            HabitSettingsSection(
              frequency: habitData['frequency'] as String,
              goalDuration: habitData['goalDuration'] as int,
              onEditFrequency: _editFrequency,
              onEditGoalDuration: _editGoalDuration,
            ),
            SizedBox(height: 4.h),

            // Notes Section
            NotesSection(
              notes: notes,
              onAddNote: _addNote,
            ),
            SizedBox(height: 4.h),

            // Completion History
            CompletionHistory(
              historyData: completionHistory,
              onEditEntry: _editHistoryEntry,
              onDeleteEntry: _deleteHistoryEntry,
            ),
            SizedBox(height: 6.h),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              if (!(habitData['isCompletedToday'] as bool)) ...[
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _markCompleteToday,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryTeal,
                      foregroundColor: AppTheme.pureWhite,
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.pureWhite,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Mark Complete Today',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.pureWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
              ],
              Expanded(
                child: OutlinedButton(
                  onPressed: _shareProgress,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryTeal,
                    side: BorderSide(color: AppTheme.primaryTeal, width: 1.5),
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'share',
                        color: AppTheme.primaryTeal,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Share',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primaryTeal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

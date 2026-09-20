import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/ai_habit_service.dart';
import './widgets/habit_stacking_card.dart';
import './widgets/motivational_tips_card.dart';
import './widgets/smart_scheduling_card.dart';
import './widgets/weekly_insights_card.dart';

class AiSuggestionsScreen extends StatefulWidget {
  const AiSuggestionsScreen({Key? key}) : super(key: key);

  @override
  State<AiSuggestionsScreen> createState() => _AiSuggestionsScreenState();
}

class _AiSuggestionsScreenState extends State<AiSuggestionsScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _isOfflineMode = false;
  late TabController _tabController;
  late AIHabitService _aiService;

  // AI-generated data from OpenAI
  Map<String, dynamic> _aiInsights = {};
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 2);
    _aiService = AIHabitService();
    _loadAiSuggestions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAiSuggestions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simulate user habit data - in real app, this would come from your database
      final userHabitData = {
        'totalHabits': 5,
        'activeStreak': 12,
        'completionRate': 0.75,
        'preferredTimes': ['7:00 AM', '8:30 PM'],
        'mostSuccessfulHabit': 'Morning Reading',
      };

      final completionHistory = [
        {
          'habit': 'Morning Reading',
          'completed': true,
          'time': '7:30 AM',
          'date': '2025-08-19'
        },
        {
          'habit': 'Workout',
          'completed': true,
          'time': '8:00 AM',
          'date': '2025-08-19'
        },
        {
          'habit': 'Meditation',
          'completed': false,
          'time': '9:00 PM',
          'date': '2025-08-18'
        },
      ];

      final recentProgress = [
        {'habit': 'Reading', 'streak': 12, 'completionRate': 0.9},
        {'habit': 'Workout', 'streak': 8, 'completionRate': 0.85},
      ];

      // Generate AI insights using OpenAI
      final weeklyInsight = await _aiService.generateWeeklyInsights(
        userHabitData: userHabitData,
        completionHistory: completionHistory,
      );

      final smartScheduling = await _aiService.generateSmartScheduling(
        habitName: 'Workout',
        userHabitData: userHabitData,
        completionHistory: completionHistory,
      );

      final habitStacking = await _aiService.generateHabitStacking(
        existingHabits: ['Morning Coffee', 'Brushing Teeth', 'Reading'],
        targetHabit: '5-Minute Meditation',
        userHabitData: userHabitData,
      );

      final motivationalTips = await _aiService.generateMotivationalTips(
        userHabitData: userHabitData,
        recentProgress: recentProgress,
      );

      setState(() {
        _aiInsights = {
          "weeklyInsight": weeklyInsight,
          "smartScheduling": smartScheduling,
          "habitStacking": habitStacking,
          "motivationalTips": motivationalTips,
        };
        _isOfflineMode = false;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage =
            'Failed to load AI suggestions. Please check your internet connection and API key.';
        _isOfflineMode = true;
        _isLoading = false;
        // Fallback to basic structure for error case
        _aiInsights = {
          "weeklyInsight":
              "Unable to generate insights. Please try again later.",
          "smartScheduling": {
            "text": "Scheduling suggestions unavailable.",
            "recommendedTime": "N/A",
            "reasoning": "Please check your connection and try again.",
          },
          "habitStacking": [],
          "motivationalTips": [
            "Keep working on your habits! Consistency is key."
          ],
        };
      });
    }
  }

  Future<void> _refreshSuggestions() async {
    await _loadAiSuggestions();
  }

  void _showApplyScheduleDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Apply Schedule Changes?',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.textHighEmphasisLight,
            ),
          ),
          content: Text(
            'This will update your workout schedule to ${_aiInsights['smartScheduling']?['recommendedTime'] ?? 'recommended time'} based on AI analysis. You can always change it later.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Schedule updated successfully!'),
                    backgroundColor: AppTheme.successGreen,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryTeal,
              ),
              child: Text(
                'Apply',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.pureWhite,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showApplyStackingDialog(Map<String, dynamic> suggestion) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Apply Habit Stacking?',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.textHighEmphasisLight,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This will create a new habit:',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTeal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${suggestion['newHabit']} → after → ${suggestion['existingHabit']}',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.primaryTeal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.of(context).pop();
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Habit stacking applied successfully!'),
                    backgroundColor: AppTheme.successGreen,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryTeal,
              ),
              child: Text(
                'Apply',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.pureWhite,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSettingsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.mediumGray.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'AI Suggestions Settings',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.textHighEmphasisLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              _buildSettingsItem(
                'Suggestion Frequency',
                'Daily',
                'schedule',
              ),
              _buildSettingsItem(
                'Insight Types',
                'All enabled',
                'psychology',
              ),
              _buildSettingsItem(
                'Notification Timing',
                '9:00 AM',
                'notifications',
              ),
              _buildSettingsItem(
                'OpenAI Model',
                'GPT-4o-mini',
                'psychology',
              ),
              SizedBox(height: 4.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsItem(String title, String value, String iconName) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryTeal.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.primaryTeal,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.textHighEmphasisLight,
                  ),
                ),
                Text(
                  value,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
                  ),
                ),
              ],
            ),
          ),
          CustomIconWidget(
            iconName: 'chevron_right',
            color: AppTheme.textMediumEmphasisLight,
            size: 20,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentInsight = _aiInsights.isNotEmpty ? _aiInsights : {};

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'AI Suggestions',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textHighEmphasisLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_isOfflineMode)
            Container(
              margin: EdgeInsets.only(right: 2.w),
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.warningAmber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'wifi_off',
                    color: AppTheme.warningAmber,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'API Error',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.warningAmber,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          IconButton(
            onPressed: _showSettingsBottomSheet,
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.textMediumEmphasisLight,
              size: 24,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: CustomIconWidget(
                iconName: 'today',
                color: _tabController.index == 0
                    ? AppTheme.primaryTeal
                    : AppTheme.textMediumEmphasisLight,
                size: 20,
              ),
              text: 'Today',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'add_circle_outline',
                color: _tabController.index == 1
                    ? AppTheme.primaryTeal
                    : AppTheme.textMediumEmphasisLight,
                size: 20,
              ),
              text: 'Add',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'psychology',
                color: _tabController.index == 2
                    ? AppTheme.primaryTeal
                    : AppTheme.textMediumEmphasisLight,
                size: 20,
              ),
              text: 'AI Tips',
            ),
            Tab(
              icon: CustomIconWidget(
                iconName: 'trending_up',
                color: _tabController.index == 3
                    ? AppTheme.primaryTeal
                    : AppTheme.textMediumEmphasisLight,
                size: 20,
              ),
              text: 'Progress',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Today's Habits Tab
          Center(
            child: Text(
              'Today\'s Habits Screen',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
          ),
          // Add New Habit Tab
          Center(
            child: Text(
              'Add New Habit Screen',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
          ),
          // AI Suggestions Tab (Active)
          RefreshIndicator(
            onRefresh: _refreshSuggestions,
            color: AppTheme.primaryTeal,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_errorMessage != null) ...[
                    Container(
                      margin: EdgeInsets.all(4.w),
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.warningAmber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color:
                                AppTheme.warningAmber.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'warning',
                            color: AppTheme.warningAmber,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.warningAmber,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: 2.h),

                  // Weekly Insights Card
                  WeeklyInsightsCard(
                    insightText: currentInsight['weeklyInsight'] as String? ??
                        'Loading insights...',
                    isLoading: _isLoading,
                  ),

                  // Smart Scheduling Card
                  SmartSchedulingCard(
                    schedulingText:
                        currentInsight['smartScheduling']?['text'] as String? ??
                            'Loading scheduling data...',
                    recommendedTime: currentInsight['smartScheduling']
                            ?['recommendedTime'] as String? ??
                        'TBD',
                    reasoning: currentInsight['smartScheduling']?['reasoning']
                            as String? ??
                        'Analyzing your patterns...',
                    isLoading: _isLoading,
                    onApply: _showApplyScheduleDialog,
                  ),

                  // Habit Stacking Card
                  HabitStackingCard(
                    stackingSuggestions:
                        (currentInsight['habitStacking'] as List?)
                                ?.cast<Map<String, dynamic>>() ??
                            [],
                    isLoading: _isLoading,
                    onApply: _showApplyStackingDialog,
                  ),

                  // Motivational Tips Card
                  MotivationalTipsCard(
                    tips: (currentInsight['motivationalTips'] as List?)
                            ?.cast<String>() ??
                        ['Loading motivational tips...'],
                    isLoading: _isLoading,
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          // Progress Tab
          Center(
            child: Text(
              'Progress Screen',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
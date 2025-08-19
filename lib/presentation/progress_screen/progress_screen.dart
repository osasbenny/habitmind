import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/calendar_heatmap.dart';
import './widgets/circular_progress_widget.dart';
import './widgets/completion_chart.dart';
import './widgets/progress_summary_card.dart';
import './widgets/streak_list_widget.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String selectedTimeFrame = 'Weekly';
  bool isLoading = false;

  // Mock data for progress tracking
  final List<Map<String, dynamic>> weeklyChartData = [
    {'label': 'Mon', 'percentage': 85.0},
    {'label': 'Tue', 'percentage': 92.0},
    {'label': 'Wed', 'percentage': 78.0},
    {'label': 'Thu', 'percentage': 95.0},
    {'label': 'Fri', 'percentage': 88.0},
    {'label': 'Sat', 'percentage': 76.0},
    {'label': 'Sun', 'percentage': 82.0},
  ];

  final List<Map<String, dynamic>> monthlyChartData = [
    {'label': 'Week 1', 'percentage': 87.0},
    {'label': 'Week 2', 'percentage': 91.0},
    {'label': 'Week 3', 'percentage': 83.0},
    {'label': 'Week 4', 'percentage': 89.0},
  ];

  final List<Map<String, dynamic>> allTimeChartData = [
    {'label': 'Jan', 'percentage': 75.0},
    {'label': 'Feb', 'percentage': 82.0},
    {'label': 'Mar', 'percentage': 88.0},
    {'label': 'Apr', 'percentage': 91.0},
    {'label': 'May', 'percentage': 85.0},
    {'label': 'Jun', 'percentage': 93.0},
  ];

  final List<Map<String, dynamic>> streakData = [
    {
      'habitName': 'Morning Exercise',
      'currentStreak': 15,
      'bestStreak': 23,
      'isActive': true,
    },
    {
      'habitName': 'Read for 30 minutes',
      'currentStreak': 8,
      'bestStreak': 12,
      'isActive': true,
    },
    {
      'habitName': 'Drink 8 glasses of water',
      'currentStreak': 12,
      'bestStreak': 18,
      'isActive': true,
    },
    {
      'habitName': 'Meditation',
      'currentStreak': 5,
      'bestStreak': 9,
      'isActive': false,
    },
  ];

  final Map<DateTime, double> calendarData = {
    DateTime(2024, 8, 1): 0.8,
    DateTime(2024, 8, 2): 1.0,
    DateTime(2024, 8, 3): 0.6,
    DateTime(2024, 8, 4): 0.9,
    DateTime(2024, 8, 5): 0.7,
    DateTime(2024, 8, 6): 0.4,
    DateTime(2024, 8, 7): 0.8,
    DateTime(2024, 8, 8): 1.0,
    DateTime(2024, 8, 9): 0.9,
    DateTime(2024, 8, 10): 0.5,
    DateTime(2024, 8, 11): 0.8,
    DateTime(2024, 8, 12): 0.7,
    DateTime(2024, 8, 13): 1.0,
    DateTime(2024, 8, 14): 0.6,
    DateTime(2024, 8, 15): 0.9,
    DateTime(2024, 8, 16): 0.8,
    DateTime(2024, 8, 17): 0.4,
    DateTime(2024, 8, 18): 0.7,
    DateTime(2024, 8, 19): 0.9,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        selectedTimeFrame = _getTimeFrameFromIndex(_tabController.index);
      });
    }
  }

  String _getTimeFrameFromIndex(int index) {
    switch (index) {
      case 0:
        return 'Weekly';
      case 1:
        return 'Monthly';
      case 2:
        return 'All Time';
      default:
        return 'Weekly';
    }
  }

  List<Map<String, dynamic>> _getCurrentChartData() {
    switch (selectedTimeFrame) {
      case 'Weekly':
        return weeklyChartData;
      case 'Monthly':
        return monthlyChartData;
      case 'All Time':
        return allTimeChartData;
      default:
        return weeklyChartData;
    }
  }

  double _getOverallCompletionRate() {
    final data = _getCurrentChartData();
    if (data.isEmpty) return 0.0;
    final total = data.fold<double>(
        0.0, (sum, item) => sum + (item['percentage'] as double));
    return total / data.length;
  }

  int _getCurrentStreak() {
    final activeStreaks =
        streakData.where((streak) => streak['isActive'] as bool).toList();
    if (activeStreaks.isEmpty) return 0;
    return activeStreaks.fold<int>(
        0,
        (max, streak) => (streak['currentStreak'] as int) > max
            ? (streak['currentStreak'] as int)
            : max);
  }

  int _getLongestStreak() {
    if (streakData.isEmpty) return 0;
    return streakData.fold<int>(
        0,
        (max, streak) => (streak['bestStreak'] as int) > max
            ? (streak['bestStreak'] as int)
            : max);
  }

  String _getAIInsight() {
    final completionRate = _getOverallCompletionRate();
    final currentStreak = _getCurrentStreak();

    if (completionRate >= 90) {
      return "Outstanding consistency! You're maintaining excellent habits. Your ${currentStreak}-day streak shows remarkable dedication. Consider adding a new challenging habit to continue growing.";
    } else if (completionRate >= 75) {
      return "Great progress! You're building strong habits with ${completionRate.toStringAsFixed(1)}% completion rate. Focus on consistency during weekends to boost your overall performance.";
    } else if (completionRate >= 50) {
      return "You're making steady progress. Your current ${currentStreak}-day streak is encouraging. Try setting specific times for your habits to improve consistency and reach your goals faster.";
    } else {
      return "Every journey starts with small steps. Focus on completing just one habit consistently for the next week. Small wins build momentum for bigger achievements ahead.";
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  void _shareProgress() {
    // Simulate sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Progress shared successfully!',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.pureWhite,
          ),
        ),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Progress',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: _shareProgress,
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.textHighEmphasisLight,
              size: 24,
            ),
          ),
          SizedBox(width: 2.w),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
            Tab(text: 'All Time'),
          ],
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: AppTheme.primaryTeal,
          child: isLoading ? _buildLoadingState() : _buildContent(),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.primaryTeal,
          ),
          SizedBox(height: 2.h),
          Text(
            'Updating progress...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final hasData = _getCurrentChartData().isNotEmpty || streakData.isNotEmpty;

    if (!hasData) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 2.h),

          // Overall completion rate
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: CircularProgressWidget(
              percentage: _getOverallCompletionRate(),
              title: 'Overall Progress',
              subtitle: selectedTimeFrame.toLowerCase(),
            ),
          ),

          SizedBox(height: 2.h),

          // Progress summary with AI insights
          ProgressSummaryCard(
            completionPercentage: _getOverallCompletionRate(),
            currentStreak: _getCurrentStreak(),
            longestStreak: _getLongestStreak(),
            aiInsight: _getAIInsight(),
          ),

          // Completion chart
          CompletionChart(
            chartData: _getCurrentChartData(),
            timeFrame: selectedTimeFrame,
          ),

          // Current streaks
          StreakListWidget(
            streakData: streakData,
          ),

          // Calendar heatmap
          CalendarHeatmap(
            completionData: calendarData,
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'trending_up',
              color: AppTheme.textDisabledLight,
              size: 80,
            ),
            SizedBox(height: 4.h),
            Text(
              'No Progress Data Yet',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.textDisabledLight,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Start tracking your habits to see beautiful progress visualizations and AI-powered insights about your journey.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textMediumEmphasisLight,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/today-s-habits-screen');
              },
              child: Text('Start Tracking Habits'),
            ),
            SizedBox(height: 2.h),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add-new-habit-screen');
              },
              child: Text('Add Your First Habit'),
            ),
          ],
        ),
      ),
    );
  }
}

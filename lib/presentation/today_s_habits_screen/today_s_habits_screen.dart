import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/bottom_navigation_widget.dart';
import './widgets/date_header_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/habit_card_widget.dart';
import './widgets/motivational_quote_widget.dart';

class TodaySHabitsScreen extends StatefulWidget {
  const TodaySHabitsScreen({Key? key}) : super(key: key);

  @override
  State<TodaySHabitsScreen> createState() => _TodaySHabitsScreenState();
}

class _TodaySHabitsScreenState extends State<TodaySHabitsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  bool _isQuoteLoading = false;
  int _currentBottomNavIndex = 0;

  // Mock data for habits
  final List<Map<String, dynamic>> _todaysHabits = [
    {
      "id": 1,
      "name": "Morning Meditation",
      "isCompleted": false,
      "currentStreak": 7,
      "progress": 0.7,
      "frequency": "daily",
      "goalDuration": 30,
      "createdAt": DateTime.now().subtract(const Duration(days: 7)),
    },
    {
      "id": 2,
      "name": "Drink 8 Glasses of Water",
      "isCompleted": true,
      "currentStreak": 12,
      "progress": 1.0,
      "frequency": "daily",
      "goalDuration": 21,
      "createdAt": DateTime.now().subtract(const Duration(days: 12)),
    },
    {
      "id": 3,
      "name": "Read for 30 Minutes",
      "isCompleted": false,
      "currentStreak": 3,
      "progress": 0.3,
      "frequency": "daily",
      "goalDuration": 60,
      "createdAt": DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      "id": 4,
      "name": "Exercise for 45 Minutes",
      "isCompleted": false,
      "currentStreak": 0,
      "progress": 0.0,
      "frequency": "daily",
      "goalDuration": 30,
      "createdAt": DateTime.now(),
    },
    {
      "id": 5,
      "name": "Practice Gratitude Journal",
      "isCompleted": true,
      "currentStreak": 5,
      "progress": 0.5,
      "frequency": "daily",
      "goalDuration": 30,
      "createdAt": DateTime.now().subtract(const Duration(days: 5)),
    },
  ];

  // Mock motivational quote data
  String _currentQuote =
      "The secret of getting ahead is getting started. Small daily improvements over time lead to stunning results.";
  String _currentQuoteAuthor = "Mark Twain";

  final List<String> _motivationalQuotes = [
    "The secret of getting ahead is getting started. Small daily improvements over time lead to stunning results.",
    "Success is the sum of small efforts repeated day in and day out.",
    "You don't have to be great to get started, but you have to get started to be great.",
    "The best time to plant a tree was 20 years ago. The second best time is now.",
    "Discipline is choosing between what you want now and what you want most.",
  ];

  final List<String> _quoteAuthors = [
    "Mark Twain",
    "Robert Collier",
    "Les Brown",
    "Chinese Proverb",
    "Abraham Lincoln",
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fabScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  int get _totalStreak {
    return (_todaysHabits as List)
        .where((habit) => (habit as Map<String, dynamic>)['currentStreak'] > 0)
        .length;
  }

  List<Map<String, dynamic>> get _completedHabits {
    return (_todaysHabits as List)
        .where(
            (habit) => (habit as Map<String, dynamic>)['isCompleted'] == true)
        .cast<Map<String, dynamic>>()
        .toList();
  }

  List<Map<String, dynamic>> get _pendingHabits {
    return (_todaysHabits as List)
        .where(
            (habit) => (habit as Map<String, dynamic>)['isCompleted'] == false)
        .cast<Map<String, dynamic>>()
        .toList();
  }

  void _toggleHabitCompletion(String habitId) {
    setState(() {
      final habitIndex = _todaysHabits
          .indexWhere((habit) => habit['id'].toString() == habitId);

      if (habitIndex != -1) {
        final habit = _todaysHabits[habitIndex];
        final wasCompleted = habit['isCompleted'] ?? false;

        habit['isCompleted'] = !wasCompleted;

        if (!wasCompleted) {
          // Habit completed - increase streak
          habit['currentStreak'] = (habit['currentStreak'] ?? 0) + 1;
          habit['progress'] =
              ((habit['currentStreak'] ?? 0) / (habit['goalDuration'] ?? 30))
                  .clamp(0.0, 1.0);
        } else {
          // Habit uncompleted - decrease streak
          habit['currentStreak'] = ((habit['currentStreak'] ?? 0) - 1)
              .clamp(0, double.infinity)
              .toInt();
          habit['progress'] =
              ((habit['currentStreak'] ?? 0) / (habit['goalDuration'] ?? 30))
                  .clamp(0.0, 1.0);
        }
      }
    });

    HapticFeedback.lightImpact();
  }

  void _refreshMotivationalQuote() {
    setState(() {
      _isQuoteLoading = true;
    });

    // Simulate API call delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final randomIndex =
            DateTime.now().millisecond % _motivationalQuotes.length;
        setState(() {
          _currentQuote = _motivationalQuotes[randomIndex];
          _currentQuoteAuthor = _quoteAuthors[randomIndex];
          _isQuoteLoading = false;
        });
      }
    });
  }

  void _navigateToAddHabit() {
    _fabAnimationController.forward().then((_) {
      _fabAnimationController.reverse();
    });

    Navigator.pushNamed(context, '/add-new-habit-screen');
  }

  void _editHabit(String habitId) {
    Navigator.pushNamed(context, '/add-new-habit-screen',
        arguments: {'habitId': habitId});
  }

  void _deleteHabit(String habitId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Habit',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to delete this habit? This action cannot be undone.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _todaysHabits
                    .removeWhere((habit) => habit['id'].toString() == habitId);
              });
              Navigator.pop(context);
              HapticFeedback.lightImpact();
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

  void _viewHabitDetails(String habitId) {
    Navigator.pushNamed(context, '/habit-detail-screen',
        arguments: {'habitId': habitId});
  }

  void _skipHabitToday(String habitId) {
    // Implementation for skipping habit for today
    HapticFeedback.lightImpact();
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        // Already on Today screen
        break;
      case 1:
        Navigator.pushNamed(context, '/progress-screen');
        break;
      case 2:
        Navigator.pushNamed(context, '/ai-suggestions-screen');
        break;
    }
  }

  Future<void> _onRefresh() async {
    _refreshMotivationalQuote();

    // Simulate data sync
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        // Refresh any pending data
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppTheme.primaryTeal,
        child: CustomScrollView(
          slivers: [
            // Sticky Header
            SliverToBoxAdapter(
              child: DateHeaderWidget(
                currentDate: DateTime.now(),
                totalStreak: _totalStreak,
              ),
            ),

            // Motivational Quote
            SliverToBoxAdapter(
              child: MotivationalQuoteWidget(
                quote: _currentQuote,
                author: _currentQuoteAuthor,
                isLoading: _isQuoteLoading,
                onRefresh: _refreshMotivationalQuote,
              ),
            ),

            // Main Content
            _todaysHabits.isEmpty
                ? SliverFillRemaining(
                    child: EmptyStateWidget(
                      onCreateHabit: _navigateToAddHabit,
                    ),
                  )
                : SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pending Habits Section
                        if (_pendingHabits.isNotEmpty) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 2.h),
                            child: Text(
                              'Today\'s Habits (${_pendingHabits.length})',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _pendingHabits.length,
                            itemBuilder: (context, index) {
                              final habit = _pendingHabits[index];
                              return HabitCardWidget(
                                habit: habit,
                                onToggleComplete: _toggleHabitCompletion,
                                onEdit: _editHabit,
                                onDelete: _deleteHabit,
                                onViewDetails: _viewHabitDetails,
                                onSkipToday: _skipHabitToday,
                              );
                            },
                          ),
                        ],

                        // Completed Habits Section
                        if (_completedHabits.isNotEmpty) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 2.h),
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'check_circle',
                                  color: AppTheme.successGreen,
                                  size: 20,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'Completed (${_completedHabits.length})',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.successGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _completedHabits.length,
                            itemBuilder: (context, index) {
                              final habit = _completedHabits[index];
                              return HabitCardWidget(
                                habit: habit,
                                onToggleComplete: _toggleHabitCompletion,
                                onEdit: _editHabit,
                                onDelete: _deleteHabit,
                                onViewDetails: _viewHabitDetails,
                                onSkipToday: _skipHabitToday,
                              );
                            },
                          ),
                        ],

                        // Bottom spacing for FAB
                        SizedBox(height: 12.h),
                      ],
                    ),
                  ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: _todaysHabits.isNotEmpty
          ? AnimatedBuilder(
              animation: _fabScaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _fabScaleAnimation.value,
                  child: FloatingActionButton(
                    onPressed: _navigateToAddHabit,
                    backgroundColor: AppTheme.primaryTeal,
                    foregroundColor: AppTheme.pureWhite,
                    elevation: 4.0,
                    child: CustomIconWidget(
                      iconName: 'add',
                      color: AppTheme.pureWhite,
                      size: 28,
                    ),
                  ),
                );
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}

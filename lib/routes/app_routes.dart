import 'package:flutter/material.dart';
import '../presentation/today_s_habits_screen/today_s_habits_screen.dart';
import '../presentation/habit_detail_screen/habit_detail_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/progress_screen/progress_screen.dart';
import '../presentation/add_new_habit_screen/add_new_habit_screen.dart';
import '../presentation/ai_suggestions_screen/ai_suggestions_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String todaySHabits = '/today-s-habits-screen';
  static const String habitDetail = '/habit-detail-screen';
  static const String splash = '/splash-screen';
  static const String progress = '/progress-screen';
  static const String addNewHabit = '/add-new-habit-screen';
  static const String aiSuggestions = '/ai-suggestions-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    todaySHabits: (context) => const TodaySHabitsScreen(),
    habitDetail: (context) => const HabitDetailScreen(),
    splash: (context) => const SplashScreen(),
    progress: (context) => const ProgressScreen(),
    addNewHabit: (context) => const AddNewHabitScreen(),
    aiSuggestions: (context) => const AiSuggestionsScreen(),
    // TODO: Add your other routes here
  };
}

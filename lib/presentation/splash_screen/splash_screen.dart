import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  bool _isInitialized = false;
  double _loadingProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitialization();
  }

  void _initializeAnimations() {
    // Scale animation controller
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Fade animation controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Scale animation with bounce effect
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _scaleController.forward();
    });
  }

  Future<void> _startInitialization() async {
    try {
      // Set system UI overlay style
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppTheme.primaryTeal,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );

      // Simulate initialization steps with progress updates
      await _performInitializationSteps();

      // Wait for minimum splash duration
      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate to next screen
      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      // Handle initialization errors gracefully
      if (mounted) {
        _showErrorAndRetry();
      }
    }
  }

  Future<void> _performInitializationSteps() async {
    // Step 1: Initialize database
    await _updateProgress(0.2, "Initializing database...");
    await Future.delayed(const Duration(milliseconds: 400));

    // Step 2: Check permissions
    await _updateProgress(0.4, "Checking permissions...");
    await Future.delayed(const Duration(milliseconds: 300));

    // Step 3: Load cached data
    await _updateProgress(0.6, "Loading habit data...");
    await Future.delayed(const Duration(milliseconds: 400));

    // Step 4: Initialize AI services
    await _updateProgress(0.8, "Connecting to AI services...");
    await Future.delayed(const Duration(milliseconds: 300));

    // Step 5: Complete initialization
    await _updateProgress(1.0, "Ready!");
    await Future.delayed(const Duration(milliseconds: 200));

    setState(() {
      _isInitialized = true;
    });
  }

  Future<void> _updateProgress(double progress, String message) async {
    if (mounted) {
      setState(() {
        _loadingProgress = progress;
      });
    }
  }

  void _navigateToNextScreen() {
    // Check if user has existing habits (mock logic)
    final bool hasExistingHabits = _checkForExistingHabits();

    if (hasExistingHabits) {
      Navigator.pushReplacementNamed(context, '/today-s-habits-screen');
    } else {
      Navigator.pushReplacementNamed(context, '/today-s-habits-screen');
    }
  }

  bool _checkForExistingHabits() {
    // Mock logic - in real app, this would check local database
    // For now, assume new user for demo purposes
    return false;
  }

  void _showErrorAndRetry() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Initialization Error',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Unable to initialize the app. Please try again.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startInitialization();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryTeal,
              AppTheme.deepTeal,
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer to push content to center
              const Spacer(flex: 2),

              // Animated brain icon with checkmark
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeAnimation.value,
                          child: Container(
                            width: 25.w,
                            height: 25.w,
                            decoration: BoxDecoration(
                              color: AppTheme.pureWhite.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20.w),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppTheme.pureWhite.withValues(alpha: 0.2),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Brain icon
                                CustomIconWidget(
                                  iconName: 'psychology',
                                  color: AppTheme.pureWhite,
                                  size: 12.w,
                                ),
                                // Checkmark overlay
                                Positioned(
                                  bottom: 2.w,
                                  right: 2.w,
                                  child: Container(
                                    width: 6.w,
                                    height: 6.w,
                                    decoration: BoxDecoration(
                                      color: AppTheme.successGreen,
                                      borderRadius: BorderRadius.circular(3.w),
                                      border: Border.all(
                                        color: AppTheme.pureWhite,
                                        width: 2,
                                      ),
                                    ),
                                    child: CustomIconWidget(
                                      iconName: 'check',
                                      color: AppTheme.pureWhite,
                                      size: 3.w,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              SizedBox(height: 4.h),

              // App name
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Text(
                      'HabitMind',
                      style:
                          AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                        color: AppTheme.pureWhite,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 1.h),

              // Tagline
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value * 0.8,
                    child: Text(
                      'Build Better Habits with AI',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.pureWhite.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.2,
                      ),
                    ),
                  );
                },
              ),

              const Spacer(flex: 1),

              // Loading indicator and progress
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Column(
                      children: [
                        // Progress bar
                        Container(
                          width: 60.w,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppTheme.pureWhite.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 60.w * _loadingProgress,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppTheme.pureWhite,
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppTheme.pureWhite.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 2.h),

                        // Loading text
                        Text(
                          _isInitialized
                              ? 'Welcome to HabitMind!'
                              : 'Initializing...',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.pureWhite.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(height: 1.h),

                        // Progress percentage
                        Text(
                          '${(_loadingProgress * 100).toInt()}%',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.pureWhite.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              SizedBox(height: 6.h),
            ],
          ),
        ),
      ),
    );
  }
}

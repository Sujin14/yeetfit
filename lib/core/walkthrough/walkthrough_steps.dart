import 'package:flutter/widgets.dart';
import 'walkthrough_keys.dart';
import 'yana_tour_step.dart';

class DashboardTour {
  DashboardTour._();

  static const String introMessage =
      "I'll walk you through Yeetfit so you know exactly what everything "
      'does. Shall we go?';

  static final recovery = YanaTourStep(
    key: dashboardRecoveryKey,
    message:
        'This is your Recovery Score 💪 It tells you whether to push hard '
        'today or rest, based on your sleep, water and steps.',
    number: 1,
    total: 7,
  );
  static final mood = YanaTourStep(
    key: dashboardMoodKey,
    message:
        "Tap an emoji here to log your mood today 😊 After 2 weeks, I'll "
        'show you how your fitness affects how you feel.',
    number: 2,
    total: 7,
  );
  static final progressGrid = YanaTourStep(
    key: dashboardProgressGridKey,
    message:
        'These 4 cards show your daily progress — steps, water, sleep and '
        'calories 📊 Tap any card to log more.',
    number: 3,
    total: 7,
  );
  static final mealCard = YanaTourStep(
    key: dashboardMealCardKey,
    message:
        "Here's your nutrition summary for today 🥗 Tap 'Log meal' to add "
        'what you ate, or scan your meal with the camera.',
    number: 4,
    total: 7,
  );
  static final trackButton = YanaTourStep(
    key: dashboardTrackButtonKey,
    message:
        'Tap the + button anytime to quickly log water, sleep, steps or '
        'weight 📝',
    number: 5,
    total: 7,
  );
  static final coachChat = YanaTourStep(
    key: dashboardCoachChatKey,
    message:
        'This connects you to a real fitness coach for personal advice 🏋️',
    number: 6,
    total: 7,
  );
  static final yanaChat = YanaTourStep(
    key: dashboardYanaChatKey,
    message:
        "And I'm always here! Tap this to ask me anything about fitness, "
        'nutrition or recovery 🌟',
    number: 7,
    total: 7,
  );

  static List<GlobalKey> get targets => [
    for (final step in [
      recovery,
      mood,
      progressGrid,
      mealCard,
      trackButton,
      coachChat,
      yanaChat,
    ])
      step.key,
  ];
}

class ProgressTour {
  ProgressTour._();

  static const String introMessage =
      'Welcome to Progress! Here you can see your full monthly history.';

  static final filter = YanaTourStep(
    key: progressFilterKey,
    message:
        'Tap the filter to view monthly progress by steps, water, sleep, '
        'calories or mood 🎯',
    number: 1,
    total: 2,
  );
  static final calendar = YanaTourStep(
    key: progressCalendarKey,
    message:
        'Each circle is one day 🟢 Green = goal hit, red = missed. Aim for a '
        'full green month!',
    number: 2,
    total: 2,
  );

  static List<GlobalKey> get targets => [filter.key, calendar.key];
}

class ChallengesTour {
  ChallengesTour._();

  static final firstCard = YanaTourStep(
    key: challengesFirstCardKey,
    message:
        "Tap 'Join' on any challenge to enter 🚀 Your progress updates "
        'automatically when you log your daily activities.',
    number: 1,
    total: 1,
  );

  static List<GlobalKey> get targets => [firstCard.key];
}

class ExploreTour {
  ExploreTour._();

  static final sessions = YanaTourStep(
    key: exploreSessionsKey,
    message:
        'Your coach can schedule live group sessions here 🎯 When one goes '
        'live, tap Join to open Google Meet and train together in real time.',
    number: 1,
    total: 1,
  );

  static List<GlobalKey> get targets => [sessions.key];
}

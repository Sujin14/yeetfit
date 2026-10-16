import 'package:flutter/widgets.dart';

// Showcase targets. Each key is attached to exactly one widget instance, so
// the screens holding them must not be on screen twice at once.

// Dashboard keys
final GlobalKey dashboardRecoveryKey = GlobalKey();
final GlobalKey dashboardMoodKey = GlobalKey();
final GlobalKey dashboardProgressGridKey = GlobalKey();
final GlobalKey dashboardMealCardKey = GlobalKey();
final GlobalKey dashboardTrackButtonKey = GlobalKey();
final GlobalKey dashboardCoachChatKey = GlobalKey();
final GlobalKey dashboardYanaChatKey = GlobalKey();

// Progress keys
final GlobalKey progressFilterKey = GlobalKey();
final GlobalKey progressCalendarKey = GlobalKey();

// Challenges keys
final GlobalKey challengesFirstCardKey = GlobalKey();

// Explore keys
final GlobalKey exploreSessionsKey = GlobalKey();

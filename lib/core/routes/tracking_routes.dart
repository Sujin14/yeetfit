import 'package:go_router/go_router.dart';
import 'package:yeetfit/features/meal_tracking/presentation/screens/calorie_tracking_screen.dart';
import 'package:yeetfit/features/meal_tracking/presentation/screens/food_search_screen.dart';
import 'package:yeetfit/features/meal_tracking/presentation/screens/weekly_calorie_chart_screen.dart';
import 'package:yeetfit/features/meal_tracking/data/model/food_model.dart';
import 'package:yeetfit/features/meal_tracking/presentation/screens/nutrition_details_screen.dart';
import 'package:yeetfit/features/sleep_tracking/presentation/screens/sleep_tracking_screen.dart';
import 'package:yeetfit/features/steps_tracking/presentation/screens/step_counter_screen.dart';
import 'package:yeetfit/features/water_tracking/presentation/screens/water_tracking_screen.dart';
import 'package:yeetfit/features/weight_tracking/presentation/screens/weight_tracking_screen.dart';
import 'package:yeetfit/features/water_tracking/presentation/widgets/water_success_page.dart';
import 'package:yeetfit/features/steps_tracking/presentation/widgets/steps_success_page.dart';
import 'package:yeetfit/features/weight_tracking/presentation/widgets/weight_success_page.dart';

import 'tracking_routes_constants.dart';

// Routes for tracking features (modals and success pages).
List<GoRoute> get trackingRoutes => [
  GoRoute(
    path: TrackingRouteConstants.calorieTracking,
    builder: (context, state) => const CalorieTrackingScreen(),
  ),
  GoRoute(
    path: TrackingRouteConstants.foodSearch,
    builder: (context, state) =>
        FoodSearchScreen(mealType: state.extra as String? ?? 'Breakfast'),
  ),
  GoRoute(
    path: TrackingRouteConstants.nutritionDetails,
    builder: (context, state) {
      final foodItem = state.extra as FoodItem;
      return NutritionDetailsScreen(foodItem: foodItem);
    },
  ),
  GoRoute(
    path: TrackingRouteConstants.weeklyCalorieChart,
    builder: (context, state) => const WeeklyCalorieChartScreen(),
  ),
  GoRoute(
    path: TrackingRouteConstants.stepCounter,
    builder: (context, state) => const StepCounterScreen(),
  ),
  GoRoute(
    path: TrackingRouteConstants.sleepTracking,
    builder: (context, state) => const SleepTrackingScreen(),
  ),
  GoRoute(
    path: TrackingRouteConstants.waterTracking,
    builder: (context, state) => const WaterTrackingScreen(),
  ),
  GoRoute(
    path: TrackingRouteConstants.weightTracking,
    builder: (context, state) => const WeightTrackingScreen(),
  ),
  GoRoute(
    name: 'water-success',
    path: TrackingRouteConstants.waterSuccess,
    builder: (context, state) {
      final goal = int.tryParse(state.pathParameters['goal'] ?? '0') ?? 0;
      return WaterSuccessPage(goal: goal);
    },
  ),
  GoRoute(
    name: 'weight-success',
    path: TrackingRouteConstants.weightSuccess,
    builder: (context, state) {
      final goal = double.tryParse(state.pathParameters['goal'] ?? '0') ?? 0;
      return WeightSuccessPage(goal: goal.toString());
    },
  ),
  GoRoute(
    name: 'steps-success',
    path: TrackingRouteConstants.stepsSuccess,
    builder: (context, state) {
      final goal = state.pathParameters['goal'] ?? '0';
      return StepsSuccessPage(goal: goal);
    },
  ),
];

import 'package:go_router/go_router.dart';
import 'package:yeetfit/features/plans/presentation/screens/favorites_page.dart';
import 'package:yeetfit/features/plans/presentation/screens/plan_detail_page.dart';
import 'package:yeetfit/features/plans/presentation/screens/plan_list_screen.dart';
import 'plans_route_constants.dart';

// Routes for plans and favorites features.
List<GoRoute> get plansRoutes => [
  GoRoute(
    path: PlansRouteConstants.list,
    builder: (context, state) =>
        PlanListScreen(category: state.pathParameters['category']!),
  ),
  GoRoute(
    path: PlansRouteConstants.detail,
    builder: (context, state) =>
        PlanDetailPage(extra: state.extra as Map<String, dynamic>),
  ),
  GoRoute(
    path: PlansRouteConstants.favorites,
    builder: (context, state) => const FavoritesPage(),
  ),
];

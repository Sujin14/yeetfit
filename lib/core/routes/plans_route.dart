import 'package:go_router/go_router.dart';
import 'package:yeetfit/features/plans/presentation/screens/plan_detail_page.dart';
import 'package:yeetfit/features/plans/presentation/screens/plan_list_screen.dart';
import 'plans_route_constants.dart';

// Routes for plan lists and plan details.
List<GoRoute> get plansRoutes => [
  GoRoute(
    path: PlansRouteConstants.list,
    builder: (context, state) => PlanListScreen(
      category: state.pathParameters[PlansRouteConstants.categoryParam]!,
    ),
  ),
  GoRoute(
    path: PlansRouteConstants.detail,
    builder: (context, state) => PlanDetailPage(
      category: state.pathParameters[PlansRouteConstants.categoryParam]!,
      planId: state.pathParameters[PlansRouteConstants.planIdParam]!,
    ),
  ),
];

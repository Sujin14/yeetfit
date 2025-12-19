import 'package:go_router/go_router.dart';
import 'package:yeetfit/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:yeetfit/features/explore/presentation/screens/explore_screen.dart';
import 'package:yeetfit/features/progress/presentation/screens/progress_screen.dart';
import '../../features/plans/presentation/screens/favorites_page.dart';
import 'shell_route_constants.dart';
import 'shell_scaffold.dart';

//StatefulShellRoute for main app shell (bottom nav).
StatefulShellRoute get shellRoute => StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ShellScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: ShellRouteConstants.dashboard,
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: ShellRouteConstants.explore,
              builder: (context, state) => const ExploreScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: ShellRouteConstants.progress,
              builder: (context, state) => const ProgressScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: ShellRouteConstants.favorites,
              builder: (context, state) => const FavoritesPage(),
            ),
          ],
        ),
      ],
    );
// Constants for plans routes.
class PlansRouteConstants {
  static const String list = '/plans/:category';
  static const String detail = '/plans/:category/:planId';

  static const String categoryParam = 'category';
  static const String planIdParam = 'planId';

  static String listPath(String category) => '/plans/$category';

  static String detailPath(String category, String planId) =>
      '/plans/$category/$planId';
}

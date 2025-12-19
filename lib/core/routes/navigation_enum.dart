// Enum for bottom navigation indices and titles in ShellScaffold.
enum NavigationTab {
  dashboard(TabIndex: 0, title: 'Dashboard', route: '/user-dashboard'),
  explore(TabIndex: 1, title: 'Explore', route: '/explore'),
  track(TabIndex: 2, title: 'Track'), // No route; placeholder for modals.
  progress(TabIndex: 3, title: 'Progress', route: '/progress'),
  favorites(TabIndex: 4, title: 'Favorites', route: '/favorites');

  const NavigationTab({required this.TabIndex, this.title = '', this.route = ''});
  final int TabIndex;
  final String title;
  final String route;
}
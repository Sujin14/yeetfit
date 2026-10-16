// Bottom navigation tabs in ShellScaffold; declaration order is the nav index.
enum NavigationTab {
  dashboard('Dashboard'),
  explore('Explore'),
  track('Track'), // Opens the track options modal; no branch of its own.
  progress('Progress'),
  coaches('Coaches');

  const NavigationTab(this.title);
  final String title;
}

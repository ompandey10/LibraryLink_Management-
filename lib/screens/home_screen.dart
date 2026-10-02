import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/library_provider.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'book_search_screen.dart';
import 'tracker_screen.dart';
import 'reminders_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _i = 0;

  late final List<Widget> _screens = [
    DashboardScreen(onNavigate: (i) => setState(() => _i = i)),
    const BookSearchScreen(),
    const TrackerScreen(),
    const RemindersScreen(),
  ];
  static const _titles = ['LibraryLink', 'Catalog', 'Circulation', 'Reminders'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgeCount =
        Provider.of<LibraryProvider>(context).overdueIssues.length +
        Provider.of<LibraryProvider>(context).activeIssues
            .where((r) => r.dueDate != null && !r.isOverdue && r.daysLeft <= 7)
            .length;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_i]),
        actions: [
          if (_i == 0)
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () => setState(() => _i = 1),
            ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: _screens[_i],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: theme.colorScheme.outline, width: 1),
          ),
        ),
        child: NavigationBar(
          height: 64,
          selectedIndex: _i,
          onDestinationSelected: (i) => setState(() => _i = i),
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.auto_awesome_outlined),
              selectedIcon: Icon(Icons.auto_awesome_rounded),
              label: 'Discover',
            ),
            const NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book_rounded),
              label: 'Catalog',
            ),
            const NavigationDestination(
              icon: Icon(Icons.track_changes_outlined),
              selectedIcon: Icon(Icons.track_changes_rounded),
              label: 'Circulation',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: badgeCount > 0,
                label: Text(
                  '$badgeCount',
                  style: const TextStyle(fontSize: 10),
                ),
                backgroundColor: AppTheme.statusOverdue,
                child: const Icon(Icons.notifications_outlined),
              ),
              selectedIcon: Badge(
                isLabelVisible: badgeCount > 0,
                label: Text(
                  '$badgeCount',
                  style: const TextStyle(fontSize: 10),
                ),
                backgroundColor: AppTheme.statusOverdue,
                child: const Icon(Icons.notifications_rounded),
              ),
              label: 'Alerts',
            ),
          ],
        ),
      ),
    );
  }
}

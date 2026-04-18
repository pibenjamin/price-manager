/// PrixCourses App - Material Design 3
///
/// Material Design 3 implementation following Flutter guidelines:
/// https://api.flutter.dev/flutter/material/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/scanner/presentation/scanner_screen.dart';
import 'features/history/presentation/history_screen.dart';
import 'features/analytics/presentation/analytics_screen.dart';
import 'features/settings/presentation/settings_screen.dart';

void main() {
  runApp(const ProviderScope(child: PrixCoursesApp()));
}

class PrixCoursesApp extends StatelessWidget {
  const PrixCoursesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PrixCourses',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ScannerScreen(),
    HistoryScreen(),
    AnalyticsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.qr_code_scanner_outlined,
                color: colorScheme.onSurfaceVariant),
            selectedIcon: Icon(Icons.qr_code_scanner,
                color: colorScheme.onSecondaryContainer),
            label: 'Scanner',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined,
                color: colorScheme.onSurfaceVariant),
            selectedIcon:
                Icon(Icons.history, color: colorScheme.onSecondaryContainer),
            label: 'Historique',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined,
                color: colorScheme.onSurfaceVariant),
            selectedIcon:
                Icon(Icons.bar_chart, color: colorScheme.onSecondaryContainer),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined,
                color: colorScheme.onSurfaceVariant),
            selectedIcon:
                Icon(Icons.settings, color: colorScheme.onSecondaryContainer),
            label: 'Paramètres',
          ),
        ],
      ),
    );
  }
}

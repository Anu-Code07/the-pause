import 'package:flutter/material.dart';

import '../../state/pause_controller.dart';
import '../../theme/pause_theme.dart';
import '../friends/friends_screen.dart';
import '../profile/profile_screen.dart';
import '../rest/rest_home_screen.dart';
import '../schedule/schedule_screen.dart';
import '../timer/timer_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _pages = [
    RestHomeScreen(),
    FriendsScreen(),
    ScheduleScreen(),
    TimerScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final c = PauseScope.of(context);
    final hideNav = c.isResting;
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: hideNav
          ? null
          : NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              backgroundColor: PauseColors.paper,
              indicatorColor: PauseColors.mist,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.nights_stay_outlined),
                  selectedIcon: Icon(Icons.nights_stay),
                  label: 'Rest',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: 'Circle',
                ),
                NavigationDestination(
                  icon: Icon(Icons.calendar_today_outlined),
                  selectedIcon: Icon(Icons.calendar_today),
                  label: 'Blocks',
                ),
                NavigationDestination(
                  icon: Icon(Icons.timer_outlined),
                  selectedIcon: Icon(Icons.timer),
                  label: 'Timer',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'You',
                ),
              ],
            ),
    );
  }
}

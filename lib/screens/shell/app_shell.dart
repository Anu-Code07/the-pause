import 'package:flutter/material.dart';

import '../../state/pause_controller.dart';
import '../../theme/pause_theme.dart';
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
    ScheduleScreen(),
    TimerScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final c = PauseScope.of(context);
    final hideNav = c.isResting;
    return Scaffold(
      backgroundColor: PauseColors.cream,
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: hideNav
          ? null
          : DecoratedBox(
              decoration: const BoxDecoration(
                color: PauseColors.paper,
                border: Border(
                  top: BorderSide(color: PauseColors.hairline, width: 0.5),
                ),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: 62,
                  child: Row(
                    children: [
                      _Tab(
                        icon: Icons.nights_stay_outlined,
                        activeIcon: Icons.nights_stay,
                        label: 'Rest',
                        selected: _index == 0,
                        onTap: () => setState(() => _index = 0),
                      ),
                      _Tab(
                        icon: Icons.calendar_today_outlined,
                        activeIcon: Icons.calendar_today,
                        label: 'Blocks',
                        selected: _index == 1,
                        onTap: () => setState(() => _index = 1),
                      ),
                      _Tab(
                        icon: Icons.timer_outlined,
                        activeIcon: Icons.timer,
                        label: 'Timer',
                        selected: _index == 2,
                        onTap: () => setState(() => _index = 2),
                      ),
                      _Tab(
                        icon: Icons.person_outline,
                        activeIcon: Icons.person,
                        label: 'You',
                        selected: _index == 3,
                        onTap: () => setState(() => _index = 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? PauseColors.ink : PauseColors.stone;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(selected ? activeIcon : icon, size: 22, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../state/pause_controller.dart';
import '../../theme/pause_theme.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = PauseScope.of(context);
    return Scaffold(
      backgroundColor: PauseColors.cream,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.fromLTRB(22, 28, 22, 22),
                decoration: BoxDecoration(
                  color: PauseColors.ink,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 30,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Timer',
                      style: TextStyle(
                        fontFamily: 'Playfair Display',
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 6,
                      children: [
                        Text(
                          'Block',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                        for (final app in c.blockedApps.take(3))
                          CircleAvatar(
                            radius: 9,
                            backgroundColor: app.tint,
                            child: Icon(
                              app.icon,
                              size: 10,
                              color: Colors.white,
                            ),
                          ),
                        Text(
                          'for',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _RoundBtn(
                          icon: Icons.remove,
                          onTap: c.timerRunning ? null : () => c.bumpTimer(-5),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Text(
                            c.timerLabel,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 52,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        _RoundBtn(
                          icon: Icons.add,
                          onTap: c.timerRunning ? null : () => c.bumpTimer(5),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: c.cancelTimer,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF2A2A2A),
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(50),
                              shape: const StadiumBorder(),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            onPressed: c.timerRunning ? null : c.startTimer,
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: PauseColors.ink,
                              minimumSize: const Size.fromHeight(50),
                              shape: const StadiumBorder(),
                            ),
                            child: Text(c.timerRunning ? 'Running' : 'Start'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundBtn extends StatelessWidget {
  const _RoundBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      onPressed: onTap,
      style: IconButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white54),
      ),
      icon: Icon(icon),
    );
  }
}

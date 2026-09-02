import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'screens/onboarding/onboarding_screen.dart';
import 'screens/shell/app_shell.dart';
import 'state/pause_controller.dart';
import 'theme/pause_theme.dart';

class PauseApp extends StatelessWidget {
  const PauseApp({super.key, required this.controller});

  final PauseController controller;

  @override
  Widget build(BuildContext context) {
    return PauseScope(
      controller: controller,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return MaterialApp(
            title: 'Pause',
            debugShowCheckedModeBanner: false,
            theme: PauseTheme.light(),
            builder: (context, child) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final framed = constraints.maxWidth > 520;
                  final content = child ?? const SizedBox.shrink();
                  if (!framed) return content;
                  final height = math.min(844.0, constraints.maxHeight - 32);
                  return ColoredBox(
                    color: const Color(0xFFE8E8E8),
                    child: Center(
                      child: Container(
                        width: 390,
                        height: height,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(36),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.18),
                              blurRadius: 40,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: content,
                      ),
                    ),
                  );
                },
              );
            },
            home: controller.onboardingComplete
                ? const AppShell()
                : const OnboardingScreen(),
          );
        },
      ),
    );
  }
}

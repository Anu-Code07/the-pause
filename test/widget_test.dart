import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:the_pause/app.dart';
import 'package:the_pause/state/pause_controller.dart';

void main() {
  testWidgets('onboarding starts with continue', (tester) async {
    final controller = PauseController();
    await tester.pumpWidget(PauseApp(controller: controller));
    await tester.pump();
    expect(find.byKey(const Key('onboarding-continue')), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('finishing onboarding opens rest home', (tester) async {
    final controller = PauseController()..onboardingComplete = true;
    await tester.pumpWidget(PauseApp(controller: controller));
    await tester.pump();
    expect(find.text('Begin now'), findsOneWidget);
    expect(find.textContaining('Instagram'), findsWidgets);
  });
}

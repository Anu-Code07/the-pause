import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_pause/app.dart';
import 'package:the_pause/state/pause_controller.dart';

final _shotKey = GlobalKey();
const _outDir = 'docs/screenshots';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await _loadFonts();
    Directory(_outDir).createSync(recursive: true);
  });

  testWidgets('capture README screenshots', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    tester.view.padding = const FakeViewPadding(top: 59, bottom: 34);
    tester.view.viewPadding = const FakeViewPadding(top: 59, bottom: 34);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPadding);
    addTearDown(tester.view.resetViewPadding);

    await _shot(
      tester,
      name: 'onboarding',
      controller: PauseController(),
    );

    await _shot(
      tester,
      name: 'rest',
      controller: PauseController()..onboardingComplete = true,
    );

    await _shot(
      tester,
      name: 'resting',
      controller: PauseController()
        ..onboardingComplete = true
        ..startRest(duration: const Duration(hours: 23, minutes: 41)),
    );

    await _shot(
      tester,
      name: 'recap',
      controller: PauseController()
        ..onboardingComplete = true
        ..startRest(duration: const Duration(hours: 24))
        ..completeRest(),
    );

    await _shot(
      tester,
      name: 'schedule',
      controller: PauseController()..onboardingComplete = true,
      afterPump: () async {
        await tester.tap(find.byIcon(Icons.calendar_today_outlined));
        await _settleFrames(tester);
      },
    );

    await _shot(
      tester,
      name: 'timer',
      controller: PauseController()..onboardingComplete = true,
      afterPump: () async {
        await tester.tap(find.byIcon(Icons.timer_outlined));
        await _settleFrames(tester);
      },
    );
  });
}

Future<void> _shot(
  WidgetTester tester, {
  required String name,
  required PauseController controller,
  Future<void> Function()? afterPump,
}) async {
  await tester.pumpWidget(
    RepaintBoundary(
      key: _shotKey,
      child: PauseApp(controller: controller),
    ),
  );
  await _settleFrames(tester);
  if (afterPump != null) await afterPump();
  await tester.runAsync(() async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
  });
  await tester.pump(const Duration(milliseconds: 50));

  final boundary =
      _shotKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 3);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    File('$_outDir/$name.png').writeAsBytesSync(bytes!.buffer.asUint8List());
    image.dispose();
  });
  await tester.pumpWidget(const SizedBox.shrink());
  controller.dispose();
}

Future<void> _settleFrames(WidgetTester tester) async {
  for (var i = 0; i < 12; i++) {
    await tester.pump(const Duration(milliseconds: 40));
  }
}

Future<void> _loadFonts() async {
  Future<void> loadFamily(String family, List<String> paths) async {
    final loader = FontLoader(family);
    for (final path in paths) {
      loader.addFont(rootBundle.load(path));
    }
    await loader.load();
  }

  await loadFamily('Playfair Display', [
    'fonts/PlayfairDisplay-Regular.ttf',
    'fonts/PlayfairDisplay-Italic.ttf',
  ]);
  await loadFamily('Inter', ['fonts/Inter.ttf']);

  final iconPath =
      '${Platform.environment['FLUTTER_ROOT'] ?? '/home/ubuntu/flutter'}/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf';
  final iconBytes = File(iconPath).readAsBytesSync();
  final icons = FontLoader('MaterialIcons')
    ..addFont(Future.value(ByteData.sublistView(Uint8List.fromList(iconBytes))));
  await icons.load();
}

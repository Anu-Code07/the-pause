import 'package:flutter/material.dart';

import 'app.dart';
import 'state/pause_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = PauseController();
  await controller.hydrate();
  runApp(PauseApp(controller: controller));
}

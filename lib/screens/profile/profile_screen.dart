import 'package:flutter/material.dart';

import '../../state/pause_controller.dart';
import '../../theme/pause_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = PauseScope.of(context);
    return Scaffold(
      backgroundColor: PauseColors.cream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
          children: [
            const Text(
              'You',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 36,
                color: PauseColors.ink,
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: TextEditingController(text: c.name),
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              onSubmitted: c.setName,
            ),
            const SizedBox(height: 18),
            _Stat(label: 'Streak', value: '${c.streak} weeks'),
            _Stat(label: 'Finished', value: '${c.completedCount} Pauses'),
            _Stat(label: 'Rest day', value: c.restDayLabel),
            _Stat(
              label: 'Quiet apps',
              value: '${c.blockedApps.length}',
            ),
            _Stat(
              label: 'Lifelines',
              value: c.activeLifelines.map((l) => l.name).join(', '),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: c.resetOnboarding,
              child: const Text('Replay onboarding'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                color: PauseColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

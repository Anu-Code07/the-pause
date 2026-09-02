import 'package:flutter/material.dart';

import '../../state/pause_controller.dart';
import '../../theme/pause_theme.dart';
import '../../widgets/session_card.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = PauseScope.of(context);
    final finished = c.friends.where((f) => f.finished).toList();
    final resting = c.friends.where((f) => f.isResting).toList();

    return Scaffold(
      backgroundColor: PauseColors.cream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
          children: [
            const Text(
              'Circle',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 36,
                color: PauseColors.ink,
              ),
            ),
            const SizedBox(height: 6),
            const Text('Rest together. See who kept the day.'),
            const SizedBox(height: 22),
            if (resting.isNotEmpty) ...[
              const Text(
                'Resting now',
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 92,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final f in resting)
                      Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: f.tint,
                              child: Text(
                                f.initials,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(f.name),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
            const Text(
              'This week',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 12),
            for (final f in finished) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: PauseColors.paper,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: f.tint,
                      child: Text(
                        f.initials,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            f.name,
                            style: const TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            f.pauses == 0
                                ? 'Perfect Pause'
                                : '${f.pauses} pause · ${f.pauseReason ?? ''}',
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      f.pauses == 0
                          ? Icons.check_circle
                          : Icons.pause_circle_filled,
                      color: f.pauses == 0
                          ? PauseColors.goldDeep
                          : PauseColors.stone,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            const SessionCard(
              count: 1,
              dateLabel: 'Last week',
              hours: 24,
              perfect: true,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../state/pause_controller.dart';
import '../../theme/pause_theme.dart';
import '../../widgets/select_tile.dart';
import '../../widgets/session_card.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = PauseScope.of(context);
    final finished = c.circle.where((f) => f.finished).toList();
    final resting = c.restingCircle;
    final inviteable = c.friends.where((f) => !c.circleIds.contains(f.id));

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
            Text(
              c.householdMode
                  ? 'This house rests together. See who kept the day.'
                  : 'Rest together. See who kept the day.',
            ),
            const SizedBox(height: 18),
            FilledButton.tonal(
              onPressed: () => _invite(context),
              child: const Text('Invite someone'),
            ),
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
                            PersonDot(initials: f.initials, tint: f.tint, radius: 26),
                            const SizedBox(height: 6),
                            Text(f.name),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
            const Text(
              'This week',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 12),
            if (c.circle.isEmpty)
              const Text('Invite your table. Rest is easier with someone.')
            else
              for (final f in c.circle) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: PauseColors.paper,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      PersonDot(initials: f.initials, tint: f.tint),
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
                              f.finished
                                  ? (f.pauses == 0
                                      ? 'Perfect Pause'
                                      : '${f.pauses} pause · ${f.pauseReason ?? ''}')
                                  : (f.isResting ? 'Resting now' : 'Invited'),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        f.pauses == 0 && f.finished
                            ? Icons.check_circle
                            : Icons.people_outline,
                        color: f.pauses == 0 && f.finished
                            ? PauseColors.goldDeep
                            : PauseColors.stone,
                      ),
                    ],
                  ),
                ),
              ],
            if (finished.isNotEmpty) ...[
              const SizedBox(height: 8),
              const SessionCard(
                count: 1,
                dateLabel: 'Last week',
                hours: 24,
                perfect: true,
              ),
            ],
            if (inviteable.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                'Add from suggestions',
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              for (final f in inviteable)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SelectTile(
                    label: f.name,
                    subtitle: 'Tap to invite',
                    selected: false,
                    onTap: () => c.toggleCircle(f.id),
                    leading: PersonDot(
                      initials: f.initials,
                      tint: f.tint,
                      radius: 16,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _invite(BuildContext context) async {
    final c = PauseScope.of(context);
    final field = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: PauseColors.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            20,
            24,
            24 + MediaQuery.viewInsetsOf(ctx).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Invite to your table',
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: field,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  c.addPersonToCircle(value);
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  c.addPersonToCircle(field.text);
                  Navigator.pop(ctx);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: PauseColors.ink,
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('Add'),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/models.dart';
import '../../state/pause_controller.dart';
import '../../theme/pause_theme.dart';
import '../../widgets/session_card.dart';
import '../../widgets/sky_backdrop.dart';
import '../../widgets/slide_to_pause.dart';

class RestHomeScreen extends StatelessWidget {
  const RestHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = PauseScope.of(context);
    if (c.status == RestStatus.finished) return const _Recap();
    if (c.isResting) return const _ActiveRest();
    return const _Upcoming();
  }
}

class _Upcoming extends StatelessWidget {
  const _Upcoming();

  @override
  Widget build(BuildContext context) {
    final c = PauseScope.of(context);
    final days = c.daysUntilRest;
    final when = days == 0
        ? 'Tonight at sundown'
        : days == 1
            ? 'Tomorrow at sundown'
            : 'In $days days · ${c.restDayLabel} sundown';

    return Scaffold(
      backgroundColor: PauseColors.cream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 40),
          children: [
            const Text(
              'Pause',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 40,
                color: PauseColors.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(when, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 22),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  const SizedBox(
                    height: 280,
                    width: double.infinity,
                    child: SkyBackdrop(
                      asset: 'assets/images/dusk_sky.png',
                      kenBurns: false,
                      darken: 0.18,
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          const Text(
                            'Your next\nsacred day',
                            style: TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 34,
                              height: 1.08,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Streak ${c.streak} · ${c.completedCount} finished',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.white.withValues(alpha: 0.86),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () => c.startRest(),
              style: FilledButton.styleFrom(
                backgroundColor: PauseColors.ink,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(54),
                shape: const StadiumBorder(),
              ),
              child: const Text('Begin this Pause'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Calls, messages, and the lifelines you chose still get through.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),
            const Text(
              'Still reaches you',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 22,
                color: PauseColors.ink,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final line in c.activeLifelines)
                  Chip(
                    avatar: Icon(line.icon, size: 16, color: Colors.white),
                    label: Text(line.name),
                    backgroundColor: line.tint,
                    labelStyle: const TextStyle(color: Colors.white),
                    side: BorderSide.none,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveRest extends StatelessWidget {
  const _ActiveRest();

  @override
  Widget build(BuildContext context) {
    final c = PauseScope.of(context);
    final restingFriends = c.friends.where((f) => f.isResting).toList();
    final names = restingFriends.map((f) => f.name).join(' and ');
    final paused = c.status == RestStatus.paused;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SkyBackdrop(
            asset: paused
                ? 'assets/images/sunrise_sky.png'
                : 'assets/images/dusk_sky.png',
            darken: 0.2,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 18),
              child: Column(
                children: [
                  _StatusRow(paused: paused),
                  const Spacer(),
                  Text(
                    paused ? 'Paused' : 'Pause',
                    style: const TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 56,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    c.remainingLabel,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  if (restingFriends.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (final f in restingFriends.take(3))
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: CircleAvatar(
                              backgroundColor: f.tint,
                              child: Text(
                                f.initials,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$names ${restingFriends.length == 1 ? 'is' : 'are'} resting now.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 22),
                  ],
                  if (paused)
                    FilledButton(
                      onPressed: c.resumeRest,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: PauseColors.ink,
                        minimumSize: const Size.fromHeight(54),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('Return to rest'),
                    )
                  else
                    SlideToPause(
                      label: 'slide to pause',
                      onCompleted: () => _askReason(context),
                    ),
                  TextButton(
                    onPressed: c.completeRest,
                    child: Text(
                      'End this Pause',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _askReason(BuildContext context) async {
    final c = PauseScope.of(context);
    final controller = TextEditingController();
    final reason = await showModalBottomSheet<String>(
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
                'Why are you pausing?',
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This is visible to your circle. Friction, not a lock.',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Needed maps, a work ping, a call…',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pop(
                  ctx,
                  controller.text.trim().isEmpty
                      ? 'Needed a minute'
                      : controller.text.trim(),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: PauseColors.ink,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Pause for 15 minutes'),
              ),
            ],
          ),
        );
      },
    );
    if (reason != null) c.takeBreak(reason);
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.paused});

  final bool paused;

  @override
  Widget build(BuildContext context) {
    final c = PauseScope.of(context);
    return Column(
      children: [
        Text(
          paused
              ? 'Temporarily open'
              : 'Quiet until ${DateFormat.jm().format(c.restEndsAt ?? DateTime.now())}',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          children: [
            for (final app in c.blockedApps.take(4))
              CircleAvatar(
                radius: 11,
                backgroundColor: app.tint,
                child: Icon(app.icon, size: 12, color: Colors.white),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          c.activeLifelines.isEmpty
              ? 'No lifelines'
              : '${c.activeLifelines.map((l) => l.name).join(', ')} still reach you',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.78),
          ),
        ),
      ],
    );
  }
}

class _Recap extends StatelessWidget {
  const _Recap();

  @override
  Widget build(BuildContext context) {
    final c = PauseScope.of(context);
    final perfect = c.breaks.isEmpty;
    return Scaffold(
      backgroundColor: PauseColors.cream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
          children: [
            const Text(
              'You finished your Pause',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 34,
                height: 1.15,
                color: PauseColors.ink,
              ),
            ),
            const SizedBox(height: 22),
            SessionCard(
              count: c.completedCount,
              dateLabel: DateFormat.MMMMd().format(DateTime.now()),
              hours: 24,
              perfect: perfect,
            ),
            if (!perfect) ...[
              const SizedBox(height: 16),
              Text(
                'You paused ${c.breaks.length} ${c.breaks.length == 1 ? 'time' : 'times'}. Your circle can see why.',
              ),
              for (final b in c.breaks)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(b.reason),
                  subtitle: Text(DateFormat.jm().format(b.at)),
                ),
            ],
            const SizedBox(height: 28),
            FilledButton(
              onPressed: c.dismissRecap,
              style: FilledButton.styleFrom(
                backgroundColor: PauseColors.ink,
                minimumSize: const Size.fromHeight(54),
                shape: const StadiumBorder(),
              ),
              child: const Text('Back to the week'),
            ),
          ],
        ),
      ),
    );
  }
}

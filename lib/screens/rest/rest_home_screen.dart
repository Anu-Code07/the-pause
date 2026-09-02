import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/models.dart';
import '../../state/pause_controller.dart';
import '../../theme/pause_theme.dart';
import '../../widgets/select_tile.dart';
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
            const SizedBox(height: 4),
            Text(
              c.autoStart
                  ? 'Starts on its own · ${c.nextStartLine}'
                  : c.nextStartLine,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  SizedBox(
                    height: 260,
                    width: double.infinity,
                    child: Image.asset(
                      c.intention.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.05),
                            Colors.black.withValues(alpha: 0.55),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 22,
                    right: 22,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.intention.phrase,
                          style: const TextStyle(
                            fontFamily: 'Playfair Display',
                            fontSize: 32,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          c.promiseLine,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => c.startRest(),
              style: FilledButton.styleFrom(
                backgroundColor: PauseColors.ink,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(54),
                shape: const StadiumBorder(),
              ),
              child: const Text('Begin now'),
            ),
            const SizedBox(height: 8),
            const Text(
              'Leave the phone in another room if you can. The day is not on the lock screen.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
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
                for (final vip in c.activeVips)
                  Chip(
                    avatar: PersonDot(
                      initials: vip.initials,
                      tint: vip.tint,
                      radius: 10,
                    ),
                    label: Text(vip.name),
                    backgroundColor: PauseColors.paper,
                    side: BorderSide.none,
                  ),
                for (final line in c.activeLifelines)
                  Chip(
                    avatar: Icon(line.icon, size: 14, color: Colors.white),
                    label: Text(line.name),
                    backgroundColor: line.tint,
                    labelStyle: const TextStyle(color: Colors.white),
                    side: BorderSide.none,
                  ),
              ],
            ),
            const SizedBox(height: 18),
            const Text(
              'Goes quiet',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final app in c.blockedApps)
                  Chip(
                    avatar: Icon(app.icon, size: 14, color: Colors.white),
                    label: Text(app.name),
                    backgroundColor: app.tint,
                    labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
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

class _ActiveRest extends StatefulWidget {
  const _ActiveRest();

  @override
  State<_ActiveRest> createState() => _ActiveRestState();
}

class _ActiveRestState extends State<_ActiveRest> {
  String? _banner;
  bool _isCall = false;
  Timer? _t1;
  Timer? _t2;

  @override
  void initState() {
    super.initState();
    _t1 = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _banner = 'Instagram is resting.';
          _isCall = false;
        });
      }
    });
    _t2 = Timer(const Duration(seconds: 9), () {
      if (!mounted) return;
      final c = PauseScope.of(context);
      final vip = c.activeVips.isEmpty ? null : c.activeVips.first;
      setState(() {
        _banner = vip == null
            ? 'A call is coming through.'
            : '${vip.name} is calling.';
        _isCall = true;
      });
    });
  }

  @override
  void dispose() {
    _t1?.cancel();
    _t2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = PauseScope.of(context);
    final paused = c.status == RestStatus.paused;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SkyBackdrop(
            asset: paused
                ? 'assets/images/sunrise_sky.png'
                : 'assets/images/dusk_sky.png',
            darken: 0.22,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 18),
              child: Column(
                children: [
                  _StatusRow(paused: paused),
                  if (_banner != null) ...[
                    const SizedBox(height: 14),
                    _Banner(
                      text: _banner!,
                      isCall: _isCall,
                      onDismiss: () => setState(() => _banner = null),
                    ),
                  ],
                  const Spacer(),
                  Text(
                    paused ? 'Paused' : 'Pause',
                    style: const TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 56,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    c.intention.phrase,
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontStyle: FontStyle.italic,
                      fontSize: 20,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    c.remainingLabel,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    c.quietPromptAt(DateTime.now()),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                  const Spacer(),
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
                'This stays on your phone. Friction, not a lock.',
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

class _Banner extends StatelessWidget {
  const _Banner({
    required this.text,
    required this.isCall,
    required this.onDismiss,
  });

  final String text;
  final bool isCall;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isCall ? Colors.white : Colors.white.withValues(alpha: 0.16),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onDismiss,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                isCall ? Icons.call : Icons.block,
                color: isCall ? PauseColors.ink : Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    color: isCall ? PauseColors.ink : Colors.white,
                  ),
                ),
              ),
              Text(
                isCall ? 'Answer' : 'Quiet',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: isCall
                      ? const Color(0xFF3D8B6E)
                      : Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
        Text(
          c.activeVips.isEmpty
              ? c.promiseLine
              : '${c.activeVips.map((v) => v.name).join(', ')} can still reach you',
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
    final note = TextEditingController(text: c.weeklyNote);
    return Scaffold(
      backgroundColor: PauseColors.cream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
          children: [
            Text(
              perfect ? 'You kept the day' : 'You finished your Pause',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 34,
                height: 1.15,
                color: PauseColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              c.intention.detail,
              textAlign: TextAlign.center,
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
                'You paused ${c.breaks.length} ${c.breaks.length == 1 ? 'time' : 'times'}. That note stays here.',
              ),
              for (final b in c.breaks)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(b.reason),
                  subtitle: Text(DateFormat.jm().format(b.at)),
                ),
            ],
            const SizedBox(height: 22),
            const Text(
              'A note to yourself',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: note,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'What was the day actually like?',
                border: OutlineInputBorder(),
              ),
              onChanged: c.setWeeklyNote,
            ),
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

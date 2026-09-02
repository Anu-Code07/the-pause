import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 40),
          children: [
            const Text(
              'Pause',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 34,
                height: 1.05,
                fontWeight: FontWeight.w500,
                color: PauseColors.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              c.autoStart
                  ? 'Starts on its own · ${c.nextStartLine}'
                  : c.nextStartLine,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: PauseColors.stone,
              ),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: SizedBox(
                height: 300,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/dusk_sky.png',
                      fit: BoxFit.cover,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.04),
                            Colors.black.withValues(alpha: 0.42),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.remainingUntilRestLabel,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.92),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            c.intention.phrase,
                            style: const TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 34,
                              height: 1.05,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            c.promiseLine,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 54,
              child: FilledButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  c.startRest();
                },
                child: const Text('Begin now'),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Who still reaches you',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 22,
                color: PauseColors.ink,
              ),
            ),
            const SizedBox(height: 10),
            _WhiteCard(
              child: Column(
                children: [
                  for (final vip in c.activeVips)
                    _QuietRow(
                      leading: PersonDot(
                        initials: vip.initials,
                        tint: vip.tint,
                        radius: 14,
                      ),
                      title: vip.name,
                      subtitle: vip.relation,
                    ),
                  for (final line in c.activeLifelines)
                    _QuietRow(
                      leading: Icon(line.icon, size: 20, color: PauseColors.ink),
                      title: line.name,
                      subtitle: line.subtitle,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _WhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Goes quiet',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      color: PauseColors.ink,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final app in c.blockedApps)
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: app.tint,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Icon(app.icon, size: 15, color: Colors.white),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WhiteCard extends StatelessWidget {
  const _WhiteCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: PauseShadows.soft,
          border: Border.all(color: PauseColors.hairline),
        ),
        child: child,
      ),
    );
  }
}

class _QuietRow extends StatelessWidget {
  const _QuietRow({
    required this.leading,
    required this.title,
    required this.subtitle,
  });

  final Widget leading;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    color: PauseColors.ink,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: PauseColors.stone,
                  ),
                ),
              ],
            ),
          ),
        ],
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
    final until = DateFormat('h:mma')
        .format(c.restEndsAt ?? DateTime.now())
        .toLowerCase()
        .replaceAll(' ', '');

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SkyBackdrop(
            asset: paused
                ? 'assets/images/sunrise_sky.png'
                : 'assets/images/dusk_sky.png',
            darken: paused ? 0.18 : 0.08,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 22),
              child: Column(
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    children: [
                      Text(
                        paused ? 'Open until' : 'Blocking',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.92),
                        ),
                      ),
                      for (final app in c.blockedApps.take(4))
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: app.tint,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(app.icon, size: 12, color: Colors.white),
                        ),
                      Text(
                        'until $until',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.92),
                        ),
                      ),
                    ],
                  ),
                  if (_banner != null) ...[
                    const SizedBox(height: 14),
                    _Banner(
                      text: _banner!,
                      isCall: _isCall,
                      onDismiss: () => setState(() => _banner = null),
                    ),
                  ],
                  const Spacer(flex: 3),
                  Text(
                    paused ? 'Paused' : 'Pause',
                    style: const TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 72,
                      height: 0.95,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    c.remainingLabel,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      letterSpacing: 0.4,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(flex: 4),
                  if (paused)
                    FilledButton(
                      onPressed: c.resumeRest,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: PauseColors.ink,
                        minimumSize: const Size.fromHeight(54),
                      ),
                      child: const Text('Return to rest'),
                    )
                  else
                    SlideToPause(
                      label: 'slide to pause',
                      onCompleted: () => _askReason(context),
                    ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: c.completeRest,
                    child: Text(
                      'End this Pause',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.62),
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
      backgroundColor: Colors.white,
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
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: c.dismissRecap,
                icon: const Icon(Icons.close, color: PauseColors.ink),
              ),
            ),
            Text(
              perfect ? 'You kept the day' : 'You finished your Pause',
              style: const TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 34,
                height: 1.12,
                fontWeight: FontWeight.w500,
                color: PauseColors.ink,
              ),
            ),
            const SizedBox(height: 18),
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
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: PauseShadows.soft,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'A note to yourself',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 20,
                      color: PauseColors.ink,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: note,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'What was the day actually like?',
                    ),
                    onChanged: c.setWeeklyNote,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: 54,
              child: FilledButton(
                onPressed: c.dismissRecap,
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

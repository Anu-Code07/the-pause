import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../state/pause_controller.dart';
import '../../theme/pause_theme.dart';
import '../../widgets/phone_window.dart';
import '../../widgets/select_tile.dart';
import '../../widgets/sky_backdrop.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _page = PageController();
  int _index = 0;

  static const _last = 3;

  void _next() {
    if (_index >= _last) {
      PauseScope.of(context).finishOnboarding();
      return;
    }
    _page.nextPage(
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cream = _index >= 1;
    return Scaffold(
      backgroundColor: cream ? PauseColors.cream : Colors.black,
      body: Stack(
        children: [
          PageView(
            controller: _page,
            onPageChanged: (i) => setState(() => _index = i),
            children: const [
              _SacredDayPage(),
              _DayPage(),
              _DealPage(),
              _BeginPage(),
            ],
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 28,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Dots(count: _last + 1, index: _index, light: !cream),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton(
                      key: const Key('onboarding-continue'),
                      onPressed: _next,
                      style: FilledButton.styleFrom(
                        backgroundColor: cream ? PauseColors.ink : Colors.white,
                        foregroundColor: cream ? Colors.white : PauseColors.ink,
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        _index == _last ? 'Begin' : 'Continue',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
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
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index, required this.light});

  final int count;
  final int index;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final on = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: on ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: (light ? Colors.white : PauseColors.ink)
                .withValues(alpha: on ? 1 : 0.28),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}

class _SacredDayPage extends StatelessWidget {
  const _SacredDayPage();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const SkyBackdrop(asset: 'assets/images/dusk_sky.png', darken: 0.08),
        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 22),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 28),
                child: Text(
                  'Reclaim your\nsacred day',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 40,
                    height: 1.08,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Put the phone down one day a week.\nYour people still get through.\nInstagram doesn’t.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  height: 1.4,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: OverflowBox(
                  maxHeight: 720,
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 64),
                    child: PhoneWindow(
                      child: Image.asset(
                        'assets/images/onboarding/eat_slowly.png',
                        fit: BoxFit.cover,
                        alignment: const Alignment(0, 0.2),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DayPage extends StatelessWidget {
  const _DayPage();

  @override
  Widget build(BuildContext context) {
    final c = PauseScope.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 140),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your sacred day',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 34,
                height: 1.1,
                color: PauseColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sundown to sundown. It starts on its own. You don’t have to remember.',
            ),
            const SizedBox(height: 22),
            _DayCard(
              title: 'Saturday',
              subtitle: 'Begins Friday at ${c.sundownLabel}.',
              selected: c.restDay == RestDay.saturday,
              onTap: () => c.setRestDay(RestDay.saturday),
            ),
            const SizedBox(height: 12),
            _DayCard(
              title: 'Sunday',
              subtitle: 'Begins Saturday at ${c.sundownLabel}.',
              selected: c.restDay == RestDay.sunday,
              onTap: () => c.setRestDay(RestDay.sunday),
            ),
            const Spacer(),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Start automatically'),
              subtitle: Text('Every week at ${c.sundownLabel}.'),
              value: c.autoStart,
              onChanged: c.setAutoStart,
            ),
          ],
        ),
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected ? PauseColors.ink : PauseColors.paper,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? PauseColors.ink : PauseColors.mist,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 26,
                color: selected ? Colors.white : PauseColors.ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Inter',
                color: selected
                    ? Colors.white.withValues(alpha: 0.72)
                    : PauseColors.stone,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DealPage extends StatelessWidget {
  const _DealPage();

  @override
  Widget build(BuildContext context) {
    final c = PauseScope.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 140),
        child: ListView(
          children: [
            const Text(
              'Who still\nreaches you',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 34,
                height: 1.1,
                color: PauseColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Rest is not a blackout. Mom can call. Slack DMs can wait in peace. Instagram cannot.',
            ),
            const SizedBox(height: 18),
            const Text(
              'Lifelines',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            for (final line in Catalog.lifelines) ...[
              SelectTile(
                label: line.name,
                subtitle: line.subtitle,
                selected: c.lifelineIds.contains(line.id),
                onTap: () => c.toggleLifeline(line.id),
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: line.tint,
                  child: Icon(line.icon, color: Colors.white, size: 16),
                ),
              ),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 10),
            const Text(
              'These people still ring',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            for (final vip in Catalog.vips) ...[
              SelectTile(
                label: vip.name,
                subtitle: vip.relation,
                selected: c.vipIds.contains(vip.id),
                onTap: () => c.toggleVip(vip.id),
                leading: PersonDot(initials: vip.initials, tint: vip.tint, radius: 16),
              ),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 10),
            const Text(
              'These go quiet',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final app in Catalog.apps)
                  FilterChip(
                    label: Text(app.name),
                    avatar: Icon(app.icon, size: 16, color: Colors.white),
                    selected: c.blockedAppIds.contains(app.id),
                    onSelected: (_) => c.toggleApp(app.id),
                    selectedColor: PauseColors.ink,
                    labelStyle: TextStyle(
                      color: c.blockedAppIds.contains(app.id)
                          ? Colors.white
                          : PauseColors.ink,
                    ),
                    checkmarkColor: Colors.white,
                    backgroundColor: PauseColors.paper,
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

class _BeginPage extends StatelessWidget {
  const _BeginPage();

  @override
  Widget build(BuildContext context) {
    final c = PauseScope.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 140),
        child: ListView(
          children: [
            const Text(
              'How do you want\nto keep the day?',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 32,
                height: 1.1,
                color: PauseColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Starts ${c.nextStartLine}. ${c.promiseLine}',
            ),
            const SizedBox(height: 18),
            for (final item in Catalog.intentions) ...[
              InkWell(
                onTap: () => c.setIntention(item.id),
                borderRadius: BorderRadius.circular(18),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 92,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: c.intentionId == item.id
                          ? PauseColors.ink
                          : Colors.transparent,
                      width: 2,
                    ),
                    image: DecorationImage(
                      image: AssetImage(item.image),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withValues(alpha: 0.35),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    item.phrase,
                    style: const TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

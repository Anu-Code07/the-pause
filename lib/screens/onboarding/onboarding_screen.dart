import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../state/pause_controller.dart';
import '../../theme/pause_theme.dart';
import '../../widgets/phone_window.dart';
import '../../widgets/sky_backdrop.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _page = PageController();
  int _index = 0;

  static const _last = 6;

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
    final cream = _index >= 4;
    return Scaffold(
      backgroundColor: cream ? PauseColors.cream : Colors.black,
      body: Stack(
        children: [
          PageView(
            controller: _page,
            onPageChanged: (i) => setState(() => _index = i),
            children: const [
              _PhotoPage(asset: 'assets/images/onboarding/eat_slowly.png'),
              _PhotoPage(asset: 'assets/images/onboarding/be_present.png'),
              _PhotoPage(asset: 'assets/images/onboarding/people.png'),
              _SkyPhonePage(),
              _DayPage(),
              _AppsPage(),
              _LifelinesPage(),
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

class _PhotoPage extends StatelessWidget {
  const _PhotoPage({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(asset, fit: BoxFit.cover),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.transparent, Color(0x99000000)],
              stops: [0, 0.62, 1],
            ),
          ),
        ),
      ],
    );
  }
}

class _SkyPhonePage extends StatelessWidget {
  const _SkyPhonePage();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const SkyBackdrop(asset: 'assets/images/dusk_sky.png', darken: 0.05),
        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 28),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 28),
                child: Text(
                  'Reclaim your\nsacred day',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 42,
                    height: 1.08,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'A modern app for an ancient practice.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white.withValues(alpha: 0.82),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: OverflowBox(
                  maxHeight: 720,
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 52),
                    child: PhoneWindow(
                      child: Image.asset(
                        'assets/images/dusk_sky.png',
                        fit: BoxFit.cover,
                        alignment: const Alignment(0, 0.35),
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
              'Choose your day',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 36,
                height: 1.1,
                color: PauseColors.ink,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Sundown to sundown. Saturday or Sunday — the rest of the week stays yours.',
            ),
            const SizedBox(height: 28),
            _DayCard(
              title: 'Saturday',
              subtitle: 'The older rhythm.',
              selected: c.restDay == RestDay.saturday,
              onTap: () => c.setRestDay(RestDay.saturday),
            ),
            const SizedBox(height: 12),
            _DayCard(
              title: 'Sunday',
              subtitle: 'A quiet close to the week.',
              selected: c.restDay == RestDay.sunday,
              onTap: () => c.setRestDay(RestDay.sunday),
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

class _AppsPage extends StatelessWidget {
  const _AppsPage();

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
              'What pulls you away',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 34,
                height: 1.1,
                color: PauseColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            const Text('These go quiet for one day. Everything else still works.'),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.55,
                children: [
                  for (final app in Catalog.apps)
                    _SelectTile(
                      icon: app.icon,
                      tint: app.tint,
                      label: app.name,
                      selected: c.blockedAppIds.contains(app.id),
                      onTap: () => c.toggleApp(app.id),
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

class _LifelinesPage extends StatelessWidget {
  const _LifelinesPage();

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
              'What still\nreaches you',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 34,
                height: 1.1,
                color: PauseColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Rest is not a blackout. Keep calls, messages, and the work pings that actually matter.',
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  for (final line in Catalog.lifelines) ...[
                    _SelectTile(
                      icon: line.icon,
                      tint: line.tint,
                      label: line.name,
                      subtitle: line.subtitle,
                      selected: c.lifelineIds.contains(line.id),
                      onTap: () => c.toggleLifeline(line.id),
                      wide: true,
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectTile extends StatelessWidget {
  const _SelectTile({
    required this.icon,
    required this.tint,
    required this.label,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.wide = false,
  });

  final IconData icon;
  final Color tint;
  final String label;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? PauseColors.ink : PauseColors.paper,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: EdgeInsets.all(wide ? 16 : 14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: tint,
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : PauseColors.ink,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          height: 1.3,
                          color: selected
                              ? Colors.white.withValues(alpha: 0.7)
                              : PauseColors.stone,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                selected ? Icons.check_rounded : Icons.add_rounded,
                color: selected ? Colors.white : PauseColors.stone,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

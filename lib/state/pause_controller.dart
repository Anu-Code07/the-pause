import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';

class PauseController extends ChangeNotifier {
  PauseController();

  bool onboardingComplete = false;
  String name = 'You';
  RestDay restDay = RestDay.sunday;
  bool autoStart = true;
  int sundownHour = 19;
  String intentionId = 'eat';
  String weeklyNote = '';

  final Set<String> blockedAppIds = {'instagram', 'tiktok', 'x', 'youtube'};
  final Set<String> lifelineIds = {'phone', 'messages', 'slack'};
  final Set<String> vipIds = {'mom', 'jordan'};

  List<WeekdayBlock> blocks = List.of(Catalog.blocks);

  RestStatus status = RestStatus.upcoming;
  DateTime? restStartedAt;
  DateTime? restEndsAt;
  DateTime? pauseEndsAt;
  DateTime? completedWindowEnd;
  final List<PauseBreak> breaks = [];
  int streak = 3;
  int completedCount = 3;

  int timerMinutes = 20;
  DateTime? timerEndsAt;
  bool timerRunning = false;

  Timer? _ticker;

  List<DistractingApp> get blockedApps =>
      Catalog.apps.where((a) => blockedAppIds.contains(a.id)).toList();

  List<Lifeline> get activeLifelines =>
      Catalog.lifelines.where((l) => lifelineIds.contains(l.id)).toList();

  List<VipPerson> get activeVips =>
      Catalog.vips.where((v) => vipIds.contains(v.id)).toList();

  DayIntention get intention => Catalog.intentions.firstWhere(
        (i) => i.id == intentionId,
        orElse: () => Catalog.intentions.first,
      );

  String get restDayLabel =>
      restDay == RestDay.saturday ? 'Saturday' : 'Sunday';

  String get sundownLabel {
    final hour = sundownHour % 12 == 0 ? 12 : sundownHour % 12;
    final suffix = sundownHour >= 12 ? 'pm' : 'am';
    return '$hour:00$suffix';
  }

  int get _startWeekday =>
      restDay == RestDay.saturday ? DateTime.friday : DateTime.saturday;

  DateTime _atSundownOn(DateTime day) =>
      DateTime(day.year, day.month, day.day, sundownHour);

  DateTime get nextRestStart {
    final now = DateTime.now();
    var day = DateTime(now.year, now.month, now.day);
    for (var i = 0; i < 14; i++) {
      if (day.weekday == _startWeekday) {
        final start = _atSundownOn(day);
        if (start.isAfter(now)) return start;
      }
      day = day.add(const Duration(days: 1));
    }
    return _atSundownOn(now.add(const Duration(days: 7)));
  }

  DateTime? get currentWindowEnd {
    final now = DateTime.now();
    var day = DateTime(now.year, now.month, now.day);
    for (var i = 0; i < 8; i++) {
      if (day.weekday == _startWeekday) {
        final start = _atSundownOn(day);
        final end = start.add(const Duration(hours: 24));
        if (!now.isBefore(start) && now.isBefore(end)) return end;
      }
      day = day.subtract(const Duration(days: 1));
    }
    return null;
  }

  bool get inRestWindow => currentWindowEnd != null;

  bool get isResting =>
      status == RestStatus.active || status == RestStatus.paused;

  Duration get remaining {
    final end = status == RestStatus.paused ? pauseEndsAt : restEndsAt;
    if (end == null) return Duration.zero;
    final d = end.difference(DateTime.now());
    return d.isNegative ? Duration.zero : d;
  }

  String get remainingLabel {
    final d = remaining;
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h > 0) return '${h}h ${m}m left';
    if (m > 0) return '${m}m left';
    return '${d.inSeconds}s left';
  }

  String get timerLabel {
    if (timerEndsAt == null) {
      final m = timerMinutes;
      return '${m.toString().padLeft(2, '0')}:00';
    }
    final d = timerEndsAt!.difference(DateTime.now());
    final left = d.isNegative ? Duration.zero : d;
    final m = left.inMinutes;
    final s = left.inSeconds.remainder(60);
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  int get daysUntilRest {
    final start = nextRestStart;
    final now = DateTime.now();
    return DateTime(start.year, start.month, start.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays
        .clamp(0, 14);
  }

  String get remainingUntilRestLabel {
    final until = nextRestStart.difference(DateTime.now());
    if (until.inHours >= 24) {
      final days = until.inHours ~/ 24;
      return days == 1 ? '1 day until rest' : '$days days until rest';
    }
    if (until.inHours >= 1) {
      return '${until.inHours}h ${until.inMinutes.remainder(60)}m until rest';
    }
    return '${until.inMinutes}m until rest';
  }

  String get nextStartLine {
    final start = nextRestStart;
    final days = daysUntilRest;
    if (days == 0) return 'Tonight at $sundownLabel';
    if (days == 1) return 'Tomorrow at $sundownLabel';
    const names = [
      '',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return '${names[start.weekday]} at $sundownLabel';
  }

  String get promiseLine =>
      'Your people still get through. Instagram doesn’t.';

  Future<void> hydrate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      onboardingComplete = prefs.getBool('onboarding') ?? false;
      name = prefs.getString('name') ?? name;
      restDay = prefs.getString('restDay') == 'saturday'
          ? RestDay.saturday
          : RestDay.sunday;
      autoStart = prefs.getBool('autoStart') ?? true;
      sundownHour = prefs.getInt('sundownHour') ?? 19;
      intentionId = prefs.getString('intention') ?? intentionId;
      weeklyNote = prefs.getString('weeklyNote') ?? '';
      final apps = prefs.getStringList('apps');
      if (apps != null && apps.isNotEmpty) {
        blockedAppIds
          ..clear()
          ..addAll(apps);
      }
      final lines = prefs.getStringList('lifelines');
      if (lines != null) {
        lifelineIds
          ..clear()
          ..addAll(lines);
      }
      final vips = prefs.getStringList('vips');
      if (vips != null) {
        vipIds
          ..clear()
          ..addAll(vips);
      }
      final enabledBlocks = prefs.getStringList('blocks') ?? [];
      blocks = [
        for (final b in Catalog.blocks)
          b.copyWith(enabled: enabledBlocks.contains(b.id)),
      ];
      _ensureTicker();
      maybeAutoStart();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding', onboardingComplete);
      await prefs.setString('name', name);
      await prefs.setString(
        'restDay',
        restDay == RestDay.saturday ? 'saturday' : 'sunday',
      );
      await prefs.setBool('autoStart', autoStart);
      await prefs.setInt('sundownHour', sundownHour);
      await prefs.setString('intention', intentionId);
      await prefs.setString('weeklyNote', weeklyNote);
      await prefs.setStringList('apps', blockedAppIds.toList());
      await prefs.setStringList('lifelines', lifelineIds.toList());
      await prefs.setStringList('vips', vipIds.toList());
      await prefs.setStringList(
        'blocks',
        blocks.where((b) => b.enabled).map((b) => b.id).toList(),
      );
    } catch (_) {}
  }

  void setName(String value) {
    name = value.trim().isEmpty ? 'You' : value.trim();
    _persist();
    notifyListeners();
  }

  void setRestDay(RestDay day) {
    restDay = day;
    _persist();
    notifyListeners();
  }

  void setAutoStart(bool value) {
    autoStart = value;
    _persist();
    notifyListeners();
    if (value) maybeAutoStart();
  }

  void setSundownHour(int hour) {
    sundownHour = hour.clamp(16, 21);
    _persist();
    notifyListeners();
  }

  void setIntention(String id) {
    intentionId = id;
    _persist();
    notifyListeners();
  }

  void setWeeklyNote(String value) {
    weeklyNote = value;
    _persist();
    notifyListeners();
  }

  void toggleLifeline(String id) {
    if (lifelineIds.contains(id)) {
      lifelineIds.remove(id);
    } else {
      lifelineIds.add(id);
    }
    _persist();
    notifyListeners();
  }

  void toggleVip(String id) {
    if (vipIds.contains(id)) {
      vipIds.remove(id);
    } else {
      vipIds.add(id);
    }
    _persist();
    notifyListeners();
  }

  void toggleApp(String id) {
    if (blockedAppIds.contains(id)) {
      if (blockedAppIds.length > 1) blockedAppIds.remove(id);
    } else {
      blockedAppIds.add(id);
    }
    _persist();
    notifyListeners();
  }

  void finishOnboarding() {
    onboardingComplete = true;
    _persist();
    _ensureTicker();
    maybeAutoStart();
    notifyListeners();
  }

  void resetOnboarding() {
    onboardingComplete = false;
    status = RestStatus.upcoming;
    restStartedAt = null;
    restEndsAt = null;
    _persist();
    notifyListeners();
  }

  void maybeAutoStart() {
    if (!autoStart || !onboardingComplete) return;
    if (status != RestStatus.upcoming) return;
    if (!inRestWindow) return;
    if (completedWindowEnd != null &&
        completedWindowEnd!.isAfter(DateTime.now())) {
      return;
    }
    startRest();
  }

  void startRest({Duration? duration}) {
    status = RestStatus.active;
    restStartedAt = DateTime.now();
    final windowEnd = currentWindowEnd;
    restEndsAt = DateTime.now().add(
      duration ??
          (windowEnd != null
              ? windowEnd.difference(DateTime.now())
              : const Duration(hours: 24)),
    );
    if (!restEndsAt!.isAfter(DateTime.now())) {
      restEndsAt = DateTime.now().add(const Duration(hours: 24));
    }
    pauseEndsAt = null;
    breaks.clear();
    _ensureTicker();
    notifyListeners();
  }

  void takeBreak(String reason) {
    if (status != RestStatus.active) return;
    breaks.add(PauseBreak(reason: reason, at: DateTime.now()));
    status = RestStatus.paused;
    pauseEndsAt = DateTime.now().add(const Duration(minutes: 15));
    notifyListeners();
  }

  void resumeRest() {
    if (status != RestStatus.paused) return;
    status = RestStatus.active;
    pauseEndsAt = null;
    notifyListeners();
  }

  void completeRest() {
    if (!isResting) return;
    status = RestStatus.finished;
    pauseEndsAt = null;
    completedWindowEnd = restEndsAt ?? currentWindowEnd;
    if (breaks.isEmpty) streak += 1;
    completedCount += 1;
    notifyListeners();
  }

  void dismissRecap() {
    status = RestStatus.upcoming;
    restStartedAt = null;
    restEndsAt = null;
    notifyListeners();
  }

  void toggleBlock(String id) {
    blocks = [
      for (final b in blocks)
        if (b.id == id) b.copyWith(enabled: !b.enabled) else b,
    ];
    _persist();
    notifyListeners();
  }

  void bumpTimer(int delta) {
    timerMinutes = (timerMinutes + delta).clamp(5, 180);
    notifyListeners();
  }

  void startTimer() {
    timerRunning = true;
    timerEndsAt = DateTime.now().add(Duration(minutes: timerMinutes));
    _ensureTicker();
    notifyListeners();
  }

  void cancelTimer() {
    timerRunning = false;
    timerEndsAt = null;
    notifyListeners();
  }

  String quietPromptAt(DateTime now) {
    final i = now.minute % Catalog.quietPrompts.length;
    return Catalog.quietPrompts[i];
  }

  void _ensureTicker() {
    _ticker ??= Timer.periodic(const Duration(seconds: 1), (_) {
      maybeAutoStart();
      if (status == RestStatus.active && remaining == Duration.zero) {
        completeRest();
      } else if (status == RestStatus.paused && remaining == Duration.zero) {
        resumeRest();
      } else if (timerRunning &&
          timerEndsAt != null &&
          !timerEndsAt!.isAfter(DateTime.now())) {
        timerRunning = false;
        timerEndsAt = null;
        notifyListeners();
      } else if (isResting || timerRunning) {
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}

class PauseScope extends InheritedNotifier<PauseController> {
  const PauseScope({
    super.key,
    required PauseController controller,
    required super.child,
  }) : super(notifier: controller);

  static PauseController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<PauseScope>();
    assert(scope != null, 'PauseScope not found');
    return scope!.notifier!;
  }
}

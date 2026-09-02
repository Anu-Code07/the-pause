import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';

class PauseController extends ChangeNotifier {
  PauseController();

  bool onboardingComplete = false;
  String name = 'You';
  RestDay restDay = RestDay.sunday;
  final Set<String> blockedAppIds = {'instagram', 'tiktok', 'x', 'youtube'};
  final Set<String> lifelineIds = {'phone', 'messages', 'slack'};
  List<CircleFriend> friends = List.of(Catalog.friends);
  List<WeekdayBlock> blocks = List.of(Catalog.blocks);

  RestStatus status = RestStatus.upcoming;
  DateTime? restStartedAt;
  DateTime? restEndsAt;
  DateTime? pauseEndsAt;
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

  String get restDayLabel =>
      restDay == RestDay.saturday ? 'Saturday' : 'Sunday';

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
    final now = DateTime.now();
    final targetWeekday = restDay == RestDay.saturday
        ? DateTime.saturday
        : DateTime.sunday;
    var delta = (targetWeekday - now.weekday) % 7;
    if (delta == 0 && now.hour >= 18) delta = 7;
    return delta;
  }

  Future<void> hydrate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      onboardingComplete = prefs.getBool('onboarding') ?? false;
      name = prefs.getString('name') ?? name;
      restDay = prefs.getString('restDay') == 'saturday'
          ? RestDay.saturday
          : RestDay.sunday;
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
      notifyListeners();
    } catch (_) {
      // Tests and first-run can skip persistence.
    }
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
      await prefs.setStringList('apps', blockedAppIds.toList());
      await prefs.setStringList('lifelines', lifelineIds.toList());
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

  void toggleLifeline(String id) {
    if (lifelineIds.contains(id)) {
      lifelineIds.remove(id);
    } else {
      lifelineIds.add(id);
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

  void startRest({Duration duration = const Duration(hours: 24)}) {
    status = RestStatus.active;
    restStartedAt = DateTime.now();
    restEndsAt = DateTime.now().add(duration);
    pauseEndsAt = null;
    breaks.clear();
    _startTicker();
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
    if (breaks.isEmpty) streak += 1;
    completedCount += 1;
    _ticker?.cancel();
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
    notifyListeners();
  }

  void bumpTimer(int delta) {
    timerMinutes = (timerMinutes + delta).clamp(5, 180);
    notifyListeners();
  }

  void startTimer() {
    timerRunning = true;
    timerEndsAt = DateTime.now().add(Duration(minutes: timerMinutes));
    _startTicker();
    notifyListeners();
  }

  void cancelTimer() {
    timerRunning = false;
    timerEndsAt = null;
    notifyListeners();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
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
      } else {
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

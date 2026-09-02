import 'package:flutter/material.dart';

enum RestDay { saturday, sunday }

enum RestStatus { upcoming, active, paused, finished }

class DistractingApp {
  const DistractingApp({
    required this.id,
    required this.name,
    required this.icon,
    required this.tint,
    this.category = 'Social',
  });

  final String id;
  final String name;
  final IconData icon;
  final Color tint;
  final String category;
}

class CircleFriend {
  const CircleFriend({
    required this.id,
    required this.name,
    required this.initials,
    required this.tint,
    this.isResting = false,
    this.pauses = 0,
    this.pauseReason,
    this.finished = false,
    this.hours = 24,
  });

  final String id;
  final String name;
  final String initials;
  final Color tint;
  final bool isResting;
  final int pauses;
  final String? pauseReason;
  final bool finished;
  final int hours;

  CircleFriend copyWith({
    bool? isResting,
    int? pauses,
    String? pauseReason,
    bool? finished,
  }) {
    return CircleFriend(
      id: id,
      name: name,
      initials: initials,
      tint: tint,
      isResting: isResting ?? this.isResting,
      pauses: pauses ?? this.pauses,
      pauseReason: pauseReason ?? this.pauseReason,
      finished: finished ?? this.finished,
      hours: hours,
    );
  }
}

class PauseBreak {
  const PauseBreak({required this.reason, required this.at});

  final String reason;
  final DateTime at;
}

class Lifeline {
  const Lifeline({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.tint,
  });

  final String id;
  final String name;
  final String subtitle;
  final IconData icon;
  final Color tint;
}

class WeekdayBlock {
  const WeekdayBlock({
    required this.id,
    required this.title,
    required this.when,
    required this.imageAsset,
    this.enabled = false,
  });

  final String id;
  final String title;
  final String when;
  final String imageAsset;
  final bool enabled;

  WeekdayBlock copyWith({bool? enabled}) {
    return WeekdayBlock(
      id: id,
      title: title,
      when: when,
      imageAsset: imageAsset,
      enabled: enabled ?? this.enabled,
    );
  }
}

class Catalog {
  static const apps = <DistractingApp>[
    DistractingApp(
      id: 'instagram',
      name: 'Instagram',
      icon: Icons.camera_alt_rounded,
      tint: Color(0xFFE1306C),
    ),
    DistractingApp(
      id: 'tiktok',
      name: 'TikTok',
      icon: Icons.music_note_rounded,
      tint: Color(0xFF111111),
    ),
    DistractingApp(
      id: 'x',
      name: 'X',
      icon: Icons.close_rounded,
      tint: Color(0xFF111111),
    ),
    DistractingApp(
      id: 'youtube',
      name: 'YouTube',
      icon: Icons.play_arrow_rounded,
      tint: Color(0xFFFF0000),
      category: 'Video',
    ),
    DistractingApp(
      id: 'facebook',
      name: 'Facebook',
      icon: Icons.facebook_rounded,
      tint: Color(0xFF1877F2),
    ),
    DistractingApp(
      id: 'linkedin',
      name: 'LinkedIn',
      icon: Icons.work_rounded,
      tint: Color(0xFF0A66C2),
      category: 'Work',
    ),
    DistractingApp(
      id: 'reddit',
      name: 'Reddit',
      icon: Icons.reddit,
      tint: Color(0xFFFF4500),
    ),
    DistractingApp(
      id: 'slack',
      name: 'Slack',
      icon: Icons.tag_rounded,
      tint: Color(0xFF4A154B),
      category: 'Work',
    ),
  ];

  static const lifelines = <Lifeline>[
    Lifeline(
      id: 'phone',
      name: 'Calls',
      subtitle: 'Family and starred contacts still ring.',
      icon: Icons.call_rounded,
      tint: Color(0xFF3D8B6E),
    ),
    Lifeline(
      id: 'messages',
      name: 'Messages',
      subtitle: 'Texts from people you choose still come through.',
      icon: Icons.chat_bubble_rounded,
      tint: Color(0xFF4C7A9E),
    ),
    Lifeline(
      id: 'slack',
      name: 'Slack',
      subtitle: 'DMs and @mentions only. Channels stay quiet.',
      icon: Icons.tag_rounded,
      tint: Color(0xFF4A154B),
    ),
    Lifeline(
      id: 'maps',
      name: 'Maps',
      subtitle: 'In case you need to get somewhere.',
      icon: Icons.map_rounded,
      tint: Color(0xFFC47A6A),
    ),
  ];

  static const friends = <CircleFriend>[
    CircleFriend(
      id: 'maya',
      name: 'Maya',
      initials: 'M',
      tint: Color(0xFFC47A6A),
      isResting: true,
    ),
    CircleFriend(
      id: 'ben',
      name: 'Ben',
      initials: 'B',
      tint: Color(0xFF6E849E),
      isResting: true,
    ),
    CircleFriend(
      id: 'sky',
      name: 'Sky',
      initials: 'S',
      tint: Color(0xFFD4A574),
      isResting: true,
    ),
    CircleFriend(
      id: 'vlad',
      name: 'Vlad',
      initials: 'V',
      tint: Color(0xFF4A5D4E),
      finished: true,
    ),
    CircleFriend(
      id: 'noor',
      name: 'Noor',
      initials: 'N',
      tint: Color(0xFF8B6B9E),
      pauses: 1,
      pauseReason: 'Needed maps',
      finished: true,
    ),
  ];

  static const blocks = <WeekdayBlock>[
    WeekdayBlock(
      id: 'morning',
      title: 'Calm Morning',
      when: 'Weekdays, 6am – 8am',
      imageAsset: 'assets/images/texture_morning.png',
    ),
    WeekdayBlock(
      id: 'work',
      title: 'Deep Work',
      when: 'Weekdays, 9am – 12pm',
      imageAsset: 'assets/images/texture_work.png',
    ),
    WeekdayBlock(
      id: 'family',
      title: 'Family Dinner',
      when: 'Weekdays, 5pm – 7pm',
      imageAsset: 'assets/images/texture_family.png',
    ),
    WeekdayBlock(
      id: 'wind',
      title: 'Wind Down',
      when: 'Weekdays, 9pm – 12am',
      imageAsset: 'assets/images/sunrise_sky.png',
    ),
    WeekdayBlock(
      id: 'sleep',
      title: 'Peaceful Sleep',
      when: 'Weekdays, 10pm – 6am',
      imageAsset: 'assets/images/texture_sleep.png',
    ),
  ];
}

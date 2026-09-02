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

class VipPerson {
  const VipPerson({
    required this.id,
    required this.name,
    required this.relation,
    required this.initials,
    required this.tint,
  });

  final String id;
  final String name;
  final String relation;
  final String initials;
  final Color tint;
}

class DayIntention {
  const DayIntention({
    required this.id,
    required this.phrase,
    required this.detail,
    required this.image,
  });

  final String id;
  final String phrase;
  final String detail;
  final String image;
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

  static const vips = <VipPerson>[
    VipPerson(
      id: 'mom',
      name: 'Mom',
      relation: 'Family · always rings',
      initials: 'M',
      tint: Color(0xFFC47A6A),
    ),
    VipPerson(
      id: 'jordan',
      name: 'Jordan',
      relation: 'Partner',
      initials: 'J',
      tint: Color(0xFF6E849E),
    ),
    VipPerson(
      id: 'leo',
      name: 'Leo',
      relation: 'Kid',
      initials: 'L',
      tint: Color(0xFFD4A574),
    ),
    VipPerson(
      id: 'school',
      name: 'School',
      relation: 'Pickup and nurse line',
      initials: 'S',
      tint: Color(0xFF4A5D4E),
    ),
    VipPerson(
      id: 'sam',
      name: 'Sam',
      relation: 'Work · emergencies only',
      initials: 'SA',
      tint: Color(0xFF4A154B),
    ),
  ];

  static const intentions = <DayIntention>[
    DayIntention(
      id: 'eat',
      phrase: 'to eat slowly',
      detail: 'Stay at the table. Let the dishes wait.',
      image: 'assets/images/onboarding/eat_slowly.png',
    ),
    DayIntention(
      id: 'present',
      phrase: 'to be present',
      detail: 'Be in the room you’re already in.',
      image: 'assets/images/onboarding/be_present.png',
    ),
    DayIntention(
      id: 'people',
      phrase: 'to sit together',
      detail: 'The people in front of you are the point.',
      image: 'assets/images/onboarding/people.png',
    ),
    DayIntention(
      id: 'day',
      phrase: 'to keep the day',
      detail: 'One sundown to the next. Nothing clever.',
      image: 'assets/images/onboarding/one_day.png',
    ),
  ];

  static const quietPrompts = <String>[
    'They’re in the other room.',
    'The dishes can wait.',
    'Nobody needs a photo of this.',
    'A walk is enough.',
    'You already have the people.',
    'Leave the phone face down.',
  ];
}

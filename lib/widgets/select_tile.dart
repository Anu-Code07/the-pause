import 'package:flutter/material.dart';

import '../theme/pause_theme.dart';

class SelectTile extends StatelessWidget {
  const SelectTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.leading,
  });

  final String label;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? PauseColors.ink : PauseColors.paper,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 12)],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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

class PersonDot extends StatelessWidget {
  const PersonDot({
    super.key,
    required this.initials,
    required this.tint,
    this.radius = 20,
  });

  final String initials;
  final Color tint;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: tint,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: radius * 0.7,
        ),
      ),
    );
  }
}

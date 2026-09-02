import 'package:flutter/material.dart';

import '../theme/pause_theme.dart';

class SessionCard extends StatelessWidget {
  const SessionCard({
    super.key,
    required this.count,
    required this.dateLabel,
    required this.hours,
    required this.perfect,
    this.skyAsset = 'assets/images/pale_sky.png',
  });

  final int count;
  final String dateLabel;
  final int hours;
  final bool perfect;
  final String skyAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PauseColors.paper,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SizedBox(
            height: 168,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(skyAsset, fit: BoxFit.cover),
                Center(
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 88,
                      height: 1,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pause',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: PauseColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle, size: 16, color: PauseColors.goldDeep),
                        SizedBox(width: 6),
                        Text(
                          'Finished',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            color: PauseColors.ink,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${hours}h',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: PauseColors.stone,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(
              children: [
                Text(
                  dateLabel,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: PauseColors.stone,
                  ),
                ),
              ],
            ),
          ),
          if (perfect)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFD8C08A), Color(0xFF9C7A45)],
                ),
              ),
              child: const Text(
                'Perfect Pause',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  letterSpacing: 0.6,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

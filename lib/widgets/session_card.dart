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
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: PauseShadows.soft,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SizedBox(
            height: 176,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(skyAsset, fit: BoxFit.cover),
                Center(
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 108,
                      height: 1,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.72),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pause',
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: PauseColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check, size: 16, color: PauseColors.ink),
                        SizedBox(width: 4),
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
                    const SizedBox(height: 2),
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
          if (perfect)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFD8C08A), Color(0xFF9C7A45)],
                ),
              ),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Perfect Pause',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    letterSpacing: 0.2,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

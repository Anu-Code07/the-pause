import 'package:flutter/material.dart';

import '../../state/pause_controller.dart';
import '../../theme/pause_theme.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = PauseScope.of(context);
    return Scaffold(
      backgroundColor: PauseColors.cream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
          children: [
            const Text(
              'Create schedule',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 34,
                color: PauseColors.ink,
              ),
            ),
            const SizedBox(height: 6),
            const Text('Smaller blocks during the week. The sacred day stays free.'),
            const SizedBox(height: 18),
            for (final block in c.blocks)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: PauseColors.paper,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: () => c.toggleBlock(block.id),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              block.imageAsset,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  block.title,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(block.when),
                              ],
                            ),
                          ),
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: block.enabled
                                ? PauseColors.ink
                                : PauseColors.mist,
                            child: Icon(
                              block.enabled ? Icons.check : Icons.add,
                              size: 18,
                              color: block.enabled
                                  ? Colors.white
                                  : PauseColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

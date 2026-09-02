import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../state/pause_controller.dart';
import '../../theme/pause_theme.dart';
import '../../widgets/select_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
              'You',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 36,
                color: PauseColors.ink,
              ),
            ),
            const SizedBox(height: 6),
            const Text('Everything is included. There is no plus tier.'),
            const SizedBox(height: 18),
            TextField(
              controller: TextEditingController(text: c.name),
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              onSubmitted: c.setName,
            ),
            const SizedBox(height: 18),
            _Stat(label: 'Streak', value: '${c.streak} weeks'),
            _Stat(label: 'Finished', value: '${c.completedCount} Pauses'),
            _Stat(label: 'Rest day', value: c.restDayLabel),
            _Stat(label: 'Starts', value: c.nextStartLine),
            const Divider(height: 32),
            const Text(
              'The day',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 22,
              ),
            ),
            for (final day in RestDay.values)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(day == RestDay.saturday ? 'Saturday' : 'Sunday'),
                trailing: Icon(
                  c.restDay == day
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                ),
                onTap: () => c.setRestDay(day),
              ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Sundown'),
              subtitle: Text(c.sundownLabel),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => c.setSundownHour(c.sundownHour - 1),
                    icon: const Icon(Icons.remove),
                  ),
                  IconButton(
                    onPressed: () => c.setSundownHour(c.sundownHour + 1),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Start automatically'),
              subtitle: const Text('No weekly tap. Sundown is the button.'),
              value: c.autoStart,
              onChanged: c.setAutoStart,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Household rest'),
              subtitle: const Text('Everyone at the table goes quiet together.'),
              value: c.householdMode,
              onChanged: c.setHouseholdMode,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Circle must approve a pause'),
              subtitle: const Text('Harder to cheat. Still not a prison.'),
              value: c.strictPause,
              onChanged: c.setStrictPause,
            ),
            const Divider(height: 32),
            const Text(
              'Intention',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            for (final item in Catalog.intentions)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(item.phrase),
                subtitle: Text(item.detail),
                trailing: Icon(
                  c.intentionId == item.id
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                ),
                onTap: () => c.setIntention(item.id),
              ),
            const Divider(height: 32),
            const Text(
              'Lifelines',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            for (final line in Catalog.lifelines)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(line.name),
                subtitle: Text(line.subtitle),
                value: c.lifelineIds.contains(line.id),
                onChanged: (_) => c.toggleLifeline(line.id),
              ),
            const SizedBox(height: 8),
            const Text(
              'People who still ring',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            for (final vip in Catalog.vips)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SelectTile(
                  label: vip.name,
                  subtitle: vip.relation,
                  selected: c.vipIds.contains(vip.id),
                  onTap: () => c.toggleVip(vip.id),
                  leading: PersonDot(
                    initials: vip.initials,
                    tint: vip.tint,
                    radius: 16,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            const Text(
              'Quiet apps',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 22,
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
                    selected: c.blockedAppIds.contains(app.id),
                    onSelected: (_) => c.toggleApp(app.id),
                    selectedColor: PauseColors.ink,
                    labelStyle: TextStyle(
                      color: c.blockedAppIds.contains(app.id)
                          ? Colors.white
                          : PauseColors.ink,
                    ),
                    checkmarkColor: Colors.white,
                  ),
              ],
            ),
            const Divider(height: 32),
            const Text(
              'A note to yourself',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: TextEditingController(text: c.weeklyNote),
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'What was the day actually like?',
                border: OutlineInputBorder(),
              ),
              onChanged: c.setWeeklyNote,
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: c.resetOnboarding,
              child: const Text('Replay onboarding'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                color: PauseColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

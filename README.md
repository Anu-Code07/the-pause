# Pause

A modern app for an ancient practice.
Put your phone down one day a week.
Do it with your family and friends.

**Pause** is a Flutter app for a weekly digital Sabbath: one sundown-to-sundown day where the apps that pull you away go quiet, your people rest with you, and the calls that actually matter still get through.

## Visual language

- **Onboarding** is cinematic stills, not slides: dinner under string lights, family on the sofa, serif lines like *to eat slowly*.
- **Rest** is weather and time: dusk and sunrise skies, a phone used as a window.
- **Icon** is a single candle. Not a pause glyph.

## What ships in this prototype

| Screen | What it does |
| --- | --- |
| Onboarding | Lifestyle stills → sacred-day sky → pick Saturday/Sunday → pick quiet apps → pick **lifelines** |
| Rest | Upcoming day, start rest, live countdown, slide-to-pause with a written reason |
| Circle | Friends resting now, weekly recap, Perfect Pause vs. “needed maps” |
| Blocks | Calm Morning, Deep Work, Family Dinner, Wind Down, Sleep |
| Timer | 5–180 min deep rest |
| You | Name, streak, rest day, replay onboarding |

Blocking is simulated in this build (no Screen Time / Digital Wellbeing API yet). The product shape is real.

## Lifelines — important calls, texts, Slack

Rest is not a blackout. During onboarding you choose what still reaches you:

- **Calls** — family and starred contacts still ring
- **Messages** — texts from people you choose
- **Slack** — DMs and @mentions only; channels stay quiet
- **Maps** — if you need to get somewhere

On the rest screen those lifelines stay visible: “Calls, Messages, Slack still reach you.”

If someone *does* need Instagram, they slide to pause, type why, and that reason is visible to their circle. Friction, not a padlock.

## Product plan

### Now (this repo)

- Weekly sacred day (Sat or Sun, sundown to sundown)
- Quiet-app list
- Lifelines for real-life / work emergencies
- Circle accountability
- Weekday blocks + deep rest timer
- Recap + Perfect Pause

### Next (native)

- iOS FamilyControls / Screen Time to actually block
- Android Digital Wellbeing / Accessibility blocking
- Notification routing: allow calls + VIP messages, silence the rest
- Slack / Teams filter: mentions and DMs only (via notification categories)
- Local sundown from location
- Live Activity / lock-screen remaining time
- Invite by phone number or contacts

### Later

- Family household rest (everyone locks together)
- Starred-contact VIP list
- Watch complication
- Home screen widget: “Maya is resting”
- Optional stricter mode: pause requires a friend to approve

### Business

- Free: one rest day a week, circle, lifelines
- Plus: weekday blocks, timer, extra lifeline rules, household

## Run

```bash
flutter pub get
flutter test
flutter run -d chrome
```

On a wide window the app frames itself like a phone.

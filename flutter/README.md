# Scrolling Insights: Flutter

The Flutter side of [Scrolling Insights: Flutter vs CSS](../README.md). One screen per scrolling behavior, with its twin in [`../css`](../css).

## Setup

Only the Dart code is committed. The platform folders (`android/`, `ios/`, `web/`, and the rest), `pubspec.lock`, and `.metadata` are git-ignored, to keep the repository about the code that matters. Generate them once, from this folder:

```bash
flutter create --org com.obumnwabude --platforms=web,android,ios .
```

`--org` sets the app's ID (`com.obumnwabude.scrolling_insights` on Android). Add `macos`, `windows`, or `linux` to the list if you want to run on desktop too. `flutter create` keeps the existing files (like `lib/` and `test/`) and only adds what's missing.

The code needs Dart 3.10 or newer (any recent stable Flutter). It uses no packages beyond Flutter itself.

## Running

```bash
flutter run -d chrome   # on the web
flutter run             # on a connected phone or emulator
```

The home screen lists every demo, numbered and grouped the same way as `css/index.html`. On a narrow screen, a demo opens full screen. On a screen at least 840px wide (a tablet, a laptop, the web), the list stays on the left and the demo opens on the right, which is handy for presenting. A floating pill at the bottom right of every demo moves to the previous or next demo. Each screen shows its key Flutter API under its title. Every demo file starts with a doc comment that explains the technique and names its CSS equivalent.

Try the demos on a phone, and on the web with a mouse and a trackpad. A few things to notice:

- On the web and desktop, Flutter adds scrollbars for you. On phones, it doesn't.
- With a mouse on the web or desktop, the wheel scrolls but dragging doesn't. Dragging to scroll is for touch (and trackpads). Horizontal demos scroll with a trackpad, or with Shift and the mouse wheel.
- Overscroll Behavior feels different on iOS and Android by design. Try both.

## Running from Your IDE

The repository comes with ready-made run configurations.

- VS Code: open the repository's root folder (or just this `flutter` folder), and install the Flutter extension when VS Code suggests it. In the Run and Debug view, pick "Flutter" (or its profile, release, and Chrome variants, or "Flutter tests"), choose a device in the status bar, and press F5. "Flutter and CSS side by side" opens both versions in Chrome at once.
- Android Studio (with the Flutter plugin): open this `flutter` folder (recommended), or the repository's root folder. Pick "main.dart" (or its profile and release variants, or "Flutter tests") in the toolbar, choose a device, and press Run.

To judge how smooth scrolling is, use profile mode. Debug mode is slower on purpose, to support hot reload and the debugger.

## Files

- `lib/main.dart`: the app.
- `lib/demos.dart`: `demos`, the list of every demo, in its groups.
- `lib/navigation.dart`: the home screen (one column or two, depending on the width), and the floating buttons that move between demos. Nothing in it is about scrolling.
- `lib/common.dart`: what every demo is built from. `Block` (a rounded, colored box), `DemoPage` (the screen with its title and API line), `DemoWidth` (keeps demos narrow on wide screens), `NumberBadge` and `DemoNumber` (a demo's number in its title), and the three demo colors.
- `lib/<demo_name>.dart`: one file per demo. Each one stands on its own, so you can read a demo in one file.
- `test/widget_test.dart`: tests for every demo.

## Tests

```bash
flutter analyze
flutter test
```

The tests open every demo and check it builds without layout errors. Then, for each demo, they drag, fling, or tap the way a user would, and check that the screen scrolls (or doesn't) as the demo says.

# Scrolling Insights: Flutter vs CSS

In browsers, with HTML and CSS, scrolling is active by default. HTML elements auto-scroll when there is need for that. On the other hand, in mobile apps, when coding for Android & iOS, you must be intentional about what should scroll. As Flutter builds for these platforms, it is inherently constrained to "intentional scrolling". This is especially technical when you want to implement specific scrolling flavors.

This repository builds 17 scrolling behaviors twice: once in HTML and CSS, and once in Flutter. Both versions of each demo look the same (blue containers, red items, a green highlight), so you can run them side by side and compare how each platform gets there.

## Try It Live

- CSS demos: https://obumnwabude.github.io/scrolling_flutter_vs_css/css/
- Flutter web app: https://obumnwabude.github.io/scrolling_flutter_vs_css/flutter/
- Android app: download the APK from the [latest release](https://github.com/obumnwabude/scrolling_flutter_vs_css/releases/latest).

Open the CSS and Flutter versions in two browser windows, side by side, and compare.

## The Demos

| #   | Demo                        | CSS                                                                  | Flutter                                                  |
| --- | --------------------------- | -------------------------------------------------------------------- | -------------------------------------------------------- |
| 1   | How to Scroll               | (Do nothing.)                                                        | `ListView`, `SingleChildScrollView`                      |
| 2   | Horizontal Scroll           | `overflow-x: auto`                                                   | `scrollDirection: Axis.horizontal`                       |
| 3   | Prevent Scroll              | `overflow: hidden`                                                   | `NeverScrollableScrollPhysics`                           |
| 4   | Nested Scrolling            | `height` + `overflow: auto`                                          | fixed height, `shrinkWrap`, or slivers                   |
| 5   | Pin Item on Scroll          | `position: sticky`                                                   | `PinnedHeaderSliver`                                     |
| 6   | Sticky Section Headers      | `position: sticky` (one per section)                                 | `SliverMainAxisGroup` + `PinnedHeaderSliver`             |
| 7   | Occupy Free Space or Scroll | `display: flex` + `flex: 1` + `overflow: auto`                       | `SliverFillRemaining` + `Expanded`                       |
| 8   | Collapsing Header           | `position: sticky` (negative `top`) + `animation-timeline: scroll()` | `SliverAppBar(pinned, expandedHeight)`                   |
| 9   | Floating Header             | `position: sticky` + a scroll listener (JS)                          | `SliverFloatingHeader`                                   |
| 10  | Scroll Snap                 | `scroll-snap-type`, `scroll-snap-align`                              | `PageView` + `PageController(viewportFraction)`          |
| 11  | Overscroll Behavior         | `overscroll-behavior`                                                | `BouncingScrollPhysics`, `ClampingScrollPhysics`         |
| 12  | Custom Scrollbar            | `scrollbar-color`, `scrollbar-width`                                 | `RawScrollbar`, `ScrollbarTheme`                         |
| 13  | Scroll Programmatically     | `scrollTo()`, `scrollIntoView()`, `scroll-behavior: smooth`          | `ScrollController.animateTo`, `Scrollable.ensureVisible` |
| 14  | Scroll Progress             | `animation-timeline: scroll()`                                       | `ScrollController` + `ListenableBuilder`                 |
| 15  | Infinite List               | `content-visibility: auto` + `IntersectionObserver` (JS)             | `ListView.builder` + `ScrollController`                  |
| 16  | Pull to Refresh             | `overscroll-behavior-y: contain` + touch events (JS)                 | `RefreshIndicator`                                       |
| 17  | Two-Dimensional Scroll      | `overflow: auto`                                                     | nested scrollables, or `TwoDimensionalScrollView`        |

Each demo's file explains, in comments, how it works on its own platform and how the other platform does the same thing. Start with whichever side you know, and read the other one next to it.

## What's Inside

- [`css/`](css): one HTML page per demo, plus an index page that links them all. No build step and no framework, so you can open the files straight in a browser. See [css/README.md](css/README.md).
- [`flutter/`](flutter): a Flutter app with one screen per demo, plus a home screen that lists them all. Only the Dart code is committed. You generate the platform folders yourself, with one command. See [flutter/README.md](flutter/README.md).

Both sides have tests that check each demo actually scrolls (or doesn't) the way it should: Playwright tests (in TypeScript) for CSS, widget tests for Flutter.

## Quick Start

CSS: open `css/index.html` in your browser.

Flutter:

```bash
cd flutter
flutter create --org com.obumnwabude --platforms=web,android,ios .
flutter run
```

Prefer your IDE? The repository includes run configurations for VS Code (`.vscode/`) and Android Studio (`.idea/runConfigurations/`), both at the root and inside `flutter/`. So they work whether you open the whole repository or just the `flutter` folder. In VS Code, "Flutter and CSS side by side" opens both versions of every demo in Chrome at once.

## Takeaways

- In CSS, things scroll unless you stop them. In Flutter, nothing scrolls unless you ask for it.
- Both platforms share the same rule for nested scrolling: an inner scroller needs a bounded size. CSS quietly grows the box if you forget. Flutter throws an error.
- `position: sticky` covers pinned items, section headers, and (with a negative `top`) collapsing headers. Flutter uses slivers for all three.
- Flutter has ready-made widgets for things the web platform leaves to JavaScript: floating headers, pull to refresh, and custom scrollbars that look the same in every browser.
- CSS has the edge on two-dimensional scrolling and on scroll-driven animations, which need no code at all.

## Publishing

Nothing in this repository deploys automatically. Two scripts publish by hand, when you run them:

- `scripts/deploy-pages.sh` builds the Flutter web app and copies the CSS demos into one site, with the landing page in `pages/index.html`. It pushes that site to the `gh-pages` branch, which GitHub Pages serves. `main` never contains build output. The first time, set Settings → Pages → Source to "Deploy from a branch", with `gh-pages` and `/ (root)`.
- `scripts/release-apk.sh` builds the Android APK and publishes it as a GitHub Release, tagged with the version in `flutter/pubspec.yaml`. It needs the [GitHub CLI](https://cli.github.com).

## Slides

[View the Slides for this Session Here.](https://docs.google.com/presentation/d/1Igei_3YLQCYmmNEzGHGHDE41r13znK2ouIcZwyE1WlQ/edit?usp=sharing)

import 'package:flutter/material.dart';

import 'common.dart';

/// What happens when you keep scrolling past the end of a list.
///
/// In Flutter, a scrollable's physics decide:
///  * [BouncingScrollPhysics] lets you drag past the edge, then springs back.
///    That's the iOS feel.
///  * [ClampingScrollPhysics] stops at the edge, and Android shows a stretch
///    (or glow) effect instead. That's the Android feel.
///
/// By default, Flutter picks the physics that match the platform. Setting
/// them yourself gives the same feel everywhere.
///
/// In CSS, the browser decides how the edge feels. `overscroll-behavior`
/// controls something else: what happens next. With `auto` (the default),
/// once an inner box reaches its end, the page behind it takes over and
/// scrolls. That's called scroll chaining. With `contain`, scrolling stops
/// at the edge of the box. It also turns off the bounce and the browser's
/// pull-to-refresh for that box.
///
/// Try it in this demo. When you drag an inner list to its end with a
/// finger, the outer list does not take over: Flutter doesn't chain drags
/// between nested scrollables. A mouse wheel does pass on to the outer list,
/// as it does on the web.
class OverscrollBehavior extends StatelessWidget {
  const OverscrollBehavior({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Overscroll Behavior',
      api: 'BouncingScrollPhysics / ClampingScrollPhysics',
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const DemoWidth(
            child: _InnerList(
              label: 'Bouncing',
              physics: BouncingScrollPhysics(),
            ),
          ),
          const SizedBox(height: 32),
          const DemoWidth(
            child: _InnerList(
              label: 'Clamping',
              physics: ClampingScrollPhysics(),
            ),
          ),
          const SizedBox(height: 32),
          // A tall box, so the outer list has room to scroll, and you can
          // see whether it moves when an inner list hits its end.
          Block(color: containerColor, height: MediaQuery.sizeOf(context).height),
        ],
      ),
    );
  }
}

/// A short, fixed-height list with the given [physics].
class _InnerList extends StatelessWidget {
  const _InnerList({required this.label, required this.physics});

  final String label;
  final ScrollPhysics physics;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(label, style: Theme.of(context).textTheme.titleMedium),
        ),
        Block(
          color: containerColor,
          height: 240,
          child: ListView.separated(
            // The only difference between the two lists.
            physics: physics,
            padding: const EdgeInsets.all(16),
            itemCount: 10,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, index) =>
                Block(color: childColor, height: 48, label: '${index + 1}'),
          ),
        ),
      ],
    );
  }
}

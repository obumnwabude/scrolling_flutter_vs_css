import 'package:flutter/material.dart';

import 'common.dart';

/// A bar that fills up as you scroll, showing how far you have read. Think
/// of the reading progress bar at the top of a blog post.
///
/// A [ScrollController] notifies its listeners every time the list scrolls.
/// [ListenableBuilder] listens to it and rebuilds just the bar, not the
/// whole screen.
///
/// In CSS, `animation-timeline: scroll()` ties a normal CSS animation to the
/// scroll position instead of time. At the top, the animation is at 0%. At
/// the bottom, it's at 100%. No JavaScript.
class ScrollProgress extends StatefulWidget {
  const ScrollProgress({super.key});

  @override
  State<ScrollProgress> createState() => _ScrollProgressState();
}

class _ScrollProgressState extends State<ScrollProgress> {
  final controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// How far down the list is scrolled, from 0 (top) to 1 (bottom).
  double get progress {
    // On the first frame, the bar builds before the list attaches to the
    // controller, so there is no position yet.
    if (!controller.hasClients) return 0;
    final position = controller.position;
    // A list too short to scroll is read in full.
    if (position.maxScrollExtent <= 0) return 1;
    // Clamp, because bouncing physics can scroll a little past either end.
    return (position.pixels / position.maxScrollExtent).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Scroll Progress',
      api: 'ScrollController + ListenableBuilder',
      body: Column(
        children: [
          // Rebuilds on every scroll. Only this bar, so it stays cheap.
          ListenableBuilder(
            listenable: controller,
            builder: (_, _) => LinearProgressIndicator(value: progress, minHeight: 8, color: highlightColor),
          ),
          Expanded(
            child: ListView.separated(
              controller: controller,
              padding: const EdgeInsets.all(24),
              itemCount: 40,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, index) => DemoWidth(
                child: Block(color: childColor, height: 56, label: 'Paragraph ${index + 1}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

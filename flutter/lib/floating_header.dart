import 'package:flutter/material.dart';

import 'common.dart';

/// A header that hides when you scroll down and comes back as soon as you
/// scroll up, wherever you are in the list. Think of the address bar in a
/// mobile browser.
///
/// [SliverFloatingHeader] (Flutter 3.24) does this with any child, and
/// animates it in and out. [SliverAppBar] does the same for app bars with
/// `floating: true`.
///
/// CSS has no property that knows which way you are scrolling, so the CSS
/// demo uses a few lines of JavaScript. It compares each scroll position to
/// the last one, and toggles a class that slides the header out.
class FloatingHeader extends StatelessWidget {
  const FloatingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Floating Header',
      api: 'SliverFloatingHeader',
      body: DemoWidth(
        child: CustomScrollView(
          slivers: [
            // Scroll down a little: it slides away. Scroll up a little: it
            // slides back.
            const SliverFloatingHeader(
              child: Block(color: highlightColor, height: 64, label: 'Header'),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                itemCount: 30,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (_, index) => Block(
                  color: childColor,
                  height: 56,
                  label: 'Item ${index + 1}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

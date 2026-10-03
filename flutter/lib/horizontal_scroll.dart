import 'package:flutter/material.dart';

import 'common.dart';

/// A row of cards that scrolls sideways.
///
/// Every Flutter scrollable has a `scrollDirection`, which is
/// [Axis.vertical] by default. Set it to [Axis.horizontal] to scroll sideways.
/// In CSS, put the cards in a flex row and add `overflow-x: auto`.
class HorizontalScroll extends StatelessWidget {
  const HorizontalScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Horizontal Scroll',
      api: 'scrollDirection: Axis.horizontal',
      // Align puts the row at the top instead of stretching it over the
      // whole screen.
      body: Align(
        alignment: Alignment.topCenter,
        // A horizontal list stretches to all the height it is given. Without
        // a fixed height, its cards would be as tall as the screen. The CSS
        // row does the same thing with `height: 160px`.
        child: SizedBox(
          height: 160,
          // `.separated` puts a widget between items: here, a 16px gap,
          // like `gap: 16px` in CSS.
          child: ListView.separated(
            padding: const EdgeInsets.all(24),
            scrollDirection: Axis.horizontal,
            itemCount: 12,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            // In a horizontal list, items take the list's full height, so
            // each card only needs a width.
            itemBuilder: (_, index) => Block(color: containerColor, width: 160, label: '${index + 1}'),
          ),
        ),
      ),
    );
  }
}

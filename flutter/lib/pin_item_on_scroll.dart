import 'package:flutter/material.dart';

import 'common.dart';

/// An item that scrolls with the content until it reaches the top, then
/// stays there while the rest keeps scrolling.
///
/// In CSS, that is `position: sticky; top: 0` on the item. In Flutter, it
/// takes slivers. A sliver is a piece of a scrollable that knows how far it
/// has scrolled, so it can react to it. A [CustomScrollView] stacks slivers
/// one after another:
///  * [SliverToBoxAdapter] wraps a normal widget (a "box") as a sliver.
///  * [PinnedHeaderSliver] scrolls until it reaches the top, then stays.
///
/// Before [PinnedHeaderSliver] (Flutter 3.24), you needed a [SliverAppBar]
/// with `pinned: true`, or a [SliverPersistentHeader] with a custom
/// delegate.
class PinItemOnScroll extends StatelessWidget {
  const PinItemOnScroll({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return DemoPage(
      title: 'Pin Item on Scroll',
      api: 'CustomScrollView + PinnedHeaderSliver',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: DemoWidth(
          // The blue box is the scroll container: 70% of the screen tall,
          // like `height: 70vh` in CSS.
          child: Block(
            color: containerColor,
            height: height * 0.7,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CustomScrollView(
                slivers: [
                  // Content above the pinned item.
                  SliverToBoxAdapter(
                    child: Block(color: childColor, height: height * 0.6),
                  ),
                  // Slivers have no margins, so a SizedBox makes the gap.
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  // The pinned item. It scrolls up with the red box above,
                  // and stops at the top of the container.
                  const PinnedHeaderSliver(
                    child: Block(
                      color: highlightColor,
                      height: 120,
                      label: 'Pinned',
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  // Content below, which scrolls under the pinned item.
                  SliverToBoxAdapter(
                    child: Block(color: childColor, height: height * 1.2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'common.dart';

/// A tall header that shrinks to a toolbar as you scroll, then stays pinned.
/// Think of a profile page with a big cover photo.
///
/// [SliverAppBar] does it all. `expandedHeight` is its height at the top of
/// the list. `pinned: true` keeps it on screen, at toolbar height, once it
/// has collapsed. [FlexibleSpaceBar] animates the title between the two
/// sizes. For a custom header that isn't an app bar, use
/// [SliverResizingHeader].
///
/// CSS has no collapsing header, but two features combine into one. A
/// sticky header with a negative `top` scrolls until only its bottom part is
/// visible, then sticks. A scroll-driven animation (`animation-timeline:
/// scroll()`) shrinks the title as you scroll.
class CollapsingHeader extends StatelessWidget {
  const CollapsingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Collapsing Header',
      api: 'SliverAppBar(pinned, expandedHeight)',
      body: DemoWidth(
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              // This app bar is part of the demo, not the screen's app bar,
              // so it shouldn't show a back button.
              automaticallyImplyLeading: false,
              backgroundColor: highlightColor,
              // 200 tall at the top, collapsing to the default toolbar
              // height (56).
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Header', style: TextStyle(color: Colors.white)),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                itemCount: 20,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (_, index) => Block(color: childColor, height: 56, label: 'Item ${index + 1}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

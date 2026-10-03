import 'package:flutter/material.dart';

import 'common.dart';

/// Content taller than the screen, which the user can't scroll.
///
/// You might do this behind a modal or a menu, or while a game is playing.
///
/// In CSS, `overflow: hidden` clips the extra content and turns off
/// scrolling. In Flutter, not using a scrollable is not enough: a [Column]
/// that is too tall shows the yellow and black overflow stripes. Instead,
/// use a scrollable and give it [NeverScrollableScrollPhysics]. It still
/// clips the extra content, but ignores drags and the mouse wheel.
///
/// A scrollable with these physics can still be moved from code, with a
/// [ScrollController]. So can an element with `overflow: hidden`, with
/// `element.scrollTo()`.
class PreventScroll extends StatelessWidget {
  const PreventScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Prevent Scroll',
      api: 'NeverScrollableScrollPhysics',
      body: SingleChildScrollView(
        // Physics decide how a scrollable responds to the user. These never
        // let it move.
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: DemoWidth(
          // The same box as in How to Scroll: twice the screen's height.
          child: Block(color: containerColor, height: MediaQuery.sizeOf(context).height * 2),
        ),
      ),
    );
  }
}

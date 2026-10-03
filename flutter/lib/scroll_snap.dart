import 'package:flutter/material.dart';

import 'common.dart';

/// Scrolling that always comes to rest on a whole card, like a carousel or
/// an onboarding flow.
///
/// [PageView] snaps to one page at a time. Its [PageController] sets
/// `viewportFraction`: the share of the width each page takes. Below 1, the
/// previous and next cards peek in from the sides, hinting that there is
/// more to swipe.
///
/// In CSS, `scroll-snap-type: x mandatory` on the container makes it snap,
/// and `scroll-snap-align: center` on each card says where to snap. Each
/// card is `80%` wide, like `viewportFraction: 0.8`.
///
/// Material 3 also has [CarouselView], a ready-made carousel built on the
/// same idea.
class ScrollSnap extends StatefulWidget {
  const ScrollSnap({super.key});

  @override
  State<ScrollSnap> createState() => _ScrollSnapState();
}

class _ScrollSnapState extends State<ScrollSnap> {
  // Controllers hold resources, so they live in a State (not in build), and
  // are disposed with it.
  final controller = PageController(viewportFraction: 0.8);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Scroll Snap',
      api: 'PageView + PageController(viewportFraction)',
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          // A horizontal PageView, like a horizontal ListView, needs a
          // height.
          child: SizedBox(
            height: 240,
            child: PageView.builder(
              controller: controller,
              itemCount: 8,
              // The padding makes the gap between cards. PageView has no
              // separator of its own.
              itemBuilder: (_, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Block(color: containerColor, label: '${index + 1}'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

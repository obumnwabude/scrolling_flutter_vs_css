import 'package:flutter/material.dart';

import 'common.dart';

/// How to make content scroll at all.
///
/// In the browser, a page taller than the window scrolls by default. You do
/// nothing. In Flutter, nothing scrolls unless you put it inside a scrollable
/// widget. Content taller than the screen without one overflows: Flutter
/// paints yellow and black stripes over the bottom edge, and the rest of the
/// content is out of reach.
///
/// The common scrollable widgets are:
///  * [ListView], for a list of children (built lazily with
///    [ListView.builder]),
///  * [SingleChildScrollView], for one child (often a [Column]),
///  * [GridView], for a grid,
///  * [CustomScrollView], for mixing lists, grids, and headers as slivers,
///  * [PageView], for full-page swipes.
class HowToScroll extends StatelessWidget {
  const HowToScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'How to Scroll',
      api: 'ListView / SingleChildScrollView',
      // The ListView is the only reason this screen scrolls. Replace it with
      // a Column, and you get the overflow stripes instead.
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          DemoWidth(
            // A box twice as tall as the screen, so there is something to
            // scroll. The CSS demo uses `height: 200vh` for the same box.
            child: Block(color: containerColor, height: MediaQuery.sizeOf(context).height * 2),
          ),
        ],
      ),
    );
  }
}

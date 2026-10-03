/// The list of every demo, grouped and numbered the same way as
/// `css/index.html`.
library;

import 'package:flutter/material.dart';

import 'collapsing_header.dart';
import 'custom_scrollbar.dart';
import 'floating_header.dart';
import 'horizontal_scroll.dart';
import 'how_to_scroll.dart';
import 'infinite_list.dart';
import 'nested_scrolling.dart';
import 'occupy_free_space_or_scroll.dart';
import 'overscroll_behavior.dart';
import 'pin_item_on_scroll.dart';
import 'prevent_scroll.dart';
import 'pull_to_refresh.dart';
import 'scroll_programmatically.dart';
import 'scroll_progress.dart';
import 'scroll_snap.dart';
import 'sticky_section_headers.dart';
import 'two_dimensional_scroll.dart';

/// A demo: its title, and a function that builds its screen.
typedef Demo = (String, Widget Function());

/// A group of related demos, and the color that marks them. The colors
/// match the groups in `css/all.css`.
typedef DemoGroup = ({String name, Color color, List<Demo> demos});

final List<DemoGroup> demoGroups = [
  (
    name: 'Basics',
    color: Colors.blue.shade600,
    demos: [
      ('How to Scroll', () => const HowToScroll()),
      ('Horizontal Scroll', () => const HorizontalScroll()),
      ('Prevent Scroll', () => const PreventScroll()),
      ('Nested Scrolling', () => const NestedScrolling()),
    ],
  ),
  (
    name: 'Headers & Layout',
    color: Colors.green.shade600,
    demos: [
      ('Pin Item on Scroll', () => const PinItemOnScroll()),
      ('Sticky Section Headers', () => const StickySectionHeaders()),
      ('Occupy Free Space or Scroll', () => const OccupyFreeSpaceOrScroll()),
      ('Collapsing Header', () => const CollapsingHeader()),
      ('Floating Header', () => const FloatingHeader()),
    ],
  ),
  (
    name: 'Feel',
    color: Colors.orange.shade600,
    demos: [
      ('Scroll Snap', () => const ScrollSnap()),
      ('Overscroll Behavior', () => const OverscrollBehavior()),
      ('Custom Scrollbar', () => const CustomScrollbar()),
    ],
  ),
  (
    name: 'Control & Data',
    color: Colors.purple.shade600,
    demos: [
      ('Scroll Programmatically', () => const ScrollProgrammatically()),
      ('Scroll Progress', () => const ScrollProgress()),
      ('Infinite List', () => const InfiniteList()),
      ('Pull to Refresh', () => const PullToRefresh()),
      ('Two-Dimensional Scroll', () => const TwoDimensionalScroll()),
    ],
  ),
];

/// Every demo, in order. A demo's number is its position in this list,
/// plus one. The tests in `test/widget_test.dart` go through this list too.
final List<Demo> demos = [for (final group in demoGroups) ...group.demos];

/// The color of the group that the demo at [index] (in [demos]) belongs to.
Color groupColorOf(int index) {
  var start = 0;
  for (final group in demoGroups) {
    if (index < start + group.demos.length) return group.color;
    start += group.demos.length;
  }
  throw RangeError.index(index, demos);
}

// Widget tests for every demo. Run them with `flutter test`.
//
// A widget test builds a screen in memory (800×600 by default), without a
// device. `tester` lets the test drag, fling, and tap like a user, and
// `pump` advances time so frames and animations happen. Each test below
// checks the behavior its demo is about, mostly by reading the scroll
// position before and after a gesture.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrolling_insights/collapsing_header.dart';
import 'package:scrolling_insights/common.dart';
import 'package:scrolling_insights/demos.dart';
import 'package:scrolling_insights/floating_header.dart';
import 'package:scrolling_insights/horizontal_scroll.dart';
import 'package:scrolling_insights/how_to_scroll.dart';
import 'package:scrolling_insights/infinite_list.dart';
import 'package:scrolling_insights/main.dart';
import 'package:scrolling_insights/nested_scrolling.dart';
import 'package:scrolling_insights/occupy_free_space_or_scroll.dart';
import 'package:scrolling_insights/pin_item_on_scroll.dart';
import 'package:scrolling_insights/prevent_scroll.dart';
import 'package:scrolling_insights/pull_to_refresh.dart';
import 'package:scrolling_insights/scroll_programmatically.dart';
import 'package:scrolling_insights/scroll_progress.dart';
import 'package:scrolling_insights/scroll_snap.dart';
import 'package:scrolling_insights/sticky_section_headers.dart';
import 'package:scrolling_insights/two_dimensional_scroll.dart';

/// Shows [demo] as the only screen of an app.
Future<void> open(WidgetTester tester, Widget demo) async {
  await tester.pumpWidget(MaterialApp(home: demo));
}

/// The colored [Block] that shows [label].
Finder blockWith(String label) {
  // Match on the Block's own label. Looking for any Block above the text
  // would also find the container Block that the labelled Block sits in.
  return find.byWidgetPredicate((widget) => widget is Block && widget.label == label);
}

/// The scroll position of the [index]th scrollable on screen.
ScrollPosition scrollPosition(WidgetTester tester, [int index = 0]) {
  return tester.state<ScrollableState>(find.byType(Scrollable).at(index)).position;
}

void main() {
  testWidgets('home screen lists every demo', (tester) async {
    await tester.pumpWidget(const MyApp());
    for (final (title, _) in demos) {
      await tester.scrollUntilVisible(find.text(title), 100);
      expect(find.text(title), findsOneWidget);
    }
  });

  testWidgets('narrow screens: a demo opens full screen, with its number', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('How to Scroll'));
    await tester.pumpAndSettle();
    expect(find.byType(HowToScroll), findsOneWidget);
    expect(find.descendant(of: find.byType(AppBar), matching: find.text('1')), findsOneWidget);

    // The floating buttons move to the next demo, then back to the list.
    await tester.tap(find.byTooltip('Next demo'));
    await tester.pumpAndSettle();
    expect(find.byType(HorizontalScroll), findsOneWidget);
    await tester.tap(find.byTooltip('All demos'));
    await tester.pumpAndSettle();
    expect(find.byType(HorizontalScroll), findsNothing);
  });

  testWidgets('wide screens: the list and the demo side by side', (tester) async {
    // Pretend to be a 1200×800 window, then put the test window back.
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());
    // The first demo is open next to the list.
    expect(find.byType(HowToScroll), findsOneWidget);

    await tester.tap(find.text('Pin Item on Scroll'));
    await tester.pumpAndSettle();
    expect(find.byType(PinItemOnScroll), findsOneWidget);
    expect(find.byType(HowToScroll), findsNothing);
  });

  // Catches layout errors (like an unbounded height) in every screen.
  testWidgets('every demo opens without errors', (tester) async {
    for (final (title, builder) in demos) {
      await open(tester, builder());
      expect(find.text(title), findsOneWidget, reason: title);
      expect(tester.takeException(), isNull, reason: title);
    }
  });

  testWidgets('How to Scroll: the list scrolls', (tester) async {
    await open(tester, const HowToScroll());
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pump();
    expect(scrollPosition(tester).pixels, greaterThan(0));
  });

  testWidgets('Horizontal Scroll: the row scrolls sideways', (tester) async {
    await open(tester, const HorizontalScroll());
    await tester.drag(find.byType(ListView), const Offset(-300, 0));
    await tester.pump();
    expect(scrollPosition(tester).pixels, greaterThan(0));
  });

  testWidgets('Prevent Scroll: dragging does nothing', (tester) async {
    await open(tester, const PreventScroll());
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
    await tester.pump();
    // Still at the top: NeverScrollableScrollPhysics ignored the drag.
    expect(scrollPosition(tester).pixels, 0);
  });

  testWidgets('Nested Scrolling: the inner list scrolls on its own', (tester) async {
    await open(tester, const NestedScrolling());
    // Drag inside the inner list. Only the inner list should move.
    await tester.drag(find.text('Inner 1'), const Offset(0, -100));
    await tester.pump();
    expect(scrollPosition(tester, 0).pixels, 0, reason: 'outer list');
    expect(scrollPosition(tester, 1).pixels, greaterThan(0));
  });

  testWidgets('Pin Item on Scroll: the item stays at the top', (tester) async {
    await open(tester, const PinItemOnScroll());
    // Scroll past the pinned item's place in the list (about 380px down),
    // but not past the end of the list (about 840px). Past the end, Android's
    // stretch effect would briefly scale the content and shift the item.
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
    await tester.pumpAndSettle();
    final top = tester.getTopLeft(find.byType(CustomScrollView)).dy;
    expect(tester.getTopLeft(blockWith('Pinned')).dy, moreOrLessEquals(top));
  });

  testWidgets('Sticky Section Headers: a header sticks in its section', (tester) async {
    await open(tester, const StickySectionHeaders());
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
    await tester.pump();
    // A1 has scrolled away, but its section's header is still on screen.
    // hitTestable() only finds widgets the user could actually tap.
    expect(find.text('Section A').hitTestable(), findsOneWidget);
    expect(find.text('A1').hitTestable(), findsNothing);
  });

  testWidgets('Occupy Free Space or Scroll: fills, then scrolls', (tester) async {
    await open(tester, const OccupyFreeSpaceOrScroll());
    // Short content: the filler stretches and nothing scrolls.
    expect(tester.getSize(blockWith('Filler')).height, greaterThan(120));
    expect(scrollPosition(tester).maxScrollExtent, 0);

    for (var i = 0; i < 10; i++) {
      await tester.tap(find.text('Add item'));
      await tester.pump();
    }
    // Tall content: now it scrolls.
    expect(scrollPosition(tester).maxScrollExtent, greaterThan(0));
  });

  testWidgets('Collapsing Header: shrinks to a toolbar', (tester) async {
    await open(tester, const CollapsingHeader());
    expect(tester.getSize(find.byType(FlexibleSpaceBar)).height, 200);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
    await tester.pump();
    expect(tester.getSize(find.byType(FlexibleSpaceBar)).height, kToolbarHeight);
  });

  testWidgets('Floating Header: hides on scroll down, shows on scroll up', (tester) async {
    await open(tester, const FloatingHeader());
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(find.text('Header').hitTestable(), findsNothing);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, 50));
    await tester.pumpAndSettle();
    expect(find.text('Header').hitTestable(), findsOneWidget);
  });

  testWidgets('Scroll Snap: comes to rest on a whole card', (tester) async {
    await open(tester, const ScrollSnap());
    final controller = tester.widget<PageView>(find.byType(PageView)).controller!;

    // A fling (a quick swipe) moves to the next card.
    await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
    await tester.pumpAndSettle();
    expect(controller.page, 1);

    await tester.drag(find.byType(PageView), const Offset(-100, 0));
    await tester.pumpAndSettle();
    expect(controller.page, 1, reason: 'a short drag snaps back');
  });

  testWidgets('Scroll Programmatically: buttons move the list', (tester) async {
    await open(tester, const ScrollProgrammatically());

    await tester.tap(find.text('Bottom'));
    await tester.pumpAndSettle();
    final position = scrollPosition(tester);
    expect(position.pixels, position.maxScrollExtent);

    await tester.tap(find.text('Top'));
    await tester.pumpAndSettle();
    expect(position.pixels, 0);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Item 25'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: find.byType(SingleChildScrollView), matching: find.text('Item 25')).hitTestable(),
      findsOneWidget,
    );
  });

  testWidgets('Scroll Progress: the bar fills as you scroll', (tester) async {
    await open(tester, const ScrollProgress());
    double progress() => tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator)).value!;

    expect(progress(), 0);
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pump();
    expect(progress(), greaterThan(0));
  });

  testWidgets('Infinite List: loads more near the end', (tester) async {
    await open(tester, const InfiniteList());
    expect(find.text('Item 21'), findsNothing);

    // Scroll to the end, then wait for the pretend server (800ms).
    await tester.drag(find.byType(ListView), const Offset(0, -10000));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Item 21'), findsOneWidget);
  });

  testWidgets('Pull to Refresh: pulling down refreshes', (tester) async {
    await open(tester, const PullToRefresh());
    expect(find.text('Refreshed 0 times'), findsOneWidget);

    // Pull down from the top, then let the spinner and the 1s refresh run.
    await tester.fling(find.byType(ListView), const Offset(0, 300), 1000);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Refreshed 1 time'), findsOneWidget);
  });

  testWidgets('Two-Dimensional Scroll: scrolls both ways', (tester) async {
    await open(tester, const TwoDimensionalScroll());

    // Index 0 is the outer (vertical) scrollable, 1 the inner (horizontal).
    await tester.drag(find.text('A1'), const Offset(0, -200));
    await tester.pump();
    expect(scrollPosition(tester, 0).pixels, greaterThan(0), reason: 'down');

    await tester.drag(find.text('A5'), const Offset(-200, 0));
    await tester.pump();
    expect(scrollPosition(tester, 1).pixels, greaterThan(0), reason: 'across');
  });
}

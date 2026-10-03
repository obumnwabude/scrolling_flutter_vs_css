/// The home screen, and the buttons that move between demos.
///
/// None of this is about scrolling. It makes the demos easy to browse, on a
/// phone or on a wide screen while presenting.
library;

import 'package:flutter/material.dart';

import 'common.dart';
import 'demos.dart';

/// Windows at least this wide show the list of demos and the open demo side
/// by side. 840 is where Material 3's "expanded" window size class starts.
const double wideLayoutBreakpoint = 840;

/// The list of demos.
///
/// On a narrow screen (a phone), tapping a demo opens it full screen, like a
/// page in a browser. On a wide screen (a tablet, a laptop, the web), the
/// list stays on the left and the demo opens on the right. That's handy for
/// presenting: you can jump between demos in one click.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// The demo open on the right, on a wide screen.
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    // MediaQuery.sizeOf rebuilds this widget when the window is resized, so
    // the layout switches as you drag the window's edge across 840px.
    final wide = MediaQuery.sizeOf(context).width >= wideLayoutBreakpoint;

    if (!wide) {
      return Scaffold(
        appBar: AppBar(elevation: 1, centerTitle: true, title: const Text('Scrolling Insights')),
        // With 17 demos, the home screen itself needs to scroll.
        body: DemoList(
          onSelected: (index) =>
              Navigator.push(context, MaterialPageRoute<void>(builder: (_) => _FullScreenDemo(initialIndex: index))),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // The list, at a fixed width on the left.
            SizedBox(
              width: 320,
              child: Column(
                children: [
                  SizedBox(
                    height: kToolbarHeight,
                    child: Center(child: Text('Scrolling Insights', style: Theme.of(context).textTheme.titleLarge)),
                  ),
                  Expanded(
                    child: DemoList(selected: selected, onSelected: (index) => setState(() => selected = index)),
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 1),
            // The open demo, in the rest of the width.
            Expanded(
              child: DemoViewer(index: selected, onIndexChanged: (index) => setState(() => selected = index)),
            ),
          ],
        ),
      ),
    );
  }
}

/// A demo opened full screen, on a narrow screen. It keeps track of which
/// demo is showing, so the previous and next buttons can change it in place.
class _FullScreenDemo extends StatefulWidget {
  const _FullScreenDemo({required this.initialIndex});

  final int initialIndex;

  @override
  State<_FullScreenDemo> createState() => _FullScreenDemoState();
}

class _FullScreenDemoState extends State<_FullScreenDemo> {
  late int index = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return DemoViewer(
      index: index,
      onIndexChanged: (newIndex) => setState(() => index = newIndex),
      // Back to the list of demos.
      onAllDemos: () => Navigator.pop(context),
    );
  }
}

/// Every demo as a numbered button, grouped like `css/index.html`.
class DemoList extends StatelessWidget {
  const DemoList({super.key, required this.onSelected, this.selected});

  /// Called with the index (in [demos]) of the demo the user tapped.
  final ValueChanged<int> onSelected;

  /// The index of the demo to highlight, if any.
  final int? selected;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    var index = 0;
    for (final group in demoGroups) {
      children.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
          child: Text(group.name, style: Theme.of(context).textTheme.titleSmall),
        ),
      );
      for (final (title, _) in group.demos) {
        // A new variable on each pass, so each button's callback keeps its
        // own index.
        final i = index++;
        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _DemoButton(
              number: i + 1,
              title: title,
              color: group.color,
              selected: i == selected,
              onTap: () => onSelected(i),
            ),
          ),
        );
      }
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [DemoWidth(child: Column(children: children))],
    );
  }
}

/// One demo in the list: an outlined button in its group's color, with its
/// number. Matches the links on `css/index.html`.
class _DemoButton extends StatelessWidget {
  const _DemoButton({
    required this.number,
    required this.title,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final int number;
  final String title;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      // A light tint of the group color marks the open demo.
      color: selected ? color.withValues(alpha: 0.12) : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color, width: 2),
      ),
      // Clips the tap ripple to the rounded corners.
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              NumberBadge(number: number, color: color),
              const SizedBox(width: 12),
              Expanded(child: Text(title)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows the demo at [index], with floating buttons to move between demos.
class DemoViewer extends StatelessWidget {
  const DemoViewer({super.key, required this.index, required this.onIndexChanged, this.onAllDemos});

  final int index;
  final ValueChanged<int> onIndexChanged;

  /// Goes back to the list. Null when the list is already on screen.
  final VoidCallback? onAllDemos;

  @override
  Widget build(BuildContext context) {
    final (_, builder) = demos[index];
    final color = groupColorOf(index);
    return Stack(
      children: [
        Positioned.fill(
          child: DemoNumber(
            number: index + 1,
            color: color,
            // A new key for each demo, so switching demos starts the new one
            // fresh, instead of reusing the previous demo's scroll position.
            child: KeyedSubtree(key: ValueKey(index), child: builder()),
          ),
        ),
        // Floats over the bottom right of the demo, like a
        // FloatingActionButton, and like `.demo-nav` in the CSS demos.
        Positioned(
          right: 16,
          bottom: 16,
          child: SafeArea(
            child: _DemoNavigation(index: index, color: color, onIndexChanged: onIndexChanged, onAllDemos: onAllDemos),
          ),
        ),
      ],
    );
  }
}

/// A pill with buttons to the previous demo, all demos, and the next demo.
class _DemoNavigation extends StatelessWidget {
  const _DemoNavigation({
    required this.index,
    required this.color,
    required this.onIndexChanged,
    required this.onAllDemos,
  });

  final int index;
  final Color color;
  final ValueChanged<int> onIndexChanged;
  final VoidCallback? onAllDemos;

  @override
  Widget build(BuildContext context) {
    final isFirst = index == 0;
    final isLast = index == demos.length - 1;
    return Material(
      elevation: 4,
      color: Theme.of(context).colorScheme.surface,
      shape: StadiumBorder(side: BorderSide(color: color, width: 2)),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // A null onPressed disables the button: no previous demo on the
            // first one, and no next demo on the last.
            IconButton(
              tooltip: 'Previous demo',
              icon: const Icon(Icons.chevron_left),
              onPressed: isFirst ? null : () => onIndexChanged(index - 1),
            ),
            if (onAllDemos != null)
              IconButton(tooltip: 'All demos', icon: const Icon(Icons.apps), onPressed: onAllDemos),
            IconButton(
              tooltip: 'Next demo',
              icon: const Icon(Icons.chevron_right),
              onPressed: isLast ? null : () => onIndexChanged(index + 1),
            ),
          ],
        ),
      ),
    );
  }
}

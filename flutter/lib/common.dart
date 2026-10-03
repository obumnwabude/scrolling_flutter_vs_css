/// Building blocks shared by every demo screen.
///
/// Each demo is made of plain colored boxes, so that nothing distracts from
/// how the boxes scroll. The CSS demos use the same colors and sizes (see
/// `css/all.css`), so you can put both versions side by side.
library;

import 'package:flutter/material.dart';

/// The outer box of a demo: usually the thing that scrolls.
/// Same as `--container` in CSS.
const Color containerColor = Colors.blue;

/// The items inside a demo: usually the things being scrolled.
/// Same as `--child` in CSS.
const Color childColor = Colors.red;

/// The one item a demo is about: the pinned item, the header, the filler.
/// Same as `--highlight` in CSS.
const Color highlightColor = Colors.green;

/// The maximum width of a demo. Matches `max-width: 512px` on `main` in CSS,
/// so demos don't stretch across wide screens on the web or tablets.
const double demoWidth = 512;

/// A rounded, colored box. Every demo is built from these.
///
/// Give it a [width] and [height] to fix its size, or leave them out to let
/// its parent decide. Give it a [label] to show white text in its center, or
/// a [child] to put any widget inside it (like a list).
class Block extends StatelessWidget {
  const Block({
    super.key,
    required this.color,
    this.width,
    this.height,
    this.label,
    this.child,
  });

  final Color color;
  final double? width;
  final double? height;
  final String? label;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Only center the content when it is a label. A child (like a list)
      // should fill the box instead.
      alignment: label == null ? null : Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
      ),
      height: height,
      width: width,
      child:
          child ??
          (label == null
              ? null
              : Text(label!, style: const TextStyle(color: Colors.white))),
    );
  }
}

/// The scaffold of every demo screen.
///
/// It shows the demo's [title] in the app bar and, just below it, the [api]
/// the demo is about, in a monospace font. Each CSS page shows its key CSS in
/// the same spot, so you can always see what makes the demo work.
class DemoPage extends StatelessWidget {
  const DemoPage({
    super.key,
    required this.title,
    required this.api,
    required this.body,
    this.actions,
  });

  final String title;
  final String api;
  final Widget body;

  /// Buttons on the right of the app bar, for demos you interact with.
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    // Opened from the home screen, a demo shows its number before its title.
    final demoNumber = DemoNumber.maybeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (demoNumber != null) ...[
              NumberBadge(number: demoNumber.number, color: demoNumber.color),
              const SizedBox(width: 12),
            ],
            Flexible(child: Text(title, overflow: TextOverflow.ellipsis)),
          ],
        ),
        actions: actions,
        // `bottom` adds a row under the title. It must say how tall it is,
        // hence PreferredSize.
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(32),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              api,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            ),
          ),
        ),
      ),
      body: body,
    );
  }
}

/// Limits [child] to [demoWidth] and centers it horizontally.
///
/// On a phone, the screen is narrower than [demoWidth], so this does nothing.
/// On the web or a tablet, it keeps the demo readable.
class DemoWidth extends StatelessWidget {
  const DemoWidth({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: demoWidth),
        child: child,
      ),
    );
  }
}

/// The number of the demo below it, and the color of its group.
///
/// The home screen wraps each demo it opens in one, so [DemoPage] can show
/// the demo's number in its title. An [InheritedWidget] passes data down the
/// tree to any descendant that asks for it, without passing it through every
/// constructor in between. Tests that open a demo directly have none, so the
/// title shows alone.
class DemoNumber extends InheritedWidget {
  const DemoNumber({
    super.key,
    required this.number,
    required this.color,
    required super.child,
  });

  final int number;
  final Color color;

  /// The nearest [DemoNumber] above [context], if any.
  static DemoNumber? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DemoNumber>();
  }

  @override
  bool updateShouldNotify(DemoNumber oldWidget) {
    return number != oldWidget.number || color != oldWidget.color;
  }
}

/// A demo's number in a circle of its group's color. Matches `.number` in
/// `css/all.css`.
class NumberBadge extends StatelessWidget {
  const NumberBadge({super.key, required this.number, required this.color});

  final int number;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: color,
      foregroundColor: Colors.white,
      child: Text(
        '$number',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}

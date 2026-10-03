import 'package:flutter/material.dart';

import 'common.dart';

/// Scrolling from code: back to the top, down to the bottom, or to an item.
/// Think of a "back to top" button, or jumping to a search result.
///
/// Flutter has two tools for it:
///  * A [ScrollController] attached to a scrollable can move it to any
///    offset, with `jumpTo` (instantly) or `animateTo` (smoothly). In
///    JavaScript, that's `element.scrollTo()`.
///  * [Scrollable.ensureVisible] scrolls every scrollable around a widget
///    until that widget is on screen. In JavaScript, that's
///    `element.scrollIntoView()`.
///
/// CSS can also scroll on its own: a link to `#some-id` scrolls to the
/// element with that id, and `scroll-behavior: smooth` animates it.
class ScrollProgrammatically extends StatefulWidget {
  const ScrollProgrammatically({super.key});

  @override
  State<ScrollProgrammatically> createState() => _ScrollProgrammaticallyState();
}

class _ScrollProgrammaticallyState extends State<ScrollProgrammatically> {
  static const duration = Duration(milliseconds: 500);

  /// The item that the middle button scrolls to.
  static const target = 25;

  final controller = ScrollController();

  /// A [GlobalKey] lets code find a widget's [BuildContext] (and so its place
  /// on screen) from outside that widget. It plays the role of an `id` in
  /// HTML.
  final targetKey = GlobalKey();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void toTop() {
    controller.animateTo(0, duration: duration, curve: Curves.easeInOut);
  }

  void toBottom() {
    // maxScrollExtent is how far the content can scroll: its height minus
    // the viewport's height. Like `scrollHeight - clientHeight` in the DOM.
    controller.animateTo(controller.position.maxScrollExtent, duration: duration, curve: Curves.easeInOut);
  }

  void toItem() {
    // ensureVisible needs the target to be built. A Column inside a
    // SingleChildScrollView builds all its children, so it always is.
    // A lazy ListView.builder only builds what's near the screen. There,
    // scroll to an offset instead (for example, index × item height).
    Scrollable.ensureVisible(
      targetKey.currentContext!,
      // 0 puts the item at the top, 1 at the bottom, 0.5 in the middle.
      // Like `block: 'start' | 'end' | 'center'` in scrollIntoView.
      alignment: 0.5,
      duration: duration,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Scroll Programmatically',
      api: 'ScrollController.animateTo / Scrollable.ensureVisible',
      body: Column(
        children: [
          // The buttons stay put above the list.
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                OutlinedButton(onPressed: toTop, child: const Text('Top')),
                OutlinedButton(onPressed: toItem, child: const Text('Item $target')),
                OutlinedButton(onPressed: toBottom, child: const Text('Bottom')),
              ],
            ),
          ),
          // Expanded gives the scroll view the rest of the screen. A
          // scrollable inside a Column needs a bounded height, like any
          // nested scrollable.
          Expanded(
            child: SingleChildScrollView(
              controller: controller,
              padding: const EdgeInsets.all(24),
              child: DemoWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 1; i <= 50; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Block(
                          // Only the target gets the key (and the green).
                          key: i == target ? targetKey : null,
                          color: i == target ? highlightColor : childColor,
                          height: 56,
                          label: 'Item $i',
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

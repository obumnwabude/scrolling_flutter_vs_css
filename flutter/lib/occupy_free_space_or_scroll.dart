import 'package:flutter/material.dart';

import 'common.dart';

/// A layout that stretches one child to fill the free space when the content
/// is short, and scrolls when the content is taller than the container.
///
/// Think of a sign-up form with its button pinned to the bottom of the
/// screen on a tall phone, which still scrolls on a short one.
///
/// You can't just put a [Column] with an [Expanded] child inside a
/// [SingleChildScrollView]. The scroll view gives the column infinite
/// height, and [Expanded] can't fill infinite space, so Flutter throws an
/// error.
///
/// [SliverFillRemaining] with `hasScrollBody: false` solves this. It gives
/// its child at least the height left in the viewport, or more if the child
/// needs it. Inside, the [Column] and [Expanded] work as usual.
///
/// In CSS, it is a flex column with `flex: 1` on the filler and
/// `overflow: auto` on the container. CSS doesn't need a special widget,
/// because a flex column with a fixed height already knows its free space.
///
/// Tap "Add item" until the items no longer fit, and the container scrolls.
class OccupyFreeSpaceOrScroll extends StatefulWidget {
  const OccupyFreeSpaceOrScroll({super.key});

  @override
  State<OccupyFreeSpaceOrScroll> createState() =>
      _OccupyFreeSpaceOrScrollState();
}

class _OccupyFreeSpaceOrScrollState extends State<OccupyFreeSpaceOrScroll> {
  /// How many red items sit above the filler.
  int items = 1;

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Occupy Free Space or Scroll',
      api: 'SliverFillRemaining + Expanded',
      actions: [
        TextButton(
          onPressed: () => setState(() => items++),
          child: const Text('Add item'),
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: DemoWidth(
          // The container: a fixed height, so there is free space to fill.
          child: Block(
            color: containerColor,
            height: MediaQuery.sizeOf(context).height * 0.7,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    // false: the child is a plain box (our Column), not
                    // another scrollable. That lets the sliver grow past the
                    // viewport when the Column needs more room.
                    hasScrollBody: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < items; i++) ...[
                          const Block(color: childColor, height: 64),
                          const SizedBox(height: 16),
                        ],
                        // Expanded takes whatever height is left, like
                        // `flex: 1` in CSS. The ConstrainedBox keeps it at
                        // least 120 tall, like `flex-basis: 120px`.
                        Expanded(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 120),
                            child: const Block(
                              color: highlightColor,
                              label: 'Filler',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Block(color: childColor, height: 64),
                      ],
                    ),
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

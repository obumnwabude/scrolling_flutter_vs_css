import 'package:flutter/material.dart';

import 'common.dart';

/// Scrollables inside a scrollable.
///
/// A scrollable takes all the space it is given in its scroll direction.
/// Inside another scrollable, that space is infinite, so Flutter throws an
/// error ("Vertical viewport was given unbounded height") instead of
/// guessing. You have three ways out:
///
///  1. Give the inner scrollable a fixed size in the direction that is
///     unbounded. A vertical list inside a vertical list needs a height. A
///     horizontal list inside a vertical list needs a height too, because
///     its items take its full height.
///  2. Let the inner list grow to fit its items with `shrinkWrap: true`, so
///     only the outer list scrolls.
///  3. Put everything in one [CustomScrollView] as slivers. See the
///     Sticky Section Headers demo for an example.
///
/// CSS has the same rule in a softer form. A box only scrolls if it has a
/// height (or width) and an `overflow`. Without them, it simply grows to fit
/// its content, with no error.
class NestedScrolling extends StatelessWidget {
  const NestedScrolling({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Nested Scrolling',
      api: 'fixed height · shrinkWrap · slivers',
      // The outer list. It scrolls the whole screen.
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          DemoWidth(child: _SameDirection()),
          SizedBox(height: 32),
          _OppositeDirection(),
          SizedBox(height: 32),
          DemoWidth(child: _ShrinkWrapped()),
        ],
      ),
    );
  }
}

/// A small heading above each example.
class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

/// Vertical inside vertical: give the inner list a fixed height.
class _SameDirection extends StatelessWidget {
  const _SameDirection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Label('Vertical in vertical (fixed height)'),
        // The fixed height (280) bounds the inner list. Remove it and
        // Flutter throws the "unbounded height" error. In CSS, this box has
        // `height: 280px; overflow-y: auto`.
        Block(
          color: containerColor,
          height: 280,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: 20,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, index) =>
                Block(color: childColor, height: 56, label: 'Inner ${index + 1}'),
          ),
        ),
      ],
    );
  }
}

/// Horizontal inside vertical: give the inner list a fixed height.
class _OppositeDirection extends StatelessWidget {
  const _OppositeDirection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Label('Horizontal in vertical (fixed height)'),
        // The inner list scrolls sideways, but the outer list gives it
        // unbounded *height*. The SizedBox bounds it.
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 12,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, index) =>
                Block(color: childColor, width: 120, label: '${index + 1}'),
          ),
        ),
      ],
    );
  }
}

/// Let the inner list grow to fit its items, so only the outer list scrolls.
///
/// `shrinkWrap: true` sizes the list to its content, and
/// [NeverScrollableScrollPhysics] stops it from scrolling on its own. This is
/// what CSS does by default when a box has no height.
///
/// A shrink-wrapped list builds every item up front, even the ones off
/// screen. That is fine for a handful of items. For long lists, use slivers
/// in a single [CustomScrollView] instead.
class _ShrinkWrapped extends StatelessWidget {
  const _ShrinkWrapped();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Label('Grows with its content (shrinkWrap)'),
        // No height on this Block: the list inside decides it.
        Block(
          color: containerColor,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: 8,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, index) =>
                Block(color: childColor, height: 56, label: 'Item ${index + 1}'),
          ),
        ),
      ],
    );
  }
}

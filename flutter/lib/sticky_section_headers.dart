import 'package:flutter/material.dart';

import 'common.dart';

/// Section headers that stick to the top while their section is on screen,
/// then get pushed away by the next section's header. Think of the letters
/// in a contacts list.
///
/// In CSS, every header gets `position: sticky; top: 0`. A sticky element
/// never leaves its parent, so each header lets go when its section ends.
///
/// In Flutter, [SliverMainAxisGroup] does the same job as the section's
/// parent element. It groups a header and a list into one sliver, and a
/// [PinnedHeaderSliver] inside it stays pinned only while its group is on
/// screen.
class StickySectionHeaders extends StatelessWidget {
  const StickySectionHeaders({super.key});

  static const sections = ['A', 'B', 'C', 'D', 'E'];

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Sticky Section Headers',
      api: 'SliverMainAxisGroup + PinnedHeaderSliver',
      body: DemoWidth(
        child: CustomScrollView(
          slivers: [
            // One group per section, like one <section> per section in HTML.
            for (final section in sections)
              SliverMainAxisGroup(
                slivers: [
                  // The header, pinned only within its group.
                  PinnedHeaderSliver(
                    child: Block(color: highlightColor, height: 48, label: 'Section $section'),
                  ),
                  // The section's items. SliverList.separated is the sliver
                  // version of ListView.separated, and it builds lazily too.
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    sliver: SliverList.separated(
                      itemCount: 6,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (_, index) => Block(color: childColor, height: 56, label: '$section${index + 1}'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

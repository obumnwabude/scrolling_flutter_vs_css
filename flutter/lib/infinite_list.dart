import 'package:flutter/material.dart';

import 'common.dart';

/// A long list that only builds what is on screen, and loads more items as
/// you near the end. Think of a social media feed.
///
/// Two separate ideas meet here:
///  * Lazy building. [ListView.builder] only calls `itemBuilder` for items
///    on (or near) the screen, and throws away the ones that scroll far off.
///    So 10 or 10,000 items cost about the same. A plain `ListView(children:
///    [...])` builds every child up front.
///  * Loading more. A [ScrollController] listener checks how much is left
///    below the screen (`extentAfter`), and fetches the next page when it is
///    close to the end.
///
/// The browser always builds every element, but `content-visibility: auto`
/// lets it skip the layout and painting of off-screen ones. To load more,
/// an `IntersectionObserver` watches a "Loading..." line at the end of the
/// list, and fires when it comes near the screen.
class InfiniteList extends StatefulWidget {
  const InfiniteList({super.key});

  @override
  State<InfiniteList> createState() => _InfiniteListState();
}

class _InfiniteListState extends State<InfiniteList> {
  static const pageSize = 20;

  /// Where our pretend server runs out of items.
  static const maxItems = 200;

  final controller = ScrollController();

  /// How many items are loaded so far.
  int count = pageSize;

  /// Whether a page is on its way. Stops one scroll from loading many pages.
  bool loading = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    // Load the next page when less than 300 pixels are left below the
    // screen, so the user rarely sees the spinner. Like `rootMargin: 300px`
    // on the IntersectionObserver in the CSS demo.
    if (controller.position.extentAfter < 300) loadMore();
  }

  Future<void> loadMore() async {
    if (loading || count >= maxItems) return;
    setState(() => loading = true);
    // Pretend to fetch the next page from a server.
    await Future<void>.delayed(const Duration(milliseconds: 800));
    // The user may have left the screen while we waited.
    if (!mounted) return;
    setState(() {
      count += pageSize;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasMore = count < maxItems;
    return DemoPage(
      title: 'Infinite List',
      api: 'ListView.builder + ScrollController',
      body: ListView.builder(
        controller: controller,
        padding: const EdgeInsets.all(24),
        // One more than the items, for the spinner (or "No more items")
        // at the end.
        itemCount: count + 1,
        // Called only for items near the screen. Add a print() here and
        // scroll, to watch items being built.
        itemBuilder: (_, index) {
          if (index == count) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(child: hasMore ? const CircularProgressIndicator() : const Text('No more items')),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: DemoWidth(
              child: Block(color: childColor, height: 56, label: 'Item ${index + 1}'),
            ),
          );
        },
      ),
    );
  }
}

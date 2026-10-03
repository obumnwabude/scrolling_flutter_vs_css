import 'package:flutter/material.dart';

import 'common.dart';

/// Pull down at the top of a list to reload it. Think of an inbox.
///
/// [RefreshIndicator] wraps a scrollable. When the user pulls past the top,
/// it shows a spinner and calls `onRefresh`. The spinner stays until the
/// [Future] that `onRefresh` returns completes.
/// `RefreshIndicator.adaptive` shows the iOS-style spinner on iOS and macOS.
///
/// Browsers only offer pull-to-refresh for the whole page, and it reloads
/// the page. For a list inside the page, the CSS demo turns off the
/// browser's own with `overscroll-behavior-y: contain`, and builds the pull
/// with touch events in JavaScript. That's the one demo where Flutter does
/// far more for you than the web platform.
class PullToRefresh extends StatefulWidget {
  const PullToRefresh({super.key});

  @override
  State<PullToRefresh> createState() => _PullToRefreshState();
}

class _PullToRefreshState extends State<PullToRefresh> {
  /// How many times the list was refreshed, shown in the first item.
  int refreshes = 0;

  Future<void> refresh() async {
    // Pretend to fetch fresh data from a server.
    await Future<void>.delayed(const Duration(seconds: 1));
    // The user may have left the screen while we waited.
    if (mounted) setState(() => refreshes++);
  }

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Pull to Refresh',
      api: 'RefreshIndicator(onRefresh)',
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.separated(
          // A list too short to scroll ignores drags, so the user couldn't
          // pull it. These physics let it be dragged anyway.
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          itemCount: 15,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, index) => DemoWidth(
            child: Block(
              color: index == 0 ? highlightColor : childColor,
              height: 56,
              label: index == 0 ? 'Refreshed $refreshes ${refreshes == 1 ? 'time' : 'times'}' : 'Item $index',
            ),
          ),
        ),
      ),
    );
  }
}

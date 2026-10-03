import 'package:flutter/material.dart';

import 'common.dart';

/// A scrollbar with your own colors, thickness, and shape, which is always
/// visible.
///
/// On desktop and the web, Flutter adds a scrollbar to scrollables for you.
/// On phones, it doesn't. To show one everywhere, or to style it, wrap the
/// scrollable yourself:
///  * [Scrollbar] follows the Material theme (and looks native on iOS).
///  * [RawScrollbar], used here, takes colors and sizes directly.
///
/// To style every scrollbar in an app at once, set `ThemeData.scrollbarTheme`
/// instead.
///
/// In CSS, `scrollbar-color` sets the thumb and track colors, and
/// `scrollbar-width` sets `auto`, `thin`, or `none`. CSS can't set an exact
/// thickness or a corner radius. The older `::-webkit-scrollbar`
/// pseudo-elements can, in Chrome and Safari only.
class CustomScrollbar extends StatefulWidget {
  const CustomScrollbar({super.key});

  @override
  State<CustomScrollbar> createState() => _CustomScrollbarState();
}

class _CustomScrollbarState extends State<CustomScrollbar> {
  // The scrollbar and the list must share a controller, so the scrollbar
  // knows how far the list has scrolled, and can move it when dragged.
  final controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Custom Scrollbar',
      api: 'RawScrollbar(thumbColor, trackColor, thickness)',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: DemoWidth(
          child: Block(
            color: containerColor,
            height: MediaQuery.sizeOf(context).height * 0.7,
            child: RawScrollbar(
              controller: controller,
              // Always show the thumb and the track, instead of fading them
              // out when you stop scrolling. Like `overflow-y: scroll`.
              thumbVisibility: true,
              trackVisibility: true,
              thickness: 12,
              radius: const Radius.circular(6),
              thumbColor: highlightColor,
              trackColor: Colors.lightBlue.shade100,
              child: ListView.separated(
                controller: controller,
                // Extra padding on the right keeps items clear of the bar.
                padding: const EdgeInsets.fromLTRB(16, 16, 32, 16),
                itemCount: 30,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (_, index) => Block(
                  color: childColor,
                  height: 56,
                  label: 'Item ${index + 1}',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

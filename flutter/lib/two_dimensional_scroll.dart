import 'package:flutter/material.dart';

import 'common.dart';

/// A grid larger than the screen in both directions. Think of a spreadsheet
/// or a seating chart.
///
/// In CSS, one box with `overflow: auto` scrolls both ways at once, even
/// diagonally on a trackpad.
///
/// A Flutter scrollable scrolls along one axis. The simplest way to scroll
/// both ways is to nest a horizontal scrollable inside a vertical one. Each
/// drag moves one direction at a time, and every cell is built up front, so
/// keep it for small grids.
///
/// For large grids, [TwoDimensionalScrollView] builds only the visible cells
/// and can scroll diagonally. It is a base class you extend with your own
/// layout. The `TableView` widget from the two_dimensional_scrollables
/// package, by the Flutter team, is a ready-made one.
class TwoDimensionalScroll extends StatelessWidget {
  const TwoDimensionalScroll({super.key});

  static const rows = 30;
  static const columns = 12;

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Two-Dimensional Scroll',
      api: 'Axis.vertical + Axis.horizontal',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Block(
          color: containerColor,
          // The outer scrollable moves up and down.
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            // The inner scrollable moves left and right. Its child can be as
            // wide as it likes: the grid below is 12 cells wide.
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  for (var row = 0; row < rows; row++)
                    Row(
                      children: [
                        for (var column = 0; column < columns; column++)
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Block(
                              color: childColor,
                              width: 96,
                              height: 48,
                              // Spreadsheet-style names: A1, B1, ... L30.
                              // 65 is the character code of "A".
                              label: '${String.fromCharCode(65 + column)}${row + 1}',
                            ),
                          ),
                      ],
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

import 'package:flutter/material.dart';

import 'horizontal_scroll.dart';
import 'how_to_scroll.dart';
import 'nested_scrolling.dart';
import 'occupy_free_space_or_scroll.dart';
import 'pin_item_on_scroll.dart';
import 'prevent_scroll.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Scrolling Insights', home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    navigate(widget) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => widget));
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: const Text('Scrolling Insights'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => navigate(const HowToScroll()),
              child: const Text('How To Scroll'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => navigate(const HorizontalScroll()),
              child: const Text('Horizontal Scroll'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => navigate(const NestedScrolling()),
              child: const Text('Nested Scrolling'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => navigate(const PinItemOnScroll()),
              child: const Text('Pin Item on Scroll'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => navigate(const OccupyFreeSpaceOrScroll()),
              child: const Text('Occupy Free Space or Scroll'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => navigate(const PreventScroll()),
              child: const Text('Prevent Scroll'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'navigation.dart';

/// Scrolling Insights: Flutter vs CSS.
///
/// A small app with one screen per scrolling technique. Each screen has a
/// twin in the `css` folder, built with HTML and CSS, so you can compare how
/// both platforms achieve the same result.
///
/// The demos themselves are listed in `demos.dart`. The home screen and the
/// buttons that move between demos are in `navigation.dart`.
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

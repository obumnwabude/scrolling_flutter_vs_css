import 'package:flutter/material.dart';

class HorizontalScroll extends StatelessWidget {
  const HorizontalScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Horizontal Scroll')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        scrollDirection: Axis.horizontal,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: UnconstrainedBox(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue,
                ),
                height: MediaQuery.sizeOf(context).height * 0.4,
                width: MediaQuery.sizeOf(context).width * 3,
              ),
            ),
          )
        ],
      ),
    );
  }
}

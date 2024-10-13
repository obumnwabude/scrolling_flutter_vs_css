import 'package:flutter/material.dart';

class HowToScroll extends StatelessWidget {
  const HowToScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('How to Scroll')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: UnconstrainedBox(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 240),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue,
                ),
                height: MediaQuery.sizeOf(context).height * 3,
              ),
            ),
          )
        ],
      ),
    );
  }
}

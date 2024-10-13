import 'package:flutter/material.dart';

class PreventScroll extends StatelessWidget {
  const PreventScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prevent Scroll')),
      body: Column(children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          constraints: const BoxConstraints(maxWidth: 240),
          height: MediaQuery.sizeOf(context).height * 3,
          margin: const EdgeInsets.all(24),
        ),
      ]),
    );
  }
}

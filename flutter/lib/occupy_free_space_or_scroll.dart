import 'package:flutter/material.dart';

class OccupyFreeSpaceOrScroll extends StatelessWidget {
  const OccupyFreeSpaceOrScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Occupy Free Space or Scroll')),
      body: Container(
        constraints: const BoxConstraints(maxWidth: 240),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.blue,
        ),
        height: MediaQuery.sizeOf(context).height * 0.8,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(24),
        child: CustomScrollView(slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.red,
                  ),
                  height: 64,
                  margin: const EdgeInsets.only(bottom: 20),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green,
                    ),
                    height: 180,
                    margin: const EdgeInsets.only(bottom: 20),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.red,
                  ),
                  height: 64,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

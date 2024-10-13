import 'package:flutter/material.dart';

class PinItemOnScroll extends StatelessWidget {
  const PinItemOnScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pin Item on Scroll')),
      body: Container(
        constraints: const BoxConstraints(maxWidth: 240),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.blue,
        ),
        height: MediaQuery.sizeOf(context).height * 0.8,
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(24),
        child: CustomScrollView(slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.red,
              ),
              height: MediaQuery.sizeOf(context).height,
              margin: const EdgeInsets.only(bottom: 32),
            ),
          ),
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.green,
            pinned: true,
            expandedHeight: 180,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            toolbarHeight: 180,
            // flexibleSpace: FlexibleSpaceBar(
            //   title: const Text('Pin Item on Scroll'),
            // ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.red,
              ),
              height: MediaQuery.sizeOf(context).height,
              margin: const EdgeInsets.only(top: 64, bottom: 32),
            ),
          ),
        ]),
      ),
    );
  }
}

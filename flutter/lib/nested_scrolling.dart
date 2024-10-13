import 'package:flutter/material.dart';

class NestedScrolling extends StatelessWidget {
  const NestedScrolling({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nested Scrolling')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Vertical Parent Vertical Child,
          Align(
            alignment: Alignment.topLeft,
            child: UnconstrainedBox(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 240),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue,
                ),
                height: MediaQuery.sizeOf(context).height * 1.5,
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 180),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.red,
                        ),
                        height: MediaQuery.sizeOf(context).height * 3,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Horizontal Parent Horizontal Child
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.4,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: UnconstrainedBox(
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.blue,
                      ),
                      width: MediaQuery.sizeOf(context).width * 1.5,
                      child: ListView(
                        padding: const EdgeInsets.all(24),
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            constraints: const BoxConstraints(maxHeight: 120),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.red,
                            ),
                            height: MediaQuery.sizeOf(context).height * 0.2,
                            width: MediaQuery.sizeOf(context).width * 3,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Vertical Parent Horizontal Child
          Align(
            alignment: Alignment.topLeft,
            child: UnconstrainedBox(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 240),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue,
                ),
                height: MediaQuery.sizeOf(context).height * 1.5,
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.4,
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    scrollDirection: Axis.horizontal,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 240),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.red,
                          ),
                          width: MediaQuery.sizeOf(context).width * 3,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Horizontal Parent Vertical Child
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.4,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: UnconstrainedBox(
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.blue,
                      ),
                      width: MediaQuery.sizeOf(context).width * 1.5,
                      child: ListView(
                        padding: const EdgeInsets.all(24),
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 180),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.red,
                              ),
                              height: MediaQuery.sizeOf(context).height * 3,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

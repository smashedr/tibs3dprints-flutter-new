import 'package:flutter/material.dart';

import 'stupid_page.dart';

class NewsPage extends StatelessWidget {
  final void Function(Widget?) onSubPageChange;

  const NewsPage({super.key, required this.onSubPageChange});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'No News is Good News But More Text',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              onSubPageChange(StupidPage(onBack: () => onSubPageChange(null)));
            },
            child: const Text('Vote'),
          ),
        ],
      ),
    );
  }
}

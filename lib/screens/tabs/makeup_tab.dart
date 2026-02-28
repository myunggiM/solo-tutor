import 'package:flutter/material.dart';

class MakeupTab extends StatelessWidget {
  const MakeupTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.brush, size: 64, color: Colors.deepPurple),
          SizedBox(height: 16),
          Text(
            '화장',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '화장법을 배워보세요',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

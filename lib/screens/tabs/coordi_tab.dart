import 'package:flutter/material.dart';

class CoordiTab extends StatelessWidget {
  const CoordiTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.checkroom, size: 64, color: Colors.deepPurple),
          SizedBox(height: 16),
          Text(
            '코디',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '나만의 코디를 만들어보세요',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

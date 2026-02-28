import 'package:flutter/material.dart';

class AppearanceTab extends StatelessWidget {
  const AppearanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.face, size: 64, color: Colors.deepPurple),
          SizedBox(height: 16),
          Text(
            '외모',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '외모 관리 팁을 확인하세요',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

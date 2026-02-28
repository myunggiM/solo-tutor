import 'package:flutter/material.dart';
import 'tabs/coordi_tab.dart';
import 'tabs/appearance_tab.dart';
import 'tabs/makeup_tab.dart';

/// 탭 바가 있는 기본 홈 화면
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<Tab> _tabs = const [
    Tab(icon: Icon(Icons.checkroom), text: '코디'),
    Tab(icon: Icon(Icons.face), text: '외모'),
    Tab(icon: Icon(Icons.brush), text: '화장'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solo Tutor'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          CoordiTab(),
          AppearanceTab(),
          MakeupTab(),
        ],
      ),
    );
  }
}

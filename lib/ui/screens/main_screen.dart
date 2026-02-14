import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merge_odyssey/core/providers/game_provider.dart';
import 'package:merge_odyssey/ui/screens/home_screen.dart';
import 'package:merge_odyssey/ui/screens/game_screen.dart';
import 'package:merge_odyssey/ui/screens/world_selection_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    WorldSelectionScreen(),
    GameScreen(), // This will be replaced with actual game instance
    Container(child: Center(child: Text('Shop'))),
    Container(child: Center(child: Text('Profile'))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Worlds'),
          BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: 'Play'),
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

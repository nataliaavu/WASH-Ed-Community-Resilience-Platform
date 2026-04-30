import 'package:flutter/material.dart';
import '../views/learn_page.dart';

/// Replace the placeholder widgets in `_pages` with your real pages from
/// `lib\views` (e.g. `HomePage()`, `ModulesPage()`, ...).
class AppNavigationBar extends StatefulWidget {
  const AppNavigationBar({Key? key}) : super(key: key);

  @override
  State<AppNavigationBar> createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends State<AppNavigationBar> {
  int _currentIndex = 0;

  // TODO: Replace these placeholders with your actual pages from
  // lib\views, e.g. `const HomePage()`.
  final List<Widget> _pages = const <Widget>[
    Center(child: Text('Home page')), // replace with HomePage()
    const LearnPage(), // Learn page with tabs
    Center(child: Text('Prepare page')), // replace with PreparePage()
    Center(child: Text('Profile page')), // replace with ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Modules',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Prepare',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wash_ed_app/views/onboarding/onboarding_page.dart';
import 'package:wash_ed_app/views/onboarding/init_page.dart';
import 'package:wash_ed_app/views/setup/setup_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WashEdApp());
}

class WashEdApp extends StatelessWidget {
  const WashEdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WASH-Ed Platform',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      initialRoute: '/init',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const AppMain(),
        '/init': (BuildContext context) => const InitScreen(),
        '/onboarding': (BuildContext context) => const OnboardingScreen(),
        '/setup': (BuildContext context) => const SetupPage(),
      },
    );
  }
}

/// Replace the placeholder widgets in `_pages` with your real pages from
/// `lib\views` (e.g. `HomePage()`, `ModulesPage()`, ...).
class AppMain extends StatefulWidget {
  const AppMain({super.key});

  @override
  State<AppMain> createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> {
  int _currentIndex = 0;

  // TODO: Replace these placeholders with your actual pages from
  // lib\views, e.g. `const HomePage()`.
  final List<Widget> _pages = const <Widget>[
    Center(child: Text('Home page')), // replace with HomePage()
    Center(child: Text('Modules page')), // replace with ModulesPage()
    Center(child: Text('Prepare page')), // replace with PreparePage()
    Center(child: Text('Profile page')), // replace with ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
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

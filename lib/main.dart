import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wash_ed_app/data/app_notifiers.dart';
import 'package:wash_ed_app/views/games/games_page.dart';
import 'package:wash_ed_app/views/home/home_page.dart';
import 'package:wash_ed_app/views/learn/learn_page.dart';
import 'package:wash_ed_app/views/onboarding/init_page.dart';
import 'package:wash_ed_app/views/onboarding/onboarding_page.dart';
import 'package:wash_ed_app/views/prepare/prepare_page.dart';
import 'package:wash_ed_app/views/profile.dart';
import 'package:wash_ed_app/views/setup/setup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  try {
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
    }
  } catch (_) {
    // No internet on first launch — app still works offline via SQLite.
  }
  runApp(const WashEdApp());
}

class WashEdApp extends StatelessWidget {
  const WashEdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WASH-Ed Platform',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/init',
      routes: <String, WidgetBuilder>{
        '/': (context) => const AppMain(),
        '/init': (context) => const InitScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/setup': (context) => const SetupPage(),
      },
    );
  }
}

class AppMain extends StatefulWidget {
  const AppMain({super.key});

  @override
  State<AppMain> createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    LearnPage(),
    PreparePage(),
    GamesPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    tabSwitchRequest.addListener(_onTabSwitch);
  }

  @override
  void dispose() {
    tabSwitchRequest.removeListener(_onTabSwitch);
    super.dispose();
  }

  void _onTabSwitch() {
    final idx = tabSwitchRequest.value;
    if (idx >= 0 && mounted) {
      setState(() => _currentIndex = idx);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFE91E8C),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Prepare',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_esports_outlined),
            activeIcon: Icon(Icons.sports_esports),
            label: 'Games',
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

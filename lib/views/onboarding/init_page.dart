import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  InitScreenState createState() => InitScreenState();
}

class InitScreenState extends State<InitScreen> {
  @override
  void initState() {
    super.initState();
    route();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Loading...')));
  }

  void route() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showOnboarding = !(prefs.getBool('isOnboarded') ?? false);

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    if (showOnboarding) {
      Navigator.pushNamed(context, '/onboarding');
    }
  }
}

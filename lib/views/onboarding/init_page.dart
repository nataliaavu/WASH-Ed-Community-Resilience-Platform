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
    return Container(
      decoration: const BoxDecoration(color: Color(0xFF1A47C8)),
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: Image.asset(
          "assets/wash-ed/WASHEd_logo_2022_og_drop-shadow.png",
        ),
      ),
    );
  }

  void route() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showOnboarding = !(prefs.getBool('userSetupFinished') ?? false);

    // Splash screen delay
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    String route = showOnboarding ? '/onboarding' : '/';
    Navigator.pushNamedAndRemoveUntil(context, route, (_) => false);
  }
}

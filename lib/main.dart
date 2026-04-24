import 'package:flutter/material.dart';
import 'package:wash_ed_app/views/onboarding/onboarding_page.dart';
import 'package:wash_ed_app/views/onboarding/init_page.dart';

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
        '/': (BuildContext context) => const OnboardingDemoPage(),
        '/init': (BuildContext context) => const InitScreen(),
        '/onboarding': (BuildContext context) => OnboardingScreen(),
      },
    );
  }
}

class OnboardingDemoPage extends StatefulWidget {
  const OnboardingDemoPage({super.key});

  @override
  OnboardingDemoPageState createState() => OnboardingDemoPageState();
}

class OnboardingDemoPageState extends State<OnboardingDemoPage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("onboarding demo"),
      ),
      body: Center(
        child: IntrinsicWidth(
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .stretch,
            children: [
              const Text('press button to launch onboarding screen'),
              FloatingActionButton(
                onPressed: () => Navigator.pushNamed(context, '/onboarding'),
                child: const Text('onboarding'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

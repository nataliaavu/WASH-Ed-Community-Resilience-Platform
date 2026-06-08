import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wash_ed_app/views/home/home_page.dart';

class TestHomePage extends StatefulWidget {
  final String riskLevel;
  final Function(int) onTabSelected;
  
  const TestHomePage({
    required this.riskLevel,
    required this.onTabSelected,
  });
  
  @override
  State<TestHomePage> createState() => _TestHomePageState();
}

class _TestHomePageState extends State<TestHomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final state = context.findAncestorStateOfType<State<HomePage>>();
    if (state != null && state.runtimeType.toString() == '_HomePageState') {
      (state as dynamic).riskLevel = widget.riskLevel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return HomePage(onTabSelected: widget.onTabSelected);
  }
}
void main() {
  testWidgets('HomePage renders main UI elements', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          onTabSelected: (_) {},
        ),
      ),
    );

    expect(find.text('Hello Miguel!'), findsOneWidget);

    expect(find.text('Learning Module'), findsOneWidget);
    expect(find.text('Flood Prep'), findsOneWidget);
    expect(find.text('Play Games'), findsOneWidget);

    expect(find.text('Risk'), findsOneWidget);

  });

  testWidgets('HomePage triggers navigation callback when Flood Prep is tapped', (WidgetTester tester) async {
    int? selectedIndex;
    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          onTabSelected: (index) {
            selectedIndex = index;
          },
        ),
      ),
    );
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Flood Prep'));
    await tester.pumpAndSettle();

    expect(selectedIndex, 3); // Assuming Flood Prep is at index 3
  });

  testWidgets('Risk bar shows LOW by default', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          onTabSelected: (_) {},
        ),
      ),
    );
    expect(find.byKey(const Key('risk-label')), findsOneWidget);
    expect(find.text('LOW'), findsOneWidget);
  });

  testWidgets('Risk bar turns orange when risk level is set to medium', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TestHomePage(
          riskLevel: 'medium',
          onTabSelected: (_) {},
        ),
      ),
    );
    final bar = tester.widget<Container>(find.byKey(const Key('risk-bar-fill')));
    final boxDecoration = bar.decoration as BoxDecoration;
    expect(boxDecoration.color, Colors.orange); // MEDIUM risk should be orange
  });

  testWidgets('Risk bar turns red when risk level is set to high', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TestHomePage(
          riskLevel: 'high',
          onTabSelected: (_) {},
        ),
      ),
    );
    final bar = tester.widget<Container>(find.byKey(const Key('risk-bar-fill')));
    final boxDecoration = bar.decoration as BoxDecoration;
    expect(boxDecoration.color, Colors.red); // HIGH risk should be red
  });

  testWidgets('Risk bar color changes based on risk level', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          onTabSelected: (_) {},
        ),
      ),
    );
    final riskBox = tester.widget<Container>(find.byKey(const Key('risk-bar-fill')));
    final boxDecoration = riskBox.decoration as BoxDecoration;
    expect(boxDecoration.color, Colors.green); // LOW risk should be green
  });

  testWidgets('Kiko is greenish when risk level is low', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TestHomePage(
          riskLevel: 'low',
          onTabSelected: (_) {},
        ),
      ),
    );
    final box = tester.widget<Container>(find.byType(Container).at(2));
    final decoration = box.decoration as BoxDecoration;
    expect(decoration.color, Color.fromARGB(255, 195, 235, 154));
  });

  testWidgets('Kiko is yellow when risk level is medium', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TestHomePage(
          riskLevel: 'medium',
          onTabSelected: (_) {},
        ),
      ),
    );
    final box = tester.widget<Container>(find.byType(Container).at(2));
    final decoration = box.decoration as BoxDecoration;
    expect(decoration.color, Color.fromARGB(255, 249, 201, 110)); 
  });

  testWidgets('Kiko is red when risk level is high', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TestHomePage(
          riskLevel: 'high',
          onTabSelected: (_) {},
        ),
      ),
    );
    final box = tester.widget<Container>(find.byType(Container).at(2));
    final decoration = box.decoration as BoxDecoration;
    expect(decoration.color, Color.fromARGB(255, 250, 119, 110)); 
  });

  testWidgets('KikoBox shows LOW message', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TestHomePage(
          riskLevel: 'low',
          onTabSelected: (_) {},
        ),
      ),
    );
    
    expect(find.text('Everything is looking safe right now!'), findsOneWidget); 
  });


  testWidgets('KikoBox shows MEDIUM message', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TestHomePage(
          riskLevel: 'medium',
          onTabSelected: (_) {},
        ),
      ),
    );
    
    expect(find.text('Water levels are rising slightly'), findsOneWidget); 
  });


  testWidgets('KikoBox shows HIGH message', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TestHomePage(
          riskLevel: 'high',
          onTabSelected: (_) {},
        ),
      ),
    );
    
    expect(find.text('Flood risk is high. Stay safe and follow instructions!'), findsOneWidget); 
  });
}
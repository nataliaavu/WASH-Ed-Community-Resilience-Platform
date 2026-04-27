import 'package:flutter/material.dart';
import 'package:wash_ed_app/views/setup/setup_location_page.dart';
import 'package:wash_ed_app/views/setup/setup_name_page.dart';
import 'package:wash_ed_app/views/setup/setup_role_page.dart';
import 'package:wash_ed_app/views/setup/setup_squad_page.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => SetupPageState();
}

class SetupPageState extends State<SetupPage> {
  late PageController _pageViewController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          PageView(
            /// [PageView.scrollDirection] defaults to [Axis.horizontal].
            /// Use [Axis.vertical] to scroll vertically.
            controller: _pageViewController,
            onPageChanged: _handlePageViewChanged,
            children: <Widget>[
              SetupRolePage(),
              SetupNamePage(),
              SetupLocationPage(),
              SetupSquadPage(),
            ],
          ),
          NavigationButtons(
            currentPageIndex: _currentPageIndex,
            onUpdateCurrentPageIndex: _updateCurrentPageIndex,
          ),
        ],
      ),
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _updateCurrentPageIndex(int index) {
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}

class NavigationButtons extends StatelessWidget {
  const NavigationButtons({
    super.key,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
  });

  final int currentPageIndex;
  final void Function(int) onUpdateCurrentPageIndex;

  @override
  Widget build(BuildContext context) {
    // TODO: refactor colors into theme
    // final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.all(40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Color(0xFF_DDDDDF)),
              foregroundColor: WidgetStatePropertyAll(Color(0xFF_1A1A2E)),
            ),
            onPressed: () {
              if (currentPageIndex > 0) {
                onUpdateCurrentPageIndex(currentPageIndex - 1);
              }
            },
            child: const Text("Back"),
          ),
          Spacer(),
          TextButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Color(0xFF_E8177A)),
              foregroundColor: WidgetStatePropertyAll(Color(0xFF_F7F8FC)),
            ),
            onPressed: () {
              if (currentPageIndex < 4) {
                onUpdateCurrentPageIndex(currentPageIndex + 1);
              }
            },
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }
}

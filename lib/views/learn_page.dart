import 'package:flutter/material.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        top: true,
        child: Column(
          children: [
            Material(
              color: Theme.of(context).colorScheme.surface,
              child: TabBar(
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Theme.of(context).colorScheme.primary,
                tabs: const [
                  Tab(text: 'Modules'),
                  Tab(text: 'Resources'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Modules tab content
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: const [
                      ListTile(title: Text('Module 1')),
                      ListTile(title: Text('Module 2')),
                      ListTile(title: Text('Module 3')),
                    ],
                  ),

                  // Resources tab content
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: const [
                      ListTile(title: Text('Resource A')),
                      ListTile(title: Text('Resource B')),
                      ListTile(title: Text('Resource C')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

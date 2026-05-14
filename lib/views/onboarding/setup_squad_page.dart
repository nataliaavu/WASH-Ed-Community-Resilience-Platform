import 'package:flutter/material.dart';

class SetupSquadPage extends StatefulWidget {
  const SetupSquadPage({super.key});

  @override
  State<SetupSquadPage> createState() => SetupSquadPageState();
}

class SetupSquadPageState extends State<SetupSquadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE3F2FD), Color(0xFFFFFDE7)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),
                const Text(
                  "Safety Squad",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF_1A45A0),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Add your trusted 'heroes' to join your safety squad! These are who you call in case of an emergency.",
                    textAlign: TextAlign.center,
                  ),
                ),
                _buildSquadForm(),
                const SizedBox(height: 20),
                _buildAddHeroButton(),
                const SizedBox(height: 20),
                const Text(
                  "You can add or change these\nlater in settings",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Color(0xFF_666666)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSquadForm() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Hero Name",
            style: TextStyle(
              color: Color(0xFF_1A45A0),
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Name",
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade300),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Phone Number",
            style: TextStyle(
              color: Color(0xFF_1A45A0),
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "09XX XXX XXX",
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade300),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddHeroButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue.withAlpha(5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue, style: BorderStyle.solid),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, color: Color(0xFF_1A45A0)),
          Text(
            "Add New Hero",
            style: TextStyle(
              color: Color(0xFF_1A45A0),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

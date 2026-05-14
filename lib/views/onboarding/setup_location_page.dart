import 'package:flutter/material.dart';

class SetupLocationPage extends StatefulWidget {
  const SetupLocationPage({super.key});

  @override
  State<SetupLocationPage> createState() => SetupLocationPageState();
}

class SetupLocationPageState extends State<SetupLocationPage> {
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
          child: Column(
            children: [
              const SizedBox(height: 80),
              const Text(
                "Select Your Location",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF_1A45A0),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Let us know where to watch for floods so we can send  warnings for floods near you!",
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text("Choose your city or district"),
                      items: const [], // TODO: add locations
                      onChanged: (val) {},
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

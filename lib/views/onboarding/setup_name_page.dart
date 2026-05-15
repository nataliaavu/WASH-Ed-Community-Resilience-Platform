import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupNamePage extends StatefulWidget {
  const SetupNamePage({super.key});

  @override
  State<SetupNamePage> createState() => SetupNamePageState();
}

class SetupNamePageState extends State<SetupNamePage> {
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
          child: Padding(
            padding: EdgeInsetsGeometry.fromLTRB(40, 20, 40, 80),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: CustomPaint(
                    foregroundPainter: SpeechBubbleTrianglePainter(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 10),
                        ],
                      ),
                      child: Center(
                        child: const Text(
                          "Hello I'm Kiko!\nWhat's your name?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF_1A45A0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(flex: 1),
                Expanded(
                  flex: 10,
                  child: Image.asset(
                    "assets/kiko/WashEd_kiko_sprite_cheer.png",
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 2,
                  child: TextField(
                    onSubmitted: _onSubmitted,
                    decoration: InputDecoration(
                      hintText: "Type your name here",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmitted(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("setup.name", name);
  }
}

class SpeechBubbleTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Colors.white;

    final double h = 20;
    final double w = 20;
    final double width = size.width;
    final double height = size.height;

    final Path path = Path()
      ..moveTo(width / 2 - w / 2, height)
      ..lineTo(width / 2, h + height)
      ..lineTo(width / 2 + w / 2, height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

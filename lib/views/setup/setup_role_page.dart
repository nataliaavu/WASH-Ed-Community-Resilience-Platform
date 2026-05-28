import 'package:flutter/material.dart';

class SetupRolePage extends StatelessWidget {
  final String selectedRole;
  final ValueChanged<String> onRoleSelected;

  const SetupRolePage({
    super.key,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFCE4EC), Color(0xFFF3E5F5)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            children: [
              const SizedBox(height: 52),
              const Text(
                'Welcome to\nKiko\'s Hub!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A45A0),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Choose your role to start your\nlearning journey with Kiko.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 44),
              _roleCard('I am an Educator', 'educator', Icons.groups),
              const SizedBox(height: 18),
              _roleCard('I am a Student', 'student', Icons.school),
              const SizedBox(height: 18),
              _roleCard('I am a Parent', 'parent', Icons.supervisor_account),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleCard(String title, String role, IconData icon) {
    final selected = selectedRole == role;
    return GestureDetector(
      onTap: () => onRoleSelected(role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? const Color(0xFFE91E8C) : Colors.transparent,
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? const Color(0xFFE91E8C).withValues(alpha: 0.25)
                  : Colors.black12,
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFFE91E63),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: selected
                    ? const Color(0xFFE91E8C)
                    : const Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

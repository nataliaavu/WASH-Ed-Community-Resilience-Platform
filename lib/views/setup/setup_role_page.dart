import 'package:flutter/material.dart';
import 'package:wash_ed_app/config/app_theme.dart';

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
    // No background — parent setup_page.dart provides the gradient
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 52, 28, 24),
      child: Column(
        children: [
          Text(
            'Welcome to\nKiko\'s Hub!',
            textAlign: TextAlign.center,
            style: AppTextStyles.h1Blue.copyWith(fontSize: 36, height: 1.2),
          ),
          const SizedBox(height: 14),
          Text(
            'Choose your role to start your\nlearning journey with Kiko.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.textMid),
          ),
          const SizedBox(height: 44),
          _roleCard('I am an Educator', 'educator', Icons.groups),
          const SizedBox(height: 18),
          _roleCard('I am a Student', 'student', Icons.school),
          const SizedBox(height: 18),
          _roleCard('I am a Parent', 'parent', Icons.supervisor_account),
          const SizedBox(height: 24),
        ],
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
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppColors.brandPink : Colors.transparent,
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? AppColors.brandPink.withValues(alpha: 0.25)
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
              backgroundColor: AppColors.brandPink,
              child: Icon(icon, color: AppColors.white, size: 30),
            ),
            const SizedBox(width: 20),
            Text(
              title,
              style: AppTextStyles.h3.copyWith(
                fontSize: 22,
                color: selected ? AppColors.brandPink : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
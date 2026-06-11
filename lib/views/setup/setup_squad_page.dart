import 'package:flutter/material.dart';
import 'package:wash_ed_app/config/app_theme.dart';
import 'package:wash_ed_app/models/squad_member.dart';

class SetupSquadPage extends StatefulWidget {
  final List<SquadMember> members;
  final ValueChanged<List<SquadMember>> onMembersChanged;

  const SetupSquadPage({
    super.key,
    required this.members,
    required this.onMembersChanged,
  });

  @override
  State<SetupSquadPage> createState() => _SetupSquadPageState();
}

class _SetupSquadPageState extends State<SetupSquadPage> {
  late List<_MemberForm> _forms;

  @override
  void initState() {
    super.initState();
    if (widget.members.isNotEmpty) {
      _forms = widget.members
          .map((m) => _MemberForm(
                heroCtrl: TextEditingController(text: m.heroName),
                phoneCtrl: TextEditingController(text: m.phoneNumber),
              ))
          .toList();
    } else {
      _forms = [_MemberForm.blank()];
    }
  }

  @override
  void dispose() {
    for (final f in _forms) {
      f.heroCtrl.dispose();
      f.phoneCtrl.dispose();
    }
    super.dispose();
  }

  void _addForm() {
    setState(() => _forms.add(_MemberForm.blank()));
  }

  void _removeForm(int index) {
    _forms[index].heroCtrl.dispose();
    _forms[index].phoneCtrl.dispose();
    setState(() => _forms.removeAt(index));
    _notify();
  }

  // ── Squad save logic — untouched ─────────────────────────────────────────

  void _notify() {
    final members = _forms
        .map((f) => SquadMember(
              heroName: f.heroCtrl.text.trim(),
              phoneNumber: f.phoneCtrl.text.trim(),
            ))
        .toList();
    widget.onMembersChanged(members);
  }

  @override
  Widget build(BuildContext context) {
    // No background — parent setup_page.dart provides the gradient
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 44, 28, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Safety Squad',
            textAlign: TextAlign.center,
            style: AppTextStyles.h1Blue.copyWith(fontSize: 32),
          ),
          const SizedBox(height: 12),
          Text(
            "Add your trusted 'heroes' to join your safety squad!\n"
            "These are who you call in case of an emergency.",
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
                color: AppColors.textMid, height: 1.5),
          ),
          const SizedBox(height: 28),
          ..._forms.asMap().entries.map(
              (entry) => _buildMemberForm(entry.key, entry.value)),
          const SizedBox(height: AppSpacing.md),
          GestureDetector(
            onTap: _addForm,
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.brandBlue.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.brandBlue),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, color: AppColors.brandBlue, size: 22),
                  const SizedBox(height: 4),
                  Text(
                    'Add New Hero',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.brandBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'You can add or change these later in settings',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildMemberForm(int index, _MemberForm form) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.lightBlue.withValues(alpha: 0.3)),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hero Name',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.brandBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_forms.length > 1)
                GestureDetector(
                  onTap: () => _removeForm(index),
                  child: const Icon(Icons.close,
                      size: 20, color: AppColors.textMid),
                ),
            ],
          ),
          TextField(
            controller: form.heroCtrl,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Type in here',
              hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.textMid),
            ),
            onChanged: (_) => _notify(),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Phone Number',
            style: AppTextStyles.body.copyWith(
              color: AppColors.brandBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: form.phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: '09XX XXX XXX',
              hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.textMid),
            ),
            onChanged: (_) => _notify(),
          ),
        ],
      ),
    );
  }
}

class _MemberForm {
  final TextEditingController heroCtrl;
  final TextEditingController phoneCtrl;

  _MemberForm({required this.heroCtrl, required this.phoneCtrl});

  factory _MemberForm.blank() => _MemberForm(
        heroCtrl: TextEditingController(),
        phoneCtrl: TextEditingController(),
      );
}
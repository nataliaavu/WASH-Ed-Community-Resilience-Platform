import 'package:flutter/material.dart';
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFCE4EC), Color(0xFFF3E5F5)],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 44),
                const Text(
                  'Safety Squad',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A45A0),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Add your trusted 'heroes' to join your safety squad!\n"
                  "These are who you call in case of an emergency.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
                ),
                const SizedBox(height: 28),
                ..._forms.asMap().entries.map((entry) =>
                    _buildMemberForm(entry.key, entry.value)),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _addForm,
                  child: Container(
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A45A0).withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: const Color(0xFF1A45A0),
                          style: BorderStyle.solid),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Color(0xFF1A45A0), size: 22),
                        SizedBox(height: 4),
                        Text(
                          'Add New Hero',
                          style: TextStyle(
                            color: Color(0xFF1A45A0),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'You can add or change these later in settings',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.black45),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMemberForm(int index, _MemberForm form) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue.shade100),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Hero Name',
                style: TextStyle(
                  color: Color(0xFF1A45A0),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              if (_forms.length > 1)
                GestureDetector(
                  onTap: () => _removeForm(index),
                  child: const Icon(Icons.close, size: 20, color: Colors.grey),
                ),
            ],
          ),
          TextField(
            controller: form.heroCtrl,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Type in here',
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
            ),
            onChanged: (_) => _notify(),
          ),
          const SizedBox(height: 14),
          const Text(
            'Phone Number',
            style: TextStyle(
              color: Color(0xFF1A45A0),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          TextField(
            controller: form.phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: '09XX XXX XXX',
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
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

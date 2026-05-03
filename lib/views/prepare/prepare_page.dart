import 'package:flutter/material.dart';

class PreparePage extends StatefulWidget {
  const PreparePage({super.key});

  @override
  State<PreparePage> createState() => _PreparePageState();
}

class _PreparePageState extends State<PreparePage> {
  // Checklist items - content to be confirmed by WASH-Ed
  final List<Map<String, dynamic>> _checklist = [
    {
      'label': 'Store clean drinking water (1 gallon per person/day)',
      'checked': false,
    },
    {'label': 'Pack emergency food supplies (3-day supply)', 'checked': false},
    {'label': 'Prepare a first aid kit', 'checked': false},
  ];

  // Safety steps - content to be confirmed by WASH-Ed
  final List<String> _safetySteps = [
    'Move to higher ground immediately if water rises.',
    'Do not walk through floodwater as it may be contaminated.',
    'Turn off electricity at the main switch before leaving.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4FF), // light lavender background
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('Call for Help'),
                        const SizedBox(height: 10),
                        _buildEmergencyServicesCard(),
                        const SizedBox(height: 10),
                        _buildEmergencyContactsCard(),
                        const SizedBox(height: 24),
                        _buildSectionLabel('Quick Safety Steps'),
                        const SizedBox(height: 10),
                        ..._safetySteps.asMap().entries.map(
                          (e) => _buildSafetyStepCard(e.key + 1, e.value),
                        ),
                        const SizedBox(height: 24),
                        _buildChecklistSection(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── HEADER ──────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF3D5AFE), // blue from wireframe
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flood\nGuidance',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Stay calm, stay safe. Follow Kiko's\nsteps to stay safe!",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          // Kiko character — replace with Image.asset once team adds the asset
          SizedBox(
            width: 100,
            height: 110,
            child: Image.asset(
              'assets/kiko/WashEd_kiko_sprite_cheer.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  // ── SECTION LABEL ───────────────────────────────────────────────────────────

  Widget _buildSectionLabel(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF3D5AFE),
      ),
    );
  }

  // ── CALL FOR HELP CARDS ─────────────────────────────────────────────────────

  Widget _buildEmergencyServicesCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50), // very rounded like wireframe
        border: Border.all(color: const Color(0xFFFFCDD2)),
      ),
      child: Row(
        children: [
          // Red circle icon
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.phone, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emergency Services',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  'Police, Fire, Ambulance',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          // 911 in big bold red
          const Text(
            '911',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50), // very rounded like wireframe
        border: Border.all(color: const Color(0xFFFFCDD2)),
      ),
      child: Row(
        children: [
          // Lighter red/pink circle icon
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.red.shade300,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.people, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emergency Contacts',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  'Family and Friend Support',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  // ── QUICK SAFETY STEPS ──────────────────────────────────────────────────────

  Widget _buildSafetyStepCard(int number, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8EAFF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Blue rounded square number badge
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF3D5AFE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  // ── CHECKLIST ───────────────────────────────────────────────────────────────

  Widget _buildChecklistSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDE7), // pale yellow from wireframe
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFD54F)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Checklist',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3D5AFE),
            ),
          ),
          const SizedBox(height: 10),
          ..._checklist.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CheckboxListTile(
                value: item['checked'],
                onChanged: (val) {
                  setState(() {
                    _checklist[index]['checked'] = val;
                  });
                },
                title: Text(
                  item['label'],
                  style: TextStyle(
                    fontSize: 13,
                    decoration: item['checked'] == true
                        ? TextDecoration.lineThrough
                        : null,
                    color: item['checked'] == true
                        ? Colors.grey
                        : Colors.black87,
                  ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: const Color(0xFF3D5AFE),
                checkboxShape:
                    const CircleBorder(), // circle checkbox like wireframe
                side: const BorderSide(color: Colors.grey, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

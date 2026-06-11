import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PreparePage extends StatefulWidget {
  const PreparePage({super.key});

  @override
  State<PreparePage> createState() => _PreparePageState();
}

class _PreparePageState extends State<PreparePage> {

  Future<void> _callNumber(String number) async {

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Confirm Call"),
        content: Text("Are you sure you want to call $number?"),
        actions: [
          TextButton(
            onPressed: () async{
              Navigator.pop(context);
              final Uri uri = Uri(scheme: 'tel', path: number);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not launch phone dialer')),
                );
              }
            }, 
            child: const Text("Call"),
          ),
        ]
      )
    ); 
  }
  // Checklist items - content to be confirmed by WASH-Ed
  final List<Map<String, dynamic>> _checklist = [
    {'label': 'Water and snacks for 3 days', 'checked': false,},
    {'label': 'Important documents sealed in a plastic bag', 'checked': false,},
    {'label': 'Torch, extra clothes, and first aid kit', 'checked': false,},
    {'label': 'Power bank for your phone (if you have one)', 'checked': false,},
  ];

  // Safety steps - content to be confirmed by WASH-Ed
  final List<String> _safetySteps = [
    'Tell a trusted adult near you straight away',
    'Grab your emergency bag if you can, and move to higher ground',
    'Stay away from floodwater. It can be deep and dirty',
    'Listen to the adults around you and follow official instructions',
    'If told to evacuate, go with your family to somewhere safe and dry',
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8D5F0), Color(0xFFFFE4D6)],
          ),
        ),
        child: Column(
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
                          _buildSectionLabel('Need help? Call now'),
                          const SizedBox(height: 10),
                          
                        InkWell(
                          onTap: () => _callNumber('911'),
                          child: _buildEmergencyServicesCard(),
                        ),

                        const SizedBox(height: 10),
                        
                        InkWell(
                          onTap: () => _callNumber('143'),
                          child: _buildEmergencyContactsCard(),
                        ),

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
      ),
    );
  }
  // ── HEADER ──────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return SafeArea(
      bottom: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A47C8),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                    "Wherever you are, \n here's what to do!",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            // Kiko character — replace with Image.asset once asset added
            SizedBox(
              width: 150,
              height: 160,
              child: Image.asset(
                'assets/kiko/WashEd_kiko_sprite_cheer.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),      // closes Row
      ),        // closes Container
    );          // closes SafeArea
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
        color: const Color(0xFFFFCDD2),
        borderRadius: BorderRadius.circular(50), // rounded edge
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
                  style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 88, 88, 88)),
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
        color: const Color(0xFFFFCDD2),
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
              color: Colors.red,
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
                  'Philippine Red Cross',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  'Disaster Relief',
                  style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 88, 88, 88)),
                ),
              ],
            ),
          ),
          const Text(
            '143',
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
              color: const Color(0xFF1A47C8),
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
          const Text(
            'Pack a bag you can carry quickly if you need to leave home fast',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
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

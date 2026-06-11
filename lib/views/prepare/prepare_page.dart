import 'package:flutter/material.dart';
import 'package:wash_ed_app/config/app_theme.dart';
import 'package:wash_ed_app/views/profile/personal_details_page.dart';
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
    {'label': 'Water and snacks for 3 days', 'checked': false},
    {'label': 'Important documents sealed in a plastic bag', 'checked': false},
    {'label': 'Torch, extra clothes, and first aid kit', 'checked': false},
    {'label': 'Power bank for your phone (if you have one)', 'checked': false},
  ];

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
        decoration: const BoxDecoration(gradient: AppGradients.pageBg),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: AppSpacing.lg),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionLabel('Need help? Call now'),
                          const SizedBox(height: AppSpacing.sm),
                          _buildEmergencyServicesCard(),
                          const SizedBox(height: AppSpacing.sm),
                          _buildEmergencyContactsCard(),
                          const SizedBox(height: AppSpacing.sm),
                          _buildViewContactsButton(context),
                          const SizedBox(height: AppSpacing.lg),
                          _buildSectionLabel('Quick Safety Steps'),
                          const SizedBox(height: AppSpacing.sm),
                          ..._safetySteps.asMap().entries.map(
                                (e) => _buildSafetyStepCard(e.key + 1, e.value),
                              ),
                          const SizedBox(height: AppSpacing.lg),
                          _buildChecklistSection(),
                          const SizedBox(height: AppSpacing.lg),
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
        margin: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
        padding: const EdgeInsets.fromLTRB(20, AppSpacing.md, 20, AppSpacing.md),
        decoration: AppDecorations.blueHeader(radius: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Flood\nGuidance', style: AppTextStyles.h1White),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    "Wherever you are, here's what to do!",
                    style: AppTextStyles.bodyWhite,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 150,
              height: 160,
              child: Image.asset(
                'assets/kiko/WashEd_kiko_sprite_cheer.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── SECTION LABEL ───────────────────────────────────────────────────────────

  Widget _buildSectionLabel(String title) {
    return Text(title, style: AppTextStyles.h3Blue);
  }

  // ── CALL FOR HELP CARDS ─────────────────────────────────────────────────────

  Widget _buildEmergencyServicesCard() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: 14),
      decoration: AppDecorations.emergencyCard,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: AppColors.errorRed,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.phone, color: AppColors.white, size: 18),
          ),
          const SizedBox(width: AppSpacing.sm + 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Emergency Services',
                    style: AppTextStyles.body
                        .copyWith(fontWeight: FontWeight.bold)),
                Text('Police, Fire, Ambulance',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textMid)),
              ],
            ),
          ),
          Text(
            '911',
            style: AppTextStyles.h1White
                .copyWith(color: AppColors.errorRed, fontSize: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: 14),
      decoration: AppDecorations.emergencyCard,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: AppColors.errorRed,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.people, color: AppColors.white, size: 18),
          ),
          const SizedBox(width: AppSpacing.sm + 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Philippine Red Cross',
                    style: AppTextStyles.body
                        .copyWith(fontWeight: FontWeight.bold)),
                Text('Disaster Relief',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textMid)),
              ],
            ),
          ),
          Text(
            '143',
            style: AppTextStyles.h1White
                .copyWith(color: AppColors.errorRed, fontSize: 30),
          ),
        ],
      ),
    );
  }

  // ── VIEW EMERGENCY CONTACTS BUTTON ──────────────────────────────────────────

  Widget _buildViewContactsButton(BuildContext context) {
  return GestureDetector(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PersonalDetailsPage()),
    ),
    child: Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: 14),
      decoration: AppDecorations.emergencyCard,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: AppColors.errorRed,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.contacts_outlined,
                color: AppColors.white, size: 18),
          ),
          const SizedBox(width: AppSpacing.sm + 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('View Emergency Contacts',
                    style: AppTextStyles.body
                        .copyWith(fontWeight: FontWeight.bold)),
                Text('Your saved Safety Squad',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textMid)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right,
              color: AppColors.errorRed, size: 24),
        ],
      ),
    ),
  );
}

  // ── QUICK SAFETY STEPS ──────────────────────────────────────────────────────

  Widget _buildSafetyStepCard(int number, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: AppSpacing.md),
      decoration: AppDecorations.lightBorderCard(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.brandBlue,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              '$number',
              style: AppTextStyles.body.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(text, style: AppTextStyles.bodySmall),
          ),
        ],
      ),
    );
  }

  // ── CHECKLIST ───────────────────────────────────────────────────────────────

  Widget _buildChecklistSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppDecorations.checklistContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Checklist', style: AppTextStyles.h3Blue),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Pack a bag you can carry quickly if you need to leave home fast',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          ..._checklist.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
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
                  style: AppTextStyles.bodySmall.copyWith(
                    decoration: item['checked'] == true
                        ? TextDecoration.lineThrough
                        : null,
                    color: item['checked'] == true
                        ? AppColors.textMid
                        : AppColors.textDark,
                  ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: AppColors.brandBlue,
                checkboxShape: const CircleBorder(),
                side: const BorderSide(color: AppColors.textMid, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
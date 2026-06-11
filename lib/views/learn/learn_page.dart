// learn_page version 2
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wash_ed_app/config/app_theme.dart';
import 'package:wash_ed_app/controllers/api_controller.dart';
import 'package:wash_ed_app/data/app_notifiers.dart';
import 'package:wash_ed_app/data/database_helper.dart';
import 'package:wash_ed_app/models/module_model.dart';
import 'package:url_launcher/url_launcher.dart';

// ── Module group ──────────────────────────────────────────────────────────────

class _ModuleGroup {
  final LearningModule student;
  final LearningModule? teacher;
  const _ModuleGroup({required this.student, this.teacher});
}

List<_ModuleGroup> _groupModules(List<LearningModule> modules) {
  final studentMods = modules.where((m) => m.targetRole == 'student').toList();
  final teacherMods = modules.where((m) => m.targetRole == 'teacher').toList();
  return List.generate(
    studentMods.length,
    (i) => _ModuleGroup(
      student: studentMods[i],
      teacher: i < teacherMods.length ? teacherMods[i] : null,
    ),
  );
}

// ── LearnPage ─────────────────────────────────────────────────────────────────

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _api = ApiController();
  final _db = DatabaseHelper();

  List<_ModuleGroup> _groups = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
    profileRoleVersion.addListener(_onRoleChanged);
    _loadModules();
  }

  // Called when profileRoleVersion changes — resets loading state first
  // so the module list rebuilds correctly after a role switch.
  void _onRoleChanged() {
    setState(() => _loading = true);
    _loadModules();
  }

  Future<void> _loadModules() async {
    final profile = await _db.getUserProfile();
    final role = profile?.role ?? 'student';
    final modules = await _api.getModulesByRole(role);
    if (mounted) {
      setState(() {
        _groups = _groupModules(modules);
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    profileRoleVersion.removeListener(_onRoleChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.pageBg),
        child: SafeArea(
          child: Column(
            children: [
              _LearnTabBar(controller: _tabController),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _loading
                        ? const Center(
                            child: CircularProgressIndicator(
                                color: AppColors.brandPink),
                          )
                        : _ModuleListView(groups: _groups),
                    const _ResourcesTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Module list ───────────────────────────────────────────────────────────────

class _ModuleListView extends StatelessWidget {
  final List<_ModuleGroup> groups;
  const _ModuleListView({required this.groups});

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return Center(
        child: Text('No modules found.', style: AppTextStyles.h3Blue),
      );
    }
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _MascotHeader()),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.lg,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: _ModuleCard(group: groups[i], moduleNumber: i + 1),
              ),
              childCount: groups.length,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Module card ───────────────────────────────────────────────────────────────

class _ModuleCard extends StatelessWidget {
  final _ModuleGroup group;
  final int moduleNumber;

  const _ModuleCard({required this.group, required this.moduleNumber});

  void _open(BuildContext context, LearningModule module) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            PdfViewerPage(module: module, moduleNumber: moduleNumber),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasTeacher = group.teacher != null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: AppDecorations.yellowBorderCard(radius: AppRadius.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Module $moduleNumber', style: AppTextStyles.moduleLabel),
          const SizedBox(height: AppSpacing.xs),
          Text(group.student.title, style: AppTextStyles.h3),
          const SizedBox(height: AppSpacing.xs + 2),
          Text(
            group.student.description,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textDark.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 14),
          if (hasTeacher) ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _open(context, group.student),
                    icon: const Icon(Icons.person, size: 16),
                    label: const Text('Student'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textDark,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm + 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _open(context, group.teacher!),
                    icon: const Icon(Icons.school, size: 16),
                    label: const Text('Educator'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandPink,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm + 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _open(context, group.student),
                icon: const Icon(Icons.menu_book_rounded, size: 18),
                label: const Text('Open Module'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandPink,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm + 2),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Resources tab ─────────────────────────────────────────────────────────────

class _ResourcesTab extends StatelessWidget {
  const _ResourcesTab();

  static const List<Map<String, String>> _resources = [
    {
      'title': 'WASH-Ed',
      'description':
          'Explore our Learning Portal for videos and resources on clean water, handwashing, and staying healthy at school.',
      'url': 'https://www.wash-ed.org',
    },
    {
      'title': 'PAGASA Weather Forecasts',
      'description':
          'Access comprehensive weather forecasts, storm tracking, and typhoon updates directly from the national weather authority',
      'url': 'https://bagong.pagasa.dost.gov.ph/',
    },
    {
      'title': 'DepEd WinS (WASH in Schools)',
      'description':
          'Find official WASH resources, guides, and tools to support schools',
      'url': 'https://wins.deped.gov.ph/',
    },
    {
      'title': 'NDRRMC Disaster Alerts',
      'description':
          'Stay informed about emergencies and how to keep your family safe',
      'url': 'https://ndrrmc.gov.ph/',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _MascotHeader()),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.lg,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: _ResourceCard(
                  resourceNumber: i + 1,
                  title: _resources[i]['title']!,
                  description: _resources[i]['description']!,
                  url: _resources[i]['url']!,
                ),
              ),
              childCount: _resources.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final int resourceNumber;
  final String title;
  final String description;
  final String url;

  const _ResourceCard({
    required this.resourceNumber,
    required this.title,
    required this.description,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: AppDecorations.yellowBorderCard(radius: AppRadius.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Resource $resourceNumber', style: AppTextStyles.moduleLabel),
          const SizedBox(height: AppSpacing.xs),
          Text(title, style: AppTextStyles.h3),
          const SizedBox(height: AppSpacing.xs + 2),
          Text(
            description,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textDark.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandPink,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm + 2),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.open_in_new, size: 16),
                  SizedBox(width: AppSpacing.sm),
                  Text('Open Resource'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tab bar ───────────────────────────────────────────────────────────────────

class _LearnTabBar extends StatelessWidget {
  final TabController controller;
  const _LearnTabBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final activeIdx = controller.index;
    return Row(
      children: [
        _TabButton(
          label: 'Modules',
          isActive: activeIdx == 0,
          onTap: () => controller.animateTo(0),
        ),
        _TabButton(
          label: 'Resources',
          isActive: activeIdx == 1,
          onTap: () => controller.animateTo(1),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppColors.brandPink : AppColors.border,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 40,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              decoration: isActive
                  ? BoxDecoration(
                      color: AppColors.brandPink,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    )
                  : null,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: AppTextStyles.h3.copyWith(
                  color: isActive ? AppColors.white : AppColors.textDark,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Mascot header ─────────────────────────────────────────────────────────────

class _MascotHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: AppDecorations.blueHeader(radius: AppRadius.lg),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Let's Learn", style: AppTextStyles.h1White),
                const SizedBox(height: AppSpacing.xs + 2),
                Text(
                  'Discover how to stay safe, dry, and prepared for floods with our fun lessons!',
                  style: AppTextStyles.bodyWhite,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Image.asset(
            'assets/kiko/washed-kiko_sprite_learn-modules-resources.png',
            height: 150,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

// ── PDF Viewer Page ───────────────────────────────────────────────────────────

class PdfViewerPage extends StatefulWidget {
  final LearningModule module;
  final int moduleNumber;

  const PdfViewerPage({
    super.key,
    required this.module,
    required this.moduleNumber,
  });

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? _localPath;
  String? _error;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([.landscapeLeft, .landscapeRight]);
    _loadPdf();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([.portraitUp, .portraitDown]);
  }

  Future<void> _loadPdf() async {
    try {
      final bytes = await rootBundle.load(widget.module.assetPath);
      final dir = await getTemporaryDirectory();
      final filename = widget.module.assetPath.split('/').last;
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(bytes.buffer.asUint8List());
      if (mounted) setState(() => _localPath = file.path);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Module ${widget.moduleNumber}: ${widget.module.title}',
          style: AppTextStyles.h2White.copyWith(fontSize: 15),
        ),
        backgroundColor: AppColors.brandPink,
        foregroundColor: AppColors.white,
      ),
      body: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  'Could not load PDF:\n$_error',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                      color: AppColors.errorRed),
                ),
              ),
            )
          : _localPath == null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                          color: AppColors.brandPink),
                      const SizedBox(height: AppSpacing.md),
                      Text('Loading module...',
                          style: AppTextStyles.body.copyWith(
                              color: AppColors.textDark)),
                    ],
                  ),
                )
              : PDFView(
                  filePath: _localPath!,
                  enableSwipe: true,
                  swipeHorizontal: false,
                  autoSpacing: true,
                  pageFling: true,
                ),
    );
  }
}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wash_ed_app/controllers/api_controller.dart';
import 'package:wash_ed_app/data/database_helper.dart';
import 'package:wash_ed_app/models/module_model.dart';
import 'package:url_launcher/url_launcher.dart';

// ── Colours & constants ───────────────────────────────────────────────────────

const Color kPink = Color(0xFFE91E8C);
const Color kYellow = Color(0xFFFFCC00);
const Color kNavyText = Color(0xFF1A237E);
const Color kCardBg = Color(0xFFFFFFFF);

const LinearGradient kMascotBgGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFE8D5F0), Color(0xFFFFE4D6)],
);

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

  List<LearningModule> _modules = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
    _loadModules();
  }

  Future<void> _loadModules() async {
    final profile = await _db.getUserProfile();
    final role = profile?.role ?? 'student';
    final modules = await _api.getModulesByRole(role);
    if (mounted) {
      setState(() {
        _modules = modules;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(gradient: kMascotBgGradient),
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
                            child:
                                CircularProgressIndicator(color: kPink))
                        : _ModuleListView(modules: _modules),
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
  final List<LearningModule> modules;
  const _ModuleListView({required this.modules});

  @override
  Widget build(BuildContext context) {
    if (modules.isEmpty) {
      return const Center(
        child: Text('No modules found.',
            style: TextStyle(color: kNavyText, fontSize: 16)),
      );
    }
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _MascotHeader()),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _ModuleCard(module: modules[i], moduleNumber: i + 1),
              ),
              childCount: modules.length,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Module card ───────────────────────────────────────────────────────────────

class _ModuleCard extends StatelessWidget {
  final LearningModule module;
  final int moduleNumber;

  const _ModuleCard({required this.module, required this.moduleNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kYellow, width: 2),
        boxShadow: [
          BoxShadow(
            color: kYellow.withValues(alpha: 1),
            blurRadius: 6,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Module $moduleNumber',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: kPink,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            module.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: kNavyText,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            module.description,
            style: TextStyle(
              fontSize: 13,
              color: kNavyText.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PdfViewerPage(
                    module: module,
                    moduleNumber: moduleNumber,
                  ),
                ),
              ),
              icon: const Icon(Icons.menu_book_rounded, size: 18),
              label: const Text('Open Module'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Resources tab placeholder ─────────────────────────────────────────────────

class _ResourcesTab extends StatelessWidget {
  const _ResourcesTab();

  static const List<Map<String, String>> _resources = [
    {
      'title': 'WASH-Ed',
      'description': 'Explore our Learning Portal for videos and resources on clean water, handwashing, and staying healthy at school.',
      'url': 'https://www.wash-ed.org',
    },
    {
      'title': 'Resource 2',
      'description': 'Placeholder description for resource 2.',
      'url': 'https://www.example.com',
    },
    {
      'title': 'Resource 3',
      'description': 'Placeholder description for resource 3.',
      'url': 'https://www.example.com',
    },
    {
      'title': 'Resource 4',
      'description': 'Placeholder description for resource 4.',
      'url': 'https://www.example.com',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _MascotHeader()),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
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
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kYellow, width: 2),
        boxShadow: [
          BoxShadow(
            color: kYellow.withValues(alpha: 1),
            blurRadius: 6,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resource $resourceNumber',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: kPink,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: kNavyText,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: kNavyText.withValues(alpha: 0.7),
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
                backgroundColor: kPink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Open Resource'),
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
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: isActive ? kPink : const Color(0xFFE0E0E0),
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 40,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: isActive
                  ? BoxDecoration(
                      color: kPink,
                      borderRadius: BorderRadius.circular(20),
                    )
                  : null,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.white : kNavyText,
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
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF3B3DBF), // deep blue/purple
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Let's Learn",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Discover how to stay safe, dry, and prepared for floods with our fun lessons!',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
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
    _loadPdf();
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
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        backgroundColor: kPink,
        foregroundColor: Colors.white,
      ),
      body: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Could not load PDF:\n$_error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            )
          : _localPath == null
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: kPink),
                      SizedBox(height: 16),
                      Text('Loading module...', style: TextStyle(color: kNavyText)),
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

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wash_ed_app/controllers/api_controller.dart';
import 'package:wash_ed_app/models/module_model.dart';

// ─────────────────────────────────────────────
// Colours & constants
// ─────────────────────────────────────────────

const Color kPink = Color(0xFFE91E8C);
const Color kYellow = Color(0xFFFFCC00);
const Color kNavyText = Color(0xFF1A237E);
const Color kCardBg = Color(0xFFFFFFFF);

const LinearGradient kMascotBgGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFE8D5F0), Color(0xFFFFE4D6)],
);

// ─────────────────────────────────────────────
// LearnPage – top-level widget
// ─────────────────────────────────────────────

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final ApiController _controller = ApiController();
  List<LearningModule> _modules = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
    _loadModules();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadModules() async {
    setState(() => _loading = true);
    final modules = await _controller.getModules();
    setState(() {
      _modules = modules;
      _loading = false;
    });
  }

  Future<void> _openPdf(LearningModule module) async {
    late ByteData bytes;
    try {
      bytes = await rootBundle.load(module.assetPath);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'PDF not available yet. Add "${module.assetPath.split('/').last}" to assets/pdfs/.',
          ),
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    final tempDir = await getTemporaryDirectory();
    final fileName = module.assetPath.split('/').last;
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(bytes.buffer.asUint8List());

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfViewerScreen(module: module, filePath: file.path),
      ),
    );
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
              // ── Tab bar ──────────────────────────────
              _LearnTabBar(controller: _tabController),

              // ── Tab content ──────────────────────────
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _loading
                        ? const Center(child: CircularProgressIndicator())
                        : _ModuleListView(
                            modules: _modules,
                            onTap: _openPdf,
                          ),
                    const _ResourcesView(),
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

// ─────────────────────────────────────────────
// Custom tab bar
// ─────────────────────────────────────────────

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

// ─────────────────────────────────────────────
// Modules list view
// ─────────────────────────────────────────────

class _ModuleListView extends StatelessWidget {
  final List<LearningModule> modules;
  final void Function(LearningModule) onTap;

  const _ModuleListView({required this.modules, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (modules.isEmpty) {
      return const Center(child: Text('No modules found.'));
    }
    return CustomScrollView(
      slivers: [
        // ── Mascot header area ────────────────
        SliverToBoxAdapter(child: _MascotHeader()),

        // ── Module cards ─────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final module = modules[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _ItemCard(
                    title: module.title,
                    onTap: () => onTap(module),
                  ),
                );
              },
              childCount: modules.length,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Resources placeholder
// ─────────────────────────────────────────────

class _ResourcesView extends StatelessWidget {
  const _ResourcesView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Resources coming soon.',
        style: TextStyle(color: Colors.black45, fontSize: 14),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Mascot header widget
// ─────────────────────────────────────────────

class _MascotHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, bottom: 20),
      child: Center(
        child: Image.asset(
          'assets/kiko/WashEd_kiko_sprite_thumbs-up.png',
          height: 300,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Individual item card
// ─────────────────────────────────────────────

class _ItemCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _ItemCard({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kYellow, width: 2),
          boxShadow: [
            BoxShadow(
              color: kYellow.withOpacity(1),
              blurRadius: 6,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kNavyText,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PDF Viewer Screen
// ─────────────────────────────────────────────

class PdfViewerScreen extends StatefulWidget {
  final LearningModule module;
  final String filePath;

  const PdfViewerScreen({
    super.key,
    required this.module,
    required this.filePath,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  int _currentPage = 0;
  int _totalPages = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.module.title, style: const TextStyle(fontSize: 14)),
        backgroundColor: kPink,
        foregroundColor: Colors.white,
        actions: [
          if (_totalPages > 0)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  '${_currentPage + 1} / $_totalPages',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: PDFView(
        filePath: widget.filePath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        onRender: (pages) => setState(() => _totalPages = pages ?? 0),
        onPageChanged: (page, _) =>
            setState(() => _currentPage = page ?? 0),
        onError: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading PDF: $error')),
          );
        },
      ),
    );
  }
}

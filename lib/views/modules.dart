import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wash_ed_app/controllers/api_controller.dart';
import 'package:wash_ed_app/models/module_model.dart';
import 'package:wash_ed_app/widgets/modules_list.dart';

class ModulesPage extends StatefulWidget {
  const ModulesPage({super.key});

  @override
  State<ModulesPage> createState() => _ModulesPageState();
}

class _ModulesPageState extends State<ModulesPage> {
  final ApiController _controller = ApiController();
  List<LearningModule> _modules = [];
  bool _loading = true;
  int _tabIndex = 0; // 0 = Modules, 1 = Resources

  @override
  void initState() {
    super.initState();
    _loadModules();
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildTabToggle(),
            _buildKiko(),
            Expanded(
              child: _tabIndex == 0 ? _buildModules() : _buildResources(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            _tabButton('Modules', 0),
            _tabButton('Resources', 1),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String label, int index) {
    final selected = _tabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight:
                  selected ? FontWeight.bold : FontWeight.normal,
              color: selected ? Colors.black87 : Colors.black45,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKiko() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Image.asset(
        'assets/kiko/WashEd_kiko_sprite_cheer.png',
        height: 240,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildModules() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ModulesList(modules: _modules, onTap: _openPdf);
  }

  Widget _buildResources() {
    return const Center(
      child: Text(
        'Resources coming soon.',
        style: TextStyle(color: Colors.black45, fontSize: 14),
      ),
    );
  }
}

// ── PDF Viewer ────────────────────────────────────────────────────────────────

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
        title: Text(widget.module.title,
            style: const TextStyle(fontSize: 14)),
        backgroundColor: const Color(0xFF3D5AFE),
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

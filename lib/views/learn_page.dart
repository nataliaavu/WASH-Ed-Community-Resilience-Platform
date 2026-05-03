import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// Data models – swap these out for real data
// ─────────────────────────────────────────────

class ModuleItem {
  final String title;
  const ModuleItem(this.title);
}

class ResourceItem {
  final String title;
  const ResourceItem(this.title);
}

// ─────────────────────────────────────────────
// Sample data
// ─────────────────────────────────────────────

const List<ModuleItem> kModules = [
  ModuleItem('*Module Title 1*'),
  ModuleItem('*Module Title 2*'),
  ModuleItem('*Module Title 3*'),
  ModuleItem('*Module Title 4*'),
  ModuleItem('*Module Title 5*'),
  ModuleItem('*Module Title 6*'),
];

const List<ResourceItem> kResources = [
  ResourceItem('*Resource Title 1*'),
  ResourceItem('*Resource Title 2*'),
  ResourceItem('*Resource Title 3*'),
  ResourceItem('*Resource Title 4*'),
  ResourceItem('*Resource Title 5*'),
  ResourceItem('*Resource Title 6*'),
];

// ─────────────────────────────────────────────
// Colours & constants
// ─────────────────────────────────────────────

const Color kPink = Color(0xFFE91E8C);
const Color kYellow = Color(0xFFFFCC00);
const Color kNavyText = Color(0xFF1A237E);
const Color kCardBg = Color(0xFFFFFFFF);
const Color kPageBg = Color(0xFFFFF8F0); // warm cream

// Gradient that fades from lavender-pink → peach (matches the screenshots)
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
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
              // ── Tab bar ──────────────────────────────
              _LearnTabBar(controller: _tabController),

              // ── Tab content ──────────────────────────
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _ItemListView<ModuleItem>(
                      items: kModules,
                      itemTitle: (m) => m.title,
                      onTap: (m) {
                        // TODO: navigate to module detail
                      },
                    ),
                    _ItemListView<ResourceItem>(
                      items: kResources,
                      itemTitle: (r) => r.title,
                      onTap: (r) {
                        // TODO: navigate to resource detail
                      },
                    ),
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
          // Active tab: pink background + white text
          // Inactive tab: white/transparent background + dark text
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
// Generic list view used by both tabs
// ─────────────────────────────────────────────

class _ItemListView<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T) itemTitle;
  final void Function(T) onTap;

  const _ItemListView({
    required this.items,
    required this.itemTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ── Mascot header area ────────────────
        SliverToBoxAdapter(child: _MascotHeader()),

        // ── Item cards ───────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _ItemCard(
                    title: itemTitle(item),
                    onTap: () => onTap(item),
                  ),
                );
              },
              childCount: items.length,
            ),
          ),
        ),
      ],
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
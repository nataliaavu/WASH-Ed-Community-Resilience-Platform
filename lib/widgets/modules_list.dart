import 'package:flutter/material.dart';
import 'package:wash_ed_app/models/module_model.dart';

class ModulesList extends StatelessWidget {
  final List<LearningModule> modules;
  final void Function(LearningModule) onTap;

  const ModulesList({super.key, required this.modules, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (modules.isEmpty) {
      return const Center(child: Text('No modules found.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      itemCount: modules.length,
      itemBuilder: (_, i) => _ModuleCard(module: modules[i], onTap: onTap),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final LearningModule module;
  final void Function(LearningModule) onTap;

  const _ModuleCard({required this.module, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(module),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Center(
          child: Text(
            module.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
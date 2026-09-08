import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/content.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/shared.dart';
import 'contact_screen.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  int? _openIndex;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<FaqItem> get _filtered {
    if (_query.trim().isEmpty) return AppContent.faqItems;
    final q = _query.toLowerCase();
    return AppContent.faqItems.where((f) => f.question.toLowerCase().contains(q) || f.answer.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Questions fréquentes')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            "Les réponses aux questions qu'on nous pose le plus souvent. Pour tout le reste, notre équipe reste joignable directement.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchCtrl,
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              hintText: 'Rechercher une question…',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => setState(() {
                        _query = '';
                        _searchCtrl.clear();
                      }),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          if (results.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.search_off_rounded, size: 36, color: AppColors.inkSoft),
                    const SizedBox(height: 10),
                    Text('Aucune question ne correspond à « $_query »', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            )
          else
            ...List.generate(results.length, (i) {
              final item = results[i];
              final globalIndex = AppContent.faqItems.indexOf(item);
              final open = _openIndex == globalIndex;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isDark ? AppColors.lineDark : AppColors.line),
                ),
                child: Column(
                  children: [
                    Semantics(
                      button: true,
                      expanded: open,
                      label: item.question,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => setState(() => _openIndex = open ? null : globalIndex),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(item.question, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14.5)),
                              ),
                              AnimatedRotation(
                                turns: open ? 0.5 : 0,
                                duration: const Duration(milliseconds: 220),
                                child: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.brand2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 240),
                      curve: Curves.easeOutCubic,
                      child: open
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(item.answer, style: Theme.of(context).textTheme.bodyMedium),
                              ),
                            )
                          : const SizedBox(width: double.infinity),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: (i * 50).ms, duration: 240.ms);
            }),
          PrimaryCtaCard(
            title: "Une question qui n'est pas ici ?",
            subtitle: 'Écrivez-nous directement, nous répondons rapidement.',
            buttonLabel: 'Poser ma question',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ContactScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

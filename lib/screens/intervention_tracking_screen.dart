import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/shared.dart';

class InterventionTrackingScreen extends StatefulWidget {
  const InterventionTrackingScreen({super.key});

  @override
  State<InterventionTrackingScreen> createState() => _InterventionTrackingScreenState();
}

class _InterventionTrackingScreenState extends State<InterventionTrackingScreen> {
  final _referenceCtrl = TextEditingController();
  String? _reference;
  int? _statusIndex;

  static const _statuses = [
    ('Demande reçue', 'Votre demande a bien été enregistrée.', Icons.inbox_rounded),
    ('Diagnostic', 'Notre équipe analyse le problème et prépare la suite.', Icons.search_rounded),
    ('Intervention planifiée', 'Un créneau d’intervention est en préparation.', Icons.event_available_rounded),
    ('Intervention en cours', 'Le technicien intervient actuellement.', Icons.engineering_rounded),
    ('Terminée', 'L’intervention est terminée et le compte-rendu est disponible.', Icons.check_circle_rounded),
  ];

  @override
  void dispose() {
    _referenceCtrl.dispose();
    super.dispose();
  }

  void _track() {
    final value = _referenceCtrl.text.trim().toUpperCase();
    if (value.isEmpty) return;
    HapticFeedback.selectionClick();
    setState(() {
      _reference = value;
      // Les références de démonstration permettent de tester immédiatement
      // l'interface avant le branchement au futur espace client/backend.
      _statusIndex = switch (value) {
        'TT-2026-001' => 1,
        'TT-2026-002' => 3,
        'TT-2026-003' => 4,
        _ => null,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Suivi d’intervention')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        children: [
          const GlowChip(label: 'NOUVEAU · VERSION 1.0.2'),
          const SizedBox(height: 14),
          Text('Suivez l’avancement de votre intervention.', style: Theme.of(context).textTheme.headlineSmall)
              .animate()
              .fadeIn(duration: 300.ms),
          const SizedBox(height: 8),
          Text(
            'Saisissez la référence communiquée par TekaTech Congo pour retrouver les différentes étapes de votre prise en charge.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _referenceCtrl,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _track(),
            decoration: InputDecoration(
              labelText: 'Référence d’intervention',
              hintText: 'Ex. TT-2026-001',
              prefixIcon: const Icon(Icons.confirmation_number_outlined),
              suffixIcon: IconButton(onPressed: _track, icon: const Icon(Icons.arrow_forward_rounded)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Exemples de démonstration : TT-2026-001, TT-2026-002 ou TT-2026-003.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (_reference != null) ...[
            const SizedBox(height: 24),
            if (_statusIndex == null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded, color: AppColors.brand2),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Aucune intervention de démonstration ne correspond à $_reference. En production, cette référence sera recherchée dans l’espace client connecté.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppGradients.hero,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: AppColors.brand2.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 10))],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.track_changes_rounded, color: Colors.white, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Intervention suivie', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 3),
                          Text(_reference!, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text(_statuses[_statusIndex!].$1, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 280.ms).slideY(begin: 0.08, end: 0),
              const SizedBox(height: 22),
              Text('Avancement', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              ...List.generate(_statuses.length, (i) {
                final item = _statuses[i];
                final done = i <= _statusIndex!;
                final active = i == _statusIndex;
                return _TimelineStep(
                  icon: item.$3,
                  title: item.$1,
                  description: item.$2,
                  done: done,
                  active: active,
                  isLast: i == _statuses.length - 1,
                ).animate().fadeIn(delay: (i * 70).ms, duration: 260.ms).slideX(begin: 0.04, end: 0);
              }),
              const SizedBox(height: 12),
              Card(
                color: isDark ? AppColors.surfaceDark : AppColors.surface,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.support_agent_rounded, color: AppColors.brand2),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Besoin d’une précision sur votre intervention ? Contactez directement l’équipe TekaTech Congo.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool done;
  final bool active;
  final bool isLast;

  const _TimelineStep({
    required this.icon,
    required this.title,
    required this.description,
    required this.done,
    required this.active,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final color = done ? AppColors.brand2 : Theme.of(context).disabledColor;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 42,
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withOpacity(active ? 0.18 : 0.10),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withOpacity(active ? 0.65 : 0.30), width: active ? 2 : 1),
                ),
                child: Icon(done ? Icons.check_rounded : icon, size: 18, color: color),
              ),
              if (!isLast)
                Container(width: 2, height: 42, margin: const EdgeInsets.symmetric(vertical: 4), color: color.withOpacity(0.22)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
                    if (active) const GlowChip(label: 'EN COURS'),
                  ],
                ),
                const SizedBox(height: 4),
                Text(description, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

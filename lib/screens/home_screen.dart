import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/content.dart';
import '../theme/app_theme.dart';
import '../widgets/shared.dart';
import '../widgets/network_background.dart';
import '../widgets/page_transitions.dart';
import 'service_detail_screen.dart';
import 'contact_screen.dart';
import 'devis_wizard_screen.dart';

class HomeScreen extends StatelessWidget {
  final void Function(int tabIndex)? onNavigateTab;
  const HomeScreen({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Hero(onNavigateTab: onNavigateTab),
          _DevisBanner(),
          const SectionTitle(
            title: 'Quatre domaines, une seule équipe à contacter',
            subtitle: "Que le souci soit urgent ou que le projet dorme depuis des mois, c'est la même porte d'entrée.",
          ),
          _ServiceGrid(),
          const SectionTitle(title: 'Comment se passe une intervention'),
          _ProcessList(),
          const SectionTitle(title: 'Ce que ça change, concrètement'),
          _OutcomesList(),
          const SectionTitle(title: 'Pourquoi les entreprises congolaises nous appellent'),
          _ValuesGrid(),
          PrimaryCtaCard(
            title: 'Un problème maintenant, ou un projet à venir ?',
            subtitle:
                'Décrivez votre besoin : nous revenons vers vous avec un premier avis et, si nécessaire, un devis avant toute intervention facturée.',
            buttonLabel: 'Demander une intervention',
            onPressed: () => context.pushPage(const ContactScreen()),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final void Function(int tabIndex)? onNavigateTab;
  const _Hero({this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 74, 20, 30),
      decoration: const BoxDecoration(gradient: AppGradients.hero),
      child: Stack(
        children: [
          const Positioned.fill(child: NetworkBackground()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GlowChip(label: 'BRAZZAVILLE · RÉPUBLIQUE DU CONGO', color: Colors.white),
              const SizedBox(height: 16),
              Text(
                'Un problème technique ? On est déjà en route.',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, height: 1.15),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.12, end: 0, curve: Curves.easeOut),
              const SizedBox(height: 14),
              const Text(
                "TekaTech Congo intervient à Brazzaville pour les entreprises et organisations : réseau qui tombe, caméras hors service, poste bloqué, projet numérique à lancer. On diagnostique, on répare, on documente — et on reste dans les parages.",
                style: TextStyle(color: Colors.white70, height: 1.55, fontSize: 15),
              ).animate().fadeIn(delay: 120.ms, duration: 400.ms),
              const SizedBox(height: 22),
              GlassPanel(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PulseButton(
                      label: 'Demander une intervention',
                      icon: Icons.bolt_rounded,
                      background: Colors.white,
                      foreground: AppColors.brand,
                      onPressed: () => context.pushPage(const ContactScreen()),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () => onNavigateTab?.call(1),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white54)),
                      icon: const Icon(Icons.grid_view_rounded, size: 18),
                      label: const Text('Voir les services'),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 220.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),
            ],
          ),
        ],
      ),
    );
  }
}

class _DevisBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Semantics(
        button: true,
        label: 'Devis express — Estimation en moins de 2 minutes',
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => context.pushPage(const DevisWizardScreen()),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.accentCyan, AppColors.brand2]),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(13)),
                  child: const Icon(Icons.bolt_rounded, color: Colors.white),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Devis express', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15.5)),
                      SizedBox(height: 3),
                      Text('Une estimation en moins de 2 minutes', style: TextStyle(color: Colors.white70, fontSize: 12.5)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_rounded, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 80.ms, duration: 350.ms).slideY(begin: 0.15, end: 0, curve: Curves.easeOut);
  }
}

class _ServiceGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: AppContent.services.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.92,
        ),
        itemBuilder: (context, i) {
          final s = AppContent.services[i];
          return _HoverCard(
            onTap: () => context.pushPage(ServiceDetailScreen(service: s)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'service-icon-${s.id}',
                    child: Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.brand2.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(s.icon, color: AppColors.brand2, size: 22),
                    ),
                  ),
                  const Spacer(),
                  Text(s.title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text('En savoir plus', style: TextStyle(color: AppColors.brand2, fontSize: 12, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 3),
                      const Icon(Icons.arrow_forward_rounded, size: 13, color: AppColors.brand2),
                    ],
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: (i * 90).ms, duration: 320.ms).slideY(begin: 0.12, end: 0, curve: Curves.easeOut);
        },
      ),
    );
  }
}

/// Carte avec léger effet d'échelle au toucher (le "pressable card" des
/// apps modernes) — remplace le simple InkWell statique.
class _HoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _HoverCard({required this.child, required this.onTap});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  double _scale = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.96),
      onTapUp: (_) => setState(() => _scale = 1),
      onTapCancel: () => setState(() => _scale = 1),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: Card(child: widget.child),
      ),
    );
  }
}

class _ProcessList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(AppContent.processSteps.length, (i) {
          final step = AppContent.processSteps[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(gradient: AppGradients.hero, shape: BoxShape.circle),
                  child: Text(step.number, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(step.title, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(step.description, style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: (i * 100).ms, duration: 320.ms).slideX(begin: 0.08, end: 0, curve: Curves.easeOut);
        }),
      ),
    );
  }
}

class _OutcomesList extends StatelessWidget {
  static const outcomes = [
    ('Un bureau qui ne perd plus la connexion',
        'Câblage repris, bornes Wi-Fi bien placées, accès sécurisés : fini les coupures qui bloquent toute une équipe en pleine journée.',
        Icons.wifi_tethering_rounded),
    ('Des caméras qu\'on peut vraiment consulter',
        "Installation propre, enregistreur configuré, accès à distance testé — pas juste des caméras accrochées au mur.",
        Icons.videocam_rounded),
    ('Une équipe qui documente ce qu\'elle fait',
        'Chaque passage laisse une note claire : ce qui a été changé, pourquoi, et quoi surveiller ensuite.',
        Icons.fact_check_rounded),
    ('Des outils pensés pour l\'équipe qui les utilise',
        "Sites, outils internes, formation incluse : vos équipes gagnent en autonomie au lieu de dépendre d'un prestataire à chaque clic.",
        Icons.auto_awesome_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(outcomes.length, (i) {
          final o = outcomes[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.lineDark : AppColors.line),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(o.$3, color: AppColors.accentCyan, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(o.$1, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 6),
                      Text(o.$2, style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: (i * 90).ms, duration: 320.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOut);
        }),
      ),
    );
  }
}

class _ValuesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: AppContent.values.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.95,
        ),
        itemBuilder: (context, i) {
          final v = AppContent.values[i];
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isDark ? AppColors.lineDark : AppColors.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(v.icon, color: AppColors.accent, size: 24),
                const SizedBox(height: 10),
                Text(v.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14.5)),
                const SizedBox(height: 4),
                Expanded(child: Text(v.description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12.5))),
              ],
            ),
          ).animate().fadeIn(delay: (i * 70).ms, duration: 300.ms).scale(begin: const Offset(0.92, 0.92), curve: Curves.easeOut);
        },
      ),
    );
  }
}

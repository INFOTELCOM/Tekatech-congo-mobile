import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/content.dart';
import '../data/web3forms_service.dart';
import '../theme/app_theme.dart';
import '../widgets/page_transitions.dart';
import '../widgets/shared.dart';
import 'intervention_tracking_screen.dart';

class ClientSpaceScreen extends StatefulWidget {
  const ClientSpaceScreen({super.key});

  @override
  State<ClientSpaceScreen> createState() => _ClientSpaceScreenState();
}

class _ClientSpaceScreenState extends State<ClientSpaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _orgCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  bool _loading = false;
  String? _status;
  bool _isError = false;

  @override
  void dispose() {
    _orgCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _status = null;
    });
    final ok = await Web3FormsService.submit(
      subject: 'Inscription espace client — TekaTech Congo',
      fields: {
        'organisation': _orgCtrl.text.trim(),
        'contact_info': _contactCtrl.text.trim(),
      },
    );
    if (!mounted) return;
    setState(() {
      _loading = false;
      _isError = !ok;
      _status = ok
          ? "Merci, ${_orgCtrl.text.trim()} ! Nous vous préviendrons dès l'ouverture de l'espace client."
          : 'Connexion impossible. Réessayez, ou écrivez-nous directement.';
    });
    if (ok) {
      HapticFeedback.mediumImpact();
      _orgCtrl.clear();
      _contactCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      children: [
        const GlowChip(label: 'ESPACE CLIENT'),
        const SizedBox(height: 14),
        Text(
          'Suivez vos interventions en un seul endroit.',
          style: Theme.of(context).textTheme.headlineSmall,
        ).animate().fadeIn(duration: 300.ms),
        const SizedBox(height: 10),
        Text(
          'Retrouvez l’état de votre intervention et visualisez chaque étape, de la demande jusqu’à sa clôture.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppGradients.hero,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.brand2.withOpacity(0.25),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.track_changes_rounded, color: Colors.white, size: 26),
                  SizedBox(width: 10),
                  Text(
                    'Nouveau : suivi d’intervention',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Consultez l’avancement d’une intervention grâce à sa référence.',
                style: TextStyle(color: Colors.white70, height: 1.5),
              ),
              const SizedBox(height: 18),
              PulseButton(
                label: 'Suivre une intervention',
                icon: Icons.timeline_rounded,
                background: Colors.white,
                foreground: AppColors.brand,
                onPressed: () => context.pushPage(const InterventionTrackingScreen()),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 100.ms, duration: 320.ms).slideY(begin: 0.08, end: 0),
        const SizedBox(height: 26),
        Text('Les étapes du suivi', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        const _StatusPreview(
          icon: Icons.inbox_rounded,
          title: 'Demande reçue',
          subtitle: 'Votre demande est enregistrée.',
          done: true,
        ),
        const _StatusPreview(
          icon: Icons.search_rounded,
          title: 'Diagnostic',
          subtitle: 'Analyse du problème et préparation de la suite.',
          done: true,
        ),
        const _StatusPreview(
          icon: Icons.engineering_rounded,
          title: 'Intervention en cours',
          subtitle: 'Le technicien intervient sur votre demande.',
          done: false,
        ),
        const _StatusPreview(
          icon: Icons.check_circle_outline_rounded,
          title: 'Terminée',
          subtitle: 'Compte-rendu et clôture de l’intervention.',
          done: false,
        ),
        const SizedBox(height: 16),
        Text('Espace client complet', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        Text(
          'Le suivi par référence est la première brique. L’espace client évoluera ensuite avec l’historique, les devis, les factures et les contrats récurrents.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.bg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: isDark ? AppColors.lineDark : AppColors.line),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Être averti de l’ouverture', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(
                  "Laissez vos coordonnées et nous vous préviendrons lorsque l’espace client complet sera disponible.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _orgCtrl,
                  decoration: const InputDecoration(labelText: "Nom de l'organisation"),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _contactCtrl,
                  decoration: const InputDecoration(labelText: 'E-mail ou téléphone'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
                ),
                const SizedBox(height: 16),
                PulseButton(
                  label: 'Me prévenir',
                  icon: Icons.notifications_active_rounded,
                  loading: _loading,
                  onPressed: _submit,
                ),
                if (_status != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _status!,
                    style: TextStyle(color: _isError ? AppColors.danger : AppColors.success),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusPreview extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool done;

  const _StatusPreview({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    final color = done ? AppColors.brand2 : Theme.of(context).disabledColor;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.28)),
            ),
            child: Icon(done ? Icons.check_rounded : icon, color: color, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

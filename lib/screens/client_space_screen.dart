import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/content.dart';
import '../data/web3forms_service.dart';
import '../theme/app_theme.dart';
import '../widgets/shared.dart';

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
      fields: {'organisation': _orgCtrl.text.trim(), 'contact_info': _contactCtrl.text.trim()},
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
        Text('Suivez vos interventions en un seul endroit.', style: Theme.of(context).textTheme.headlineSmall)
            .animate()
            .fadeIn(duration: 300.ms),
        const SizedBox(height: 10),
        Text(
          "L'espace client TekaTech Congo est en préparation : historique des interventions, devis, factures et contrats récurrents, accessibles à tout moment. En attendant, notre équipe reste joignable directement par téléphone, WhatsApp ou e-mail.",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: AppGradients.hero,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: AppColors.brand2.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.lock_clock_rounded, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Bientôt disponible', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15.5)),
                ],
              ),
              const SizedBox(height: 18),
              _MockRow('Intervention en cours', 'Réseaux & Wi-Fi', 'Diagnostic envoyé'),
              const SizedBox(height: 14),
              _MockRow('Prochain rendez-vous', 'Vidéosurveillance', 'À planifier'),
            ],
          ),
        ).animate().fadeIn(delay: 100.ms, duration: 320.ms).slideY(begin: 0.08, end: 0),
        const SizedBox(height: 26),
        Text('Ce que l\'espace client permettra', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ...List.generate(
          AppContent.clientSpaceFeatures.length,
          (i) => CheckListTile(text: AppContent.clientSpaceFeatures[i])
              .animate()
              .fadeIn(delay: (i * 70).ms, duration: 260.ms),
        ),
        const SizedBox(height: 14),
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
                Text("Être averti à l'ouverture", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(
                  "Laissez votre e-mail : nous vous préviendrons dès que l'espace client sera disponible, sans engagement.",
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
                PulseButton(label: 'Me prévenir', icon: Icons.notifications_active_rounded, loading: _loading, onPressed: _submit),
                if (_status != null) ...[
                  const SizedBox(height: 10),
                  Text(_status!, style: TextStyle(color: _isError ? AppColors.danger : AppColors.success)),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MockRow extends StatelessWidget {
  final String label;
  final String title;
  final String status;
  const _MockRow(this.label, this.title, this.status);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11.5)),
              const SizedBox(height: 3),
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
            ],
          ),
        ),
        GlowChip(label: status, color: Colors.white),
      ],
    );
  }
}

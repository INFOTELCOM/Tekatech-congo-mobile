import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/content.dart';
import '../data/web3forms_service.dart';
import '../theme/app_theme.dart';
import '../widgets/shared.dart';

class ContactScreen extends StatefulWidget {
  final String? preselectedService;
  final String? prefillMessage;
  const ContactScreen({super.key, this.preselectedService, this.prefillMessage});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _orgCtrl = TextEditingController();
  final _nomCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  late final TextEditingController _messageCtrl;
  late String _service;
  bool _loading = false;
  String? _status;
  bool _isError = false;

  static const serviceOptions = [
    'Support IT',
    'Réseaux & Wi-Fi',
    'Vidéosurveillance',
    'Solutions digitales',
    'Je ne sais pas encore',
  ];

  @override
  void initState() {
    super.initState();
    _service = widget.preselectedService ?? serviceOptions.first;
    _messageCtrl = TextEditingController(text: widget.prefillMessage ?? '');
  }

  @override
  void dispose() {
    _orgCtrl.dispose();
    _nomCtrl.dispose();
    _contactCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      HapticFeedback.heavyImpact();
      return;
    }
    setState(() {
      _loading = true;
      _status = null;
    });
    final ok = await Web3FormsService.submit(
      subject: "Nouvelle demande depuis l'application TekaTech Congo",
      fields: {
        'organisation': _orgCtrl.text.trim(),
        'nom': _nomCtrl.text.trim(),
        'contact_info': _contactCtrl.text.trim(),
        'service': _service,
        'message': _messageCtrl.text.trim(),
      },
    );
    if (!mounted) return;
    setState(() {
      _loading = false;
      _isError = !ok;
      _status = ok
          ? 'Merci, ${_orgCtrl.text.trim()} ! Votre demande est envoyée, nous revenons vers vous rapidement.'
          : 'Connexion impossible. Réessayez, ou écrivez-nous directement par e-mail ou WhatsApp.';
    });
    if (ok) {
      HapticFeedback.mediumImpact();
      _orgCtrl.clear();
      _nomCtrl.clear();
      _contactCtrl.clear();
      _messageCtrl.clear();
    }
  }

  Future<void> _call(String number) => launchUrl(Uri.parse('tel:$number'));
  Future<void> _whatsapp() =>
      launchUrl(Uri.parse('https://wa.me/${AppContent.whatsapp}'), mode: LaunchMode.externalApplication);
  Future<void> _email() => launchUrl(Uri.parse('mailto:${AppContent.contactEmail}'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nous contacter')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Un problème maintenant, ou un projet à venir ?', style: Theme.of(context).textTheme.headlineSmall)
              .animate()
              .fadeIn(duration: 300.ms)
              .slideY(begin: 0.1, end: 0),
          const SizedBox(height: 8),
          Text(
            'Décrivez votre besoin : nous revenons vers vous avec un premier avis et, si nécessaire, un devis avant toute intervention facturée.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 22),
          _QuickActions(onCall1: () => _call(AppContent.phone1), onCall2: () => _call(AppContent.phone2), onWhatsapp: _whatsapp, onEmail: _email)
              .animate()
              .fadeIn(delay: 100.ms, duration: 300.ms),
          const SizedBox(height: 26),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _orgCtrl,
                  decoration: const InputDecoration(labelText: "Nom de l'organisation"),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nomCtrl,
                  decoration: const InputDecoration(labelText: 'Votre nom'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _contactCtrl,
                  decoration: const InputDecoration(labelText: 'Téléphone ou e-mail'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _service,
                  decoration: const InputDecoration(labelText: 'Service concerné'),
                  items: serviceOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) => setState(() => _service = v ?? _service),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _messageCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Décrivez le problème ou le projet'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
                ),
                const SizedBox(height: 20),
                PulseButton(
                  label: 'Envoyer la demande',
                  icon: Icons.send_rounded,
                  loading: _loading,
                  onPressed: _submit,
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: _status == null
                      ? const SizedBox(height: 0)
                      : Padding(
                          key: ValueKey(_status),
                          padding: const EdgeInsets.only(top: 12),
                          child: Semantics(
                            liveRegion: true,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(_isError ? Icons.error_outline_rounded : Icons.check_circle_rounded,
                                    color: _isError ? AppColors.danger : AppColors.success, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(_status!, style: TextStyle(color: _isError ? AppColors.danger : AppColors.success)),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text("Zone d'intervention : Brazzaville et environs",
                style: TextStyle(color: AppColors.inkSoft, fontSize: 12.5)),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final VoidCallback onCall1;
  final VoidCallback onCall2;
  final VoidCallback onWhatsapp;
  final VoidCallback onEmail;
  const _QuickActions({required this.onCall1, required this.onCall2, required this.onWhatsapp, required this.onEmail});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _ActionChip(icon: Icons.call_rounded, label: AppContent.phone1Display, onTap: onCall1),
        _ActionChip(icon: Icons.call_rounded, label: AppContent.phone2Display, onTap: onCall2),
        _ActionChip(icon: Icons.chat_bubble_rounded, label: 'WhatsApp', onTap: onWhatsapp, color: const Color(0xFF25D366)),
        _ActionChip(icon: Icons.email_rounded, label: 'E-mail', onTap: onEmail),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  const _ActionChip({required this.icon, required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.brand2;
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: c),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(color: c, fontWeight: FontWeight.w700, fontSize: 12.5)),
            ],
          ),
        ),
      ),
    );
  }
}

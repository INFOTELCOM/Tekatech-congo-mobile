import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/content.dart';
import '../main.dart';
import '../services/update_checker.dart';
import '../theme/app_theme.dart';
import 'about_screen.dart';
import 'faq_screen.dart';
import 'contact_screen.dart';
import 'devis_wizard_screen.dart';
import 'legal/mentions_legales_screen.dart';
import 'legal/confidentialite_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  static const String _websiteUrl = 'https://teka-tech-congo.netlify.app/';

  Future<void> _openWebsite() async {
    final uri = Uri.parse(_websiteUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _checkForUpdate(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final update = await UpdateChecker.checkForUpdate();

    if (!context.mounted) return;

    if (update == null) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('TekaTech Congo est à jour.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.system_update_rounded),
            SizedBox(width: 10),
            Expanded(child: Text('Nouvelle version disponible')),
          ],
        ),
        content: Text(
          '${update.message}\n\nVersion disponible : ${update.version}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Plus tard'),
          ),
          FilledButton.icon(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await UpdateChecker.openUpdate(update);
            },
            icon: const Icon(Icons.download_rounded),
            label: const Text('Mettre à jour'),
          ),
        ],
      ),
    );
  }

  Future<void> _showWhatsNew(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nouveautés 1.1.3'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Vérification des mises à jour plus fiable.'),
            SizedBox(height: 10),
            Text('• Bouton « Vérifier les mises à jour » dans l’espace Plus.'),
            SizedBox(height: 10),
            Text('• Affichage de la version installée et amélioration du diagnostic.'),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Compris'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      children: [
        Text('Plus', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        _ThemeToggle(),
        const SizedBox(height: 8),
        _AppVersionCard(
          onCheckUpdate: () => _checkForUpdate(context),
          onShowWhatsNew: () => _showWhatsNew(context),
        ),
        const SizedBox(height: 8),
        _MenuTile(
          icon: Icons.bolt_rounded,
          title: 'Devis express',
          subtitle: 'Une estimation en moins de 2 minutes',
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DevisWizardScreen())),
        ),
        _MenuTile(
          icon: Icons.info_outline_rounded,
          title: 'À propos',
          subtitle: "Le produit numérique d'INFOTELCOM",
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AboutScreen())),
        ),
        _MenuTile(
          icon: Icons.help_outline_rounded,
          title: 'Questions fréquentes',
          subtitle: 'FAQ',
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FaqScreen())),
        ),
        _MenuTile(
          icon: Icons.mail_outline_rounded,
          title: 'Nous contacter',
          subtitle: 'Demander une intervention ou un devis',
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ContactScreen())),
        ),
        _MenuTile(
          icon: Icons.language_rounded,
          title: 'Visiter le site TekaTech Congo',
          subtitle: 'Consulter le site officiel et les informations détaillées',
          onTap: () {
            HapticFeedback.selectionClick();
            _openWebsite();
          },
        ),
        const SizedBox(height: 24),
        Text('Coordonnées', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? AppColors.lineDark : AppColors.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ContactRow(icon: Icons.call_rounded, label: 'Téléphone (Congo)', value: AppContent.phone1Display,
                  onTap: () => launchUrl(Uri.parse('tel:${AppContent.phone1}'))),
              const Divider(height: 26),
              _ContactRow(icon: Icons.call_rounded, label: 'Téléphone (Congo)', value: AppContent.phone2Display,
                  onTap: () => launchUrl(Uri.parse('tel:${AppContent.phone2}'))),
              const Divider(height: 26),
              _ContactRow(icon: Icons.chat_bubble_rounded, label: 'WhatsApp', value: AppContent.whatsappDisplay,
                  onTap: () => launchUrl(Uri.parse('https://wa.me/${AppContent.whatsapp}'), mode: LaunchMode.externalApplication)),
              const Divider(height: 26),
              _ContactRow(icon: Icons.email_rounded, label: 'E-mail', value: AppContent.contactEmail,
                  onTap: () => launchUrl(Uri.parse('mailto:${AppContent.contactEmail}'))),
              const Divider(height: 26),
              _ContactRow(icon: Icons.language_rounded, label: 'Site web', value: 'teka-tech-congo.netlify.app',
                  onTap: _openWebsite),
              const Divider(height: 26),
              const _ContactRow(icon: Icons.location_on_rounded, label: "Zone d'intervention", value: 'Brazzaville et environs'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 4,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MentionsLegalesScreen())),
              child: const Text('Mentions légales', style: TextStyle(fontSize: 12.5)),
            ),
            const Text('·', style: TextStyle(color: AppColors.inkSoft)),
            TextButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ConfidentialiteScreen())),
              child: const Text('Confidentialité', style: TextStyle(fontSize: 12.5)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text('© 2026 INFOTELCOM — TekaTech Congo. Tous droits réservés.',
              style: TextStyle(color: AppColors.inkSoft, fontSize: 11.5)),
        ),
      ],
    );
  }
}

class _AppVersionCard extends StatelessWidget {
  final VoidCallback onCheckUpdate;
  final VoidCallback onShowWhatsNew;

  const _AppVersionCard({
    required this.onCheckUpdate,
    required this.onShowWhatsNew,
  });

  Future<PackageInfo> _loadPackageInfo() => PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: _loadPackageInfo(),
      builder: (context, snapshot) {
        final version = snapshot.data?.version ?? '1.1.3';

        return Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0x141E63FF),
                      child: Icon(Icons.verified_rounded, color: AppColors.brand2),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('TekaTech Congo', style: TextStyle(fontWeight: FontWeight.w800)),
                          Text('Version installée : $version', style: const TextStyle(color: AppColors.inkSoft)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.system_update_rounded, color: AppColors.brand2),
                  title: const Text('Vérifier les mises à jour'),
                  subtitle: const Text('Tester immédiatement le manifeste distant'),
                  onTap: onCheckUpdate,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.new_releases_outlined, color: AppColors.brand2),
                  title: const Text('Nouveautés 1.1.3'),
                  subtitle: const Text('Voir ce qui change dans cette version'),
                  onTap: onShowWhatsNew,
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 280.ms);
      },
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDark ? AppColors.lineDark : AppColors.line),
          ),
          child: Row(
            children: [
              Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: AppColors.brand2),
              const SizedBox(width: 12),
              Expanded(
                child: Text(isDark ? 'Mode sombre' : 'Mode clair', style: Theme.of(context).textTheme.titleMedium),
              ),
              Switch(
                value: isDark,
                onChanged: (_) {
                  HapticFeedback.selectionClick();
                  themeController.toggle();
                },
              ),
            ],
          ),
        );
      },
    ).animate().fadeIn(duration: 280.ms);
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _MenuTile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.brand2.withOpacity(0.12),
          child: Icon(icon, color: AppColors.brand2),
        ),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  const _ContactRow({required this.icon, required this.label, required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: '$label : $value',
      child: InkWell(
        onTap: onTap == null
            ? null
            : () {
                HapticFeedback.selectionClick();
                onTap!();
              },
        child: Row(
          children: [
            Icon(icon, color: AppColors.brand2, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: AppColors.inkSoft, fontSize: 11.5)),
                  const SizedBox(height: 2),
                  Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

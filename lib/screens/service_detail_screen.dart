import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/shared.dart';
import '../widgets/network_background.dart';
import 'contact_screen.dart';

class ServiceDetailScreen extends StatelessWidget {
  final ServiceItem service;
  const ServiceDetailScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 16, 20, 26),
            decoration: const BoxDecoration(gradient: AppGradients.hero),
            child: Stack(
              children: [
                const Positioned.fill(child: NetworkBackground(nodeCount: 22)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                          style: IconButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.15)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Hero(
                      tag: 'service-icon-${service.id}',
                      child: Container(
                        width: 56,
                        height: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(16)),
                        child: Icon(service.icon, color: Colors.white, size: 26),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(service.heroTitle,
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700, height: 1.25)),
                    const SizedBox(height: 10),
                    Text(service.heroSubtitle, style: const TextStyle(color: Colors.white70, height: 1.55)),
                    const SizedBox(height: 20),
                    PulseButton(
                      label: 'Demander un devis',
                      icon: Icons.request_quote_rounded,
                      background: Colors.white,
                      foreground: AppColors.brand,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ContactScreen(preselectedService: service.title)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SectionTitle(title: 'Ce qui est inclus'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: List.generate(
                service.included.length,
                (i) => CheckListTile(text: service.included[i])
                    .animate()
                    .fadeIn(delay: (i * 70).ms, duration: 260.ms)
                    .slideX(begin: 0.06, end: 0),
              ),
            ),
          ),
          const SectionTitle(title: 'Quand nous appeler'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: List.generate(service.whenToCall.length, (i) {
                final c = service.whenToCall[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.title, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 6),
                        Text(c.description, style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: (i * 90).ms, duration: 300.ms).slideY(begin: 0.08, end: 0);
              }),
            ),
          ),
          PrimaryCtaCard(
            title: 'Un besoin qui ressemble à ça ?',
            subtitle:
                'Décrivez votre situation, nous revenons vers vous avec un premier avis et un devis clair avant toute intervention facturée.',
            buttonLabel: 'Demander un devis',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ContactScreen(preselectedService: service.title)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

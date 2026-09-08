import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/content.dart';
import '../theme/app_theme.dart';
import '../widgets/shared.dart';
import '../widgets/network_background.dart';
import 'contact_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 16, 20, 30),
            decoration: const BoxDecoration(gradient: AppGradients.hero),
            child: Stack(
              children: [
                const Positioned.fill(child: NetworkBackground(nodeCount: 22)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                      style: IconButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.15)),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Le produit numérique d'INFOTELCOM, pensé pour le terrain congolais.",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppContent.aboutIntro, style: Theme.of(context).textTheme.bodyLarge)
                    .animate()
                    .fadeIn(duration: 300.ms),
                const SizedBox(height: 22),
                Text('Notre positionnement', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(AppContent.aboutPositioning, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 26),
                Text('Ce qui guide chaque intervention', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 14),
                ...List.generate(AppContent.values.length, (i) {
                  final v = AppContent.values[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: AppColors.brand2.withOpacity(0.12), borderRadius: BorderRadius.circular(11)),
                          child: Icon(v.icon, color: AppColors.brand2, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(v.title, style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 3),
                              Text(v.description, style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: (i * 80).ms, duration: 280.ms).slideX(begin: 0.06, end: 0);
                }),
                const SizedBox(height: 8),
                Text("D'INFOTELCOM à TekaTech Congo", style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(AppContent.aboutFromInfotelcom, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
          PrimaryCtaCard(
            title: "Envie d'en discuter ?",
            subtitle: 'Parlez-nous de votre organisation, on vous dira concrètement comment TekaTech Congo peut aider.',
            buttonLabel: 'Nous contacter',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ContactScreen()),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

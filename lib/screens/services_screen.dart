import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/content.dart';
import '../theme/app_theme.dart';
import '../widgets/page_transitions.dart';
import 'service_detail_screen.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      children: [
        Text('Nos services', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(
          "Quatre domaines, une seule équipe à contacter : support IT, réseaux & Wi-Fi, vidéosurveillance et solutions digitales.",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        ...List.generate(AppContent.services.length, (i) {
          final s = AppContent.services[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Material(
              color: isDark ? AppColors.surfaceDark : AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => context.pushPage(ServiceDetailScreen(service: s)),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? AppColors.lineDark : AppColors.line),
                  ),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'service-icon-${s.id}',
                        child: Container(
                          width: 48,
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.brand2.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Icon(s.icon, color: AppColors.brand2),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.title, style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 4),
                            Text(
                              s.heroSubtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12.5),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.inkSoft),
                    ],
                  ),
                ),
              ),
            ),
          ).animate().fadeIn(delay: (i * 90).ms, duration: 320.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOut);
        }),
      ],
    );
  }
}

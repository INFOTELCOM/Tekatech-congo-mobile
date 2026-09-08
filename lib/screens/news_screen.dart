import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/content.dart';
import '../theme/app_theme.dart';
import '../widgets/page_transitions.dart';
import 'article_screen.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      children: [
        Text("Ce qu'on observe sur le terrain", style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(
          'Des repères concrets sur le réseau, la vidéosurveillance et les outils numériques, tirés de nos interventions.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        ...List.generate(AppContent.articles.length, (i) {
          final a = AppContent.articles[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Material(
              color: isDark ? AppColors.surfaceDark : AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => context.pushPage(ArticleScreen(article: a)),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? AppColors.lineDark : AppColors.line),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a.date.toUpperCase(),
                          style: const TextStyle(color: AppColors.brand2, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                      const SizedBox(height: 8),
                      Text(a.title, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 6),
                      Text(a.excerpt, style: Theme.of(context).textTheme.bodyMedium, maxLines: 3, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text("Lire l'article", style: TextStyle(color: AppColors.brand2, fontWeight: FontWeight.w700, fontSize: 13)),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.brand2),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ).animate().fadeIn(delay: (i * 100).ms, duration: 320.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOut);
        }),
      ],
    );
  }
}

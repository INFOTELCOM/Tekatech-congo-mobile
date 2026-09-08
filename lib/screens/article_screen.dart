import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/shared.dart';
import 'contact_screen.dart';

class ArticleScreen extends StatelessWidget {
  final NewsArticle article;
  const ArticleScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actualités')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GlowChip(label: article.date.toUpperCase()),
          const SizedBox(height: 14),
          Text(article.title, style: Theme.of(context).textTheme.headlineSmall)
              .animate()
              .fadeIn(duration: 300.ms)
              .slideY(begin: 0.08, end: 0),
          const SizedBox(height: 20),
          ...List.generate(
            article.paragraphs.length,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(article.paragraphs[i], style: Theme.of(context).textTheme.bodyLarge)
                  .animate()
                  .fadeIn(delay: (i * 60).ms, duration: 280.ms),
            ),
          ),
          PrimaryCtaCard(
            title: 'Une situation qui vous parle ?',
            subtitle: 'Décrivez-nous votre cas, on vous dira concrètement par où commencer.',
            buttonLabel: 'Demander un devis',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ContactScreen()),
            ),
          ),
          Center(
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_rounded, size: 16),
              label: const Text('Retour aux actualités'),
            ),
          ),
        ],
      ),
    );
  }
}

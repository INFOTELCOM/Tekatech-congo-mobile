import 'package:flutter/material.dart';

class LegalSection {
  final String title;
  final String body;
  const LegalSection(this.title, this.body);
}

class MentionsLegalesScreen extends StatelessWidget {
  const MentionsLegalesScreen({super.key});

  static const sections = [
    LegalSection('Éditeur du site',
        "Le site TekaTech Congo est édité par INFOTELCOM, Brazzaville, République du Congo.\n\nContact : (+242) 06 849 87 92 · (+242) 06 866 08 21 · contact.infotelcom@gmail.com"),
    LegalSection('Directeur de la publication', 'À compléter avec le nom du responsable de la publication chez INFOTELCOM.'),
    LegalSection('Hébergement', "À compléter avec le nom, l'adresse et le contact de l'hébergeur une fois le site mis en ligne."),
    LegalSection('Propriété intellectuelle',
        "L'ensemble des contenus présents sur ce site (textes, logo, mise en page) est la propriété d'INFOTELCOM / TekaTech Congo, sauf mention contraire. Toute reproduction sans autorisation préalable est interdite."),
    LegalSection('Responsabilité',
        "Les informations diffusées sur ce site le sont à titre indicatif. INFOTELCOM s'efforce d'assurer l'exactitude des informations publiées mais ne peut garantir l'absence d'erreur ou d'omission."),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mentions légales')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Mentions légales', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          ...sections.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(s.body, style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

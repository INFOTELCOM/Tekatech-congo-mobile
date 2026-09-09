import 'package:flutter/material.dart';

class LegalSection {
  final String title;
  final String body;
  const LegalSection(this.title, this.body);
}

class MentionsLegalesScreen extends StatelessWidget {
  const MentionsLegalesScreen({super.key});

  static const sections = [
    LegalSection(
      'Éditeur du site',
      "Le site TekaTech Congo est édité par INFOTELCOM, entreprise spécialisée dans les solutions informatiques et la transformation numérique.\n\nAdresse : Brazzaville, République du Congo\nTéléphone : (+242) 06 849 87 92\nTéléphone : (+242) 06 866 08 21\nWhatsApp : +33 06 52 86 11 59\nE-mail : contact.infotelcom@gmail.com",
    ),
    LegalSection(
      'Directeur de la publication',
      'Mr Zenos Anonymous (Albert MAYELE)\nDirecteur de la publication de TekaTech Congo.',
    ),
    LegalSection(
      'Hébergement et administration technique',
      "Le site TekaTech Congo est hébergé, administré et maintenu techniquement par :\n\nMr Zenos Anonymous (Albert MAYELE)\nAdresse : Brazzaville, République du Congo\nTéléphone : (+242) 06 849 87 92\nE-mail : contact.infotelcom@gmail.com",
    ),
    LegalSection(
      'Propriété intellectuelle',
      "L'ensemble des contenus présents sur ce site, notamment les textes, logos, éléments graphiques, images, interfaces, logiciels et éléments de mise en page, est la propriété d'INFOTELCOM / TekaTech Congo, sauf mention contraire.\n\nToute reproduction, représentation, modification, distribution ou exploitation, totale ou partielle, des contenus du site sans autorisation préalable est interdite.",
    ),
    LegalSection(
      'Responsabilité',
      "Les informations diffusées sur le site TekaTech Congo sont fournies à titre indicatif.\n\nINFOTELCOM s'efforce d'assurer l'exactitude et la mise à jour des informations publiées sur le site, sans toutefois pouvoir garantir l'absence totale d'erreurs, d'omissions ou d'interruptions.\n\nL'utilisateur reste responsable de l'utilisation qu'il fait des informations et services proposés sur le site.",
    ),
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

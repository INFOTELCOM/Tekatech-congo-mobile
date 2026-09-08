import 'package:flutter/material.dart';
import 'mentions_legales_screen.dart';

class ConfidentialiteScreen extends StatelessWidget {
  const ConfidentialiteScreen({super.key});

  static const sections = [
    LegalSection('Quelles données sont collectées',
        "Lorsque vous utilisez un formulaire de cette application (demande d'intervention, devis express, inscription à l'espace client), nous collectons : le nom de votre organisation, votre nom, un moyen de vous contacter (e-mail ou téléphone), et le contenu de votre message."),
    LegalSection('Pourquoi ces données sont collectées',
        'Ces informations servent uniquement à répondre à votre demande : établir un diagnostic, vous recontacter et, si nécessaire, préparer un devis. Elles ne sont utilisées à aucune autre fin.'),
    LegalSection('Qui reçoit ces données',
        "Les messages envoyés via nos formulaires sont transmis par le service Web3Forms jusqu'à notre boîte e-mail contact.infotelcom@gmail.com. Vos données ne sont ni vendues, ni partagées avec des tiers à des fins commerciales."),
    LegalSection('Combien de temps sont-elles conservées',
        'Vos informations sont conservées le temps nécessaire au traitement de votre demande, puis archivées ou supprimées selon les besoins de suivi de la relation commerciale.'),
    LegalSection('Vos droits',
        "Vous pouvez à tout moment demander l'accès, la correction ou la suppression de vos données en nous écrivant à contact.infotelcom@gmail.com."),
    LegalSection('Cookies et suivi',
        "Cette application n'utilise actuellement pas d'outil de suivi ou d'analyse tiers. Cette politique sera mise à jour si un tel outil est ajouté."),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confidentialité')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Politique de confidentialité', style: Theme.of(context).textTheme.headlineSmall),
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

import 'package:flutter/material.dart';
import 'models.dart';

/// Tout le contenu texte est repris à l'identique du site web
/// (tekatech-site/*.html) pour garder une cohérence parfaite entre
/// le site, l'appli mobile et l'appli desktop.
class AppContent {
  AppContent._();

  static const contactEmail = 'contact.infotelcom@gmail.com';
  static const phone1 = '+242068498792';
  static const phone1Display = '(+242) 06 849 87 92';
  static const phone2 = '+242068660821';
  static const phone2Display = '(+242) 06 866 08 21';
  static const whatsapp = '33652861159';
  static const whatsappDisplay = '+33 6 52 86 11 59';
  static const web3formsAccessKey = '1574d137-6488-4e03-b780-bb582f50d283';

  static const services = <ServiceItem>[
    ServiceItem(
      id: 'support-it',
      title: 'Support IT',
      icon: Icons.computer_rounded,
      heroTitle: 'Un poste bloqué ou une équipe à équiper, on s\'en occupe.',
      heroSubtitle:
          "Postes, imprimantes, logiciels, sauvegardes : TekaTech Congo intervient sur place ou à distance, diagnostique la panne et documente ce qui a été fait pour que ça reste réparé.",
      included: [
        'Diagnostic et dépannage des postes de travail',
        'Configuration des nouveaux ordinateurs et imprimantes',
        'Sauvegardes régulières et protection antivirus',
        'Assistance à distance pour les pannes courantes',
        'Compte-rendu écrit après chaque intervention',
      ],
      whenToCall: [
        ServiceCase('Un poste qui rame ou plante',
            "Lenteurs, écrans bleus, logiciels qui ne répondent plus : on identifie la cause avant de proposer une solution."),
        ServiceCase('De nouveaux employés à équiper',
            'Postes, comptes et logiciels prêts à l\'emploi dès le premier jour.'),
        ServiceCase('Des données à protéger',
            'Mise en place de sauvegardes fiables, pour ne plus dépendre d\'un seul disque dur.'),
      ],
    ),
    ServiceItem(
      id: 'reseaux-wifi',
      title: 'Réseaux & Wi-Fi',
      icon: Icons.wifi_rounded,
      heroTitle: 'Un réseau qui tient la charge, pas juste au premier jour.',
      heroSubtitle:
          "Câblage structuré, bornes Wi-Fi bien placées, accès sécurisés : TekaTech Congo installe et remet en état les réseaux des entreprises congolaises, avec un suivi dans la durée.",
      included: [
        'Câblage structuré et mise aux normes',
        'Installation de bornes Wi-Fi professionnelles',
        'Sécurisation des accès et des mots de passe réseau',
        'Segmentation du réseau (bureaux, invités, caméras)',
        'Suivi de la qualité et de la couverture du signal',
      ],
      whenToCall: [
        ServiceCase('Le Wi-Fi ne couvre pas tout le bureau',
            'Reprise du plan de bornes pour une couverture homogène, sans zones mortes.'),
        ServiceCase('Déménagement ou extension de locaux',
            "Câblage et réseau pensés dès l'installation, pas ajoutés après coup."),
        ServiceCase('Un réseau invité à isoler',
            "Séparation claire entre réseau interne, invités et équipements de vidéosurveillance."),
      ],
    ),
    ServiceItem(
      id: 'videosurveillance',
      title: 'Vidéosurveillance',
      icon: Icons.videocam_rounded,
      heroTitle: 'Des caméras qu\'on peut vraiment consulter.',
      heroSubtitle:
          "Installation propre, enregistreur configuré, accès à distance testé : TekaTech Congo s'occupe de la vidéosurveillance de bout en bout, pas seulement de l'accroche au mur.",
      included: [
        'Étude d\'implantation des caméras selon les zones à couvrir',
        'Installation des caméras et de l\'enregistreur',
        'Configuration de l\'accès à distance aux images',
        'Maintenance et remplacement du matériel défectueux',
        'Stockage sécurisé des enregistrements',
      ],
      whenToCall: [
        ServiceCase('Un entrepôt ou une boutique à surveiller',
            'Positionnement des caméras pour couvrir les entrées et points sensibles.'),
        ServiceCase('Des caméras existantes hors service',
            'Diagnostic du système en place avant de décider quoi réparer ou remplacer.'),
        ServiceCase('Besoin de consulter les images à distance',
            'Accès mobile ou depuis un poste, configuré et testé avec vous.'),
      ],
    ),
    ServiceItem(
      id: 'solutions-digitales',
      title: 'Solutions digitales',
      icon: Icons.auto_awesome_rounded,
      heroTitle: 'Des outils numériques que votre équipe utilise vraiment.',
      heroSubtitle:
          "Sites web, outils internes, formation des équipes : TekaTech Congo construit avec vous les usages numériques dont votre organisation a besoin, et vous accompagne après la mise en ligne.",
      included: [
        'Sites web professionnels et vitrines en ligne',
        'Outils internes sur mesure (suivi, gestion, formulaires)',
        'Formation des équipes à l\'utilisation des outils',
        'Accompagnement au changement numérique',
        'Support après la mise en ligne',
      ],
      whenToCall: [
        ServiceCase('Aucune présence en ligne pour l\'entreprise',
            'Un site simple et professionnel pour être trouvé et contacté facilement.'),
        ServiceCase('Un suivi d\'activité encore sur papier',
            'Un outil interne adapté à vos processus, pas un logiciel importé tel quel.'),
        ServiceCase('Une équipe à former aux nouveaux outils',
            "Formation pratique incluse, pour gagner en autonomie."),
      ],
    ),
  ];

  static const processSteps = <ProcessStep>[
    ProcessStep('1', 'Vous décrivez le problème',
        "Par le formulaire, téléphone ou WhatsApp : le service concerné, l'urgence, et un moyen de vous joindre."),
    ProcessStep('2', 'On diagnostique',
        'À distance quand c\'est possible, sur place quand il le faut. Vous recevez un devis clair avant toute intervention facturée.'),
    ProcessStep('3', 'On intervient',
        'Réparation, installation ou configuration, réalisée par l\'équipe TekaTech Congo, avec un compte-rendu à la clé.'),
    ProcessStep('4', 'On reste disponible',
        'Contrat récurrent ou simple suivi ponctuel : vous savez qui rappeler la prochaine fois.'),
  ];

  static const values = <ValueItem>[
    ValueItem('Proximité', 'Une équipe basée à Brazzaville, qui connaît le terrain et les contraintes locales.',
        Icons.location_on_rounded),
    ValueItem('Réactivité', "Un problème signalé, une réponse rapide — pas un ticket qui attend.",
        Icons.bolt_rounded),
    ValueItem('Documentation', 'Chaque intervention laisse une trace claire : ce qui a été fait, et pourquoi.',
        Icons.fact_check_rounded),
    ValueItem('Sécurité',
        'Des accès, des réseaux et des caméras configurés pour durer, pas juste pour fonctionner aujourd\'hui.',
        Icons.shield_rounded),
    ValueItem('Innovation', 'On propose des solutions digitales adaptées, pas des outils importés tels quels.',
        Icons.lightbulb_rounded),
    ValueItem('Accompagnement', 'Formation des équipes incluse, pour gagner en autonomie au fil du temps.',
        Icons.groups_rounded),
  ];

  static const articles = <NewsArticle>[
    NewsArticle(
      id: 'wifi-entreprise',
      title: "5 signes qu'il est temps de revoir son réseau Wi-Fi professionnel",
      date: '20 août 2026',
      excerpt:
          "Un Wi-Fi qui coupe, des zones mortes dans les bureaux, une équipe qui perd du temps à se reconnecter : voici les signaux à ne pas ignorer.",
      paragraphs: [
        "Un réseau Wi-Fi professionnel vieillit mal quand l'entreprise grandit autour de lui. Une borne installée pour cinq personnes ne suffit plus quand l'équipe passe à vingt, et les coupures qui semblaient anecdotiques deviennent un vrai frein.",
        "Premier signe : des zones mortes récurrentes, toujours aux mêmes endroits du bureau. C'est souvent le signe d'un mauvais positionnement des bornes plutôt que d'un problème d'abonnement internet.",
        "Deuxième signe : des coupures qui reviennent à heures fixes, en général quand plusieurs personnes utilisent le réseau en même temps pour des visioconférences ou des transferts de fichiers lourds.",
        "Troisième signe : un réseau invité qui n'existe pas ou qui n'est pas isolé du réseau interne — un risque de sécurité que beaucoup d'entreprises découvrent trop tard.",
        "Quatrième signe : personne dans l'équipe ne sait qui contacter en cas de panne, ni quel matériel est réellement installé.",
        "Cinquième signe, le plus simple à repérer : plus personne ne se souvient de la dernière fois où le réseau a été vérifié plutôt que simplement redémarré.",
        "Dans la majorité des cas, un diagnostic sur place suffit à identifier ce qui doit être repris en priorité, avant de proposer un plan clair — câblage, bornes, sécurisation des accès — plutôt que de tout changer d'un coup.",
      ],
    ),
    NewsArticle(
      id: 'videosurveillance-erreurs',
      title: 'Vidéosurveillance : 4 erreurs courantes à éviter',
      date: '2 juillet 2026',
      excerpt:
          "Des caméras installées ne suffisent pas à elles seules : voici les erreurs qui rendent un système de vidéosurveillance inutile au moment où on en a besoin.",
      paragraphs: [
        "Installer des caméras est une chose ; avoir un système de vidéosurveillance réellement utile en est une autre. Beaucoup d'entreprises découvrent les failles de leur installation seulement après un incident.",
        "Première erreur : des caméras positionnées sans étude préalable des zones sensibles, qui laissent des angles morts précisément là où ils comptent le plus.",
        "Deuxième erreur : un enregistreur jamais vérifié, dont le disque dur est plein depuis des mois — plus aucune image n'est réellement conservée.",
        "Troisième erreur : un accès à distance jamais configuré ou jamais testé, découvert non fonctionnel au moment précis où il faudrait consulter les images depuis un téléphone.",
        "Quatrième erreur : aucune maintenance prévue, alors qu'une caméra encrassée ou mal réglée par la pluie ou la poussière perd rapidement en qualité d'image.",
        "Un système de vidéosurveillance qui fonctionne vraiment demande une installation pensée dès le départ, puis un suivi régulier — pas seulement un accrochage au mur suivi d'un oubli.",
      ],
    ),
    NewsArticle(
      id: 'formation-numerique',
      title: "Pourquoi former son équipe change tout (pas seulement acheter des outils)",
      date: '15 juin 2026',
      excerpt:
          "Un nouvel outil numérique bien choisi mais jamais expliqué finit souvent délaissé. La différence se joue dans l'accompagnement, pas seulement dans l'achat.",
      paragraphs: [
        "Beaucoup d'entreprises investissent dans un nouvel outil numérique — logiciel de gestion, site web, tableau de suivi — en pensant que l'essentiel est de bien le choisir. Dans la pratique, l'essentiel se joue souvent après l'achat.",
        "Un outil non expliqué est un outil sous-utilisé. Sans un minimum de formation, chacun continue à faire à sa manière, souvent en revenant aux anciennes habitudes — papier, mémoire, fichiers dispersés.",
        "La formation ne signifie pas un long séminaire théorique. Le plus efficace reste souvent une prise en main courte et concrète, sur les tâches réelles de chacun, au moment où l'outil est mis en place.",
        "C'est aussi une question d'autonomie : une équipe formée peut résoudre elle-même les petits blocages du quotidien, au lieu de dépendre systématiquement d'un prestataire pour la moindre question.",
        "À l'inverse, une équipe livrée à elle-même face à un nouvel outil finit par le juger « trop compliqué » — alors que le problème n'était pas l'outil, mais l'absence d'accompagnement au moment où elle en avait besoin.",
      ],
    ),
  ];

  static const faqItems = <FaqItem>[
    FaqItem('Comment se déroule une demande d\'intervention ?',
        "Vous nous décrivez le problème par le formulaire, téléphone ou WhatsApp. Nous posons un premier diagnostic, vous envoyons un devis clair, puis intervenons sur place ou à distance selon le cas. Chaque intervention se termine par un compte-rendu."),
    FaqItem('Intervenez-vous uniquement à Brazzaville ?',
        "Notre zone d'intervention principale est Brazzaville et ses environs. Pour une demande en dehors de cette zone, contactez-nous : nous vous dirons si c'est possible et dans quelles conditions."),
    FaqItem('Comment sont calculés vos devis ?',
        "Chaque devis dépend du diagnostic initial : matériel nécessaire, temps d'intervention, et niveau d'urgence. Vous recevez toujours un devis clair avant toute intervention facturée, sans surprise à la fin."),
    FaqItem('Proposez-vous des contrats récurrents ?',
        "Oui. Au-delà d'une intervention ponctuelle, nous proposons des contrats récurrents pour le suivi régulier de votre réseau, de vos caméras ou de votre parc informatique."),
    FaqItem('Formez-vous aussi les équipes ?',
        "Oui, l'accompagnement et la formation font partie de notre différenciation. Selon le service concerné, nous prenons le temps de transmettre les bons réflexes à vos équipes, pas seulement de réparer et repartir."),
    FaqItem('Comment vous contacter le plus rapidement ?',
        "Le plus rapide est WhatsApp ou l'un de nos numéros à Brazzaville, visibles en bas de chaque page. Vous pouvez aussi passer par le formulaire de contact, qui nous arrive directement par e-mail."),
  ];

  static const aboutIntro =
      "TekaTech Congo est né d'un constat simple : les entreprises de Brazzaville ont besoin d'un partenaire technologique de proximité, pas d'un prestataire lointain qu'on ne revoit qu'en cas de crise.";
  static const aboutPositioning =
      "TekaTech Congo est le produit numérique stratégique d'INFOTELCOM, construit progressivement et validé par un pilote avant tout changement d'échelle. Notre modèle combine prestations, équipements sur commande, contrats récurrents, formation et solutions digitales.";
  static const aboutFromInfotelcom =
      "INFOTELCOM forme depuis plusieurs années des professionnels aux métiers du numérique : réseau et administration système, cybersécurité, programmation, infographie, marketing digital, maintenance informatique. TekaTech Congo prolonge ce savoir-faire terrain vers un produit numérique accessible aux entreprises et organisations congolaises.";

  static const clientSpaceFeatures = [
    'Historique complet de vos interventions et comptes-rendus',
    'Devis et factures consultables à tout moment',
    'Suivi des contrats récurrents et de leur échéance',
    "Nouvelle demande d'intervention en quelques clics",
  ];
}

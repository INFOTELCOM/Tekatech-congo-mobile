# TekaTech Congo — Application mobile (Flutter) — Édition premium

Version mobile "vitrine" du site [tekatech-site], entièrement repensée pour
un rendu fluide, élégant et moderne : fond animé en réseau de nœuds (callback
du hero du site), verre dépoli, transitions douces, navigation flottante
animée, mode sombre, calculateur de devis express avec confettis, et une
passe accessibilité complète.

## Important — pourquoi ce n'est pas un .apk/.ipa

Cet environnement ne dispose pas du SDK Flutter/Android, donc impossible de
compiler ici. Ce dossier contient le **code source complet et prêt à
l'emploi** : à vous (ou à un développeur) de le compiler en quelques
commandes sur une machine avec Flutter installé.

## Option la plus simple : générer l'APK sans rien installer

Ce dossier contient déjà un workflow GitHub Actions
(`.github/workflows/build-apk.yml`) qui compile l'APK automatiquement,
gratuitement, sans toucher à Flutter :

1. Créez un dépôt GitHub (ou utilisez-en un existant) et envoyez-y ce dossier.
2. Ouvrez l'onglet **Actions** du dépôt : la compilation démarre
   automatiquement (ou lancez-la manuellement via "Run workflow").
3. Une fois terminé (quelques minutes), ouvrez le résultat du workflow et
   téléchargez l'artefact **tekatech-congo-app-release** : il contient
   `app-release.apk`, prêt à installer sur un téléphone Android.

Aucune installation locale n'est nécessaire pour cette méthode.

## Installation (en local, avec Flutter déjà installé)

```
flutter pub get
flutter run
```

## Compiler pour Android (.apk)

```
flutter build apk --release
```
Fichier généré : `build/app/outputs/flutter-apk/app-release.apk`

## Compiler pour iOS (.ipa)

Nécessite un Mac + Xcode :
```
flutter build ios --release
```

## Icône de l'application

Le logo est dans `assets/images/app_icon.png`. Pour en faire la vraie icône
de l'app :
```yaml
# pubspec.yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/app_icon.png"
```
```
flutter pub get
dart run flutter_launcher_icons
```

## Ce qui a été ajouté dans cette édition premium

**Visuel & mouvement**
- Fond animé "réseau de nœuds" (`NetworkBackground`), qui reproduit le hero
  canvas du site — présent au démarrage, sur l'accueil et sur les écrans
  À propos / détail de service.
- Écran de démarrage avec anneau de progression animé et messages qui
  défilent ("Connexion au réseau…", "Diagnostic des équipements…"...),
  fidèle au préchargeur du site. Bouton "Passer l'intro" toujours proposé.
- Panneaux "verre dépoli" (`GlassPanel`) sur les héros.
- Transitions de page en fondu + léger glissement (`FadeSlideRoute`),
  utilisées partout via `context.pushPage(...)`.
- Animations d'entrée en cascade sur toutes les listes et grilles
  (`flutter_animate`).
- Navigation flottante en pilule avec indicateur animé et retour haptique
  (`FloatingNavBar`), à la place de la barre de navigation standard.
- Boutons avec micro-interaction (échelle au toucher + halo + retour
  haptique) via `PulseButton`.
- Animation Hero entre la liste des services et le détail d'un service
  (l'icône du service "vole" d'un écran à l'autre).

**Nouveau : mode sombre**
- Bascule clair/sombre accessible dans l'onglet "Plus", persistée sur
  l'appareil (`ThemeController` + `shared_preferences`). Le thème sombre
  n'est pas un simple inversement de couleurs : bleu nuit profond, mêmes
  accents de marque.

**Nouveau : Devis express**
- Calculateur en 3 étapes (service → urgence → estimation), avec petite
  pluie de confettis à l'arrivée du résultat — reproduit fidèlement le
  `calculateur-devis.html` du site (mêmes textes, même logique de réponse
  selon l'urgence choisie). Accessible depuis l'accueil et le menu "Plus".

**Nouveau : pages légales**
- Mentions légales et Politique de confidentialité, contenu repris du site,
  accessibles depuis l'onglet "Plus".

**Accessibilité**
- Tous les boutons et zones tactiles ont un intitulé `Semantics` explicite
  (y compris les icônes seules comme le bouton WhatsApp).
- Les messages de statut des formulaires sont annoncés aux lecteurs d'écran
  (`liveRegion: true`).
- La taille de texte choisie dans les réglages du téléphone n'est jamais
  bridée par l'application.
- Le réglage système "réduire les animations" est respecté partout : le
  fond animé se fige, les confettis ne se déclenchent pas, les transitions
  de page deviennent instantanées, l'écran de démarrage saute directement
  à l'app.
- Contrastes vérifiés en thème clair et sombre, cibles tactiles ≥ 48dp.

## Formulaires

Toujours connectés au même service **Web3Forms** que le site (même clé
publique) : les demandes envoyées depuis l'application arrivent exactement
au même endroit : **contact.infotelcom@gmail.com**

## Structure du projet

```
lib/
  main.dart                       → point d'entrée, thème clair/sombre
  theme/
    app_theme.dart                → couleurs, dégradés, typographie
    theme_controller.dart         → bascule clair/sombre persistée
  data/
    models.dart                   → modèles (Service, Article, FAQ...)
    content.dart                  → contenu texte (repris du site)
    web3forms_service.dart        → envoi des formulaires
  widgets/
    shared.dart                   → GlassPanel, PulseButton, GlowChip...
    network_background.dart       → fond animé "réseau de nœuds"
    floating_nav_bar.dart         → navigation flottante animée
    page_transitions.dart         → transitions de page fluides
    whatsapp_fab.dart             → bouton WhatsApp avec halo pulsé
  screens/
    splash_screen.dart            → démarrage (anneau + messages)
    root_shell.dart               → coquille (nav + logo + FAB)
    home_screen.dart               → accueil
    services_screen.dart / service_detail_screen.dart
    news_screen.dart / article_screen.dart
    faq_screen.dart                → FAQ avec recherche en direct
    about_screen.dart
    client_space_screen.dart
    contact_screen.dart
    devis_wizard_screen.dart       → calculateur de devis express
    more_screen.dart               → menu + bascule thème + coordonnées
    legal/
      mentions_legales_screen.dart
      confidentialite_screen.dart
```

## Prochaines étapes possibles

- Version desktop (Windows/macOS/Linux) : ce code peut être recompilé pour
  desktop (`flutter config --enable-<platform>-desktop`), avec quelques
  ajustements de largeur pour les grands écrans.
- Espace client fonctionnel une fois qu'un backend (Firebase, Supabase...)
  aura été choisi pour stocker historique, devis et factures.

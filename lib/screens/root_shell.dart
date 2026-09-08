import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/floating_nav_bar.dart';
import '../widgets/whatsapp_fab.dart';
import '../widgets/page_transitions.dart';
import 'home_screen.dart';
import 'services_screen.dart';
import 'news_screen.dart';
import 'client_space_screen.dart';
import 'more_screen.dart';
import 'contact_screen.dart';

const _navItems = [
  NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Accueil'),
  NavItem(icon: Icons.build_outlined, activeIcon: Icons.build_rounded, label: 'Services'),
  NavItem(icon: Icons.article_outlined, activeIcon: Icons.article_rounded, label: 'Actus'),
  NavItem(icon: Icons.dashboard_customize_outlined, activeIcon: Icons.dashboard_customize_rounded, label: 'Espace'),
  NavItem(icon: Icons.more_horiz_rounded, activeIcon: Icons.more_horiz_rounded, label: 'Plus'),
];

/// Coquille principale de l'app : logo en en-tête, navigation flottante
/// animée en bas, bouton WhatsApp toujours accessible.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  void _goToTab(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeScreen(onNavigateTab: _goToTab),
      const ServicesScreen(),
      const NewsScreen(),
      const ClientSpaceScreen(),
      const MoreScreen(),
    ];

    final isHome = _index == 0;

    return Scaffold(
      extendBodyBehindAppBar: isHome,
      appBar: AppBar(
        backgroundColor: isHome ? Colors.transparent : null,
        foregroundColor: isHome ? Colors.white : null,
        titleSpacing: 16,
        title: Row(
          children: [
            Image.asset('assets/images/logo_mark.png', height: 28),
            const SizedBox(width: 10),
            Text(
              'TekaTech Congo',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: isHome ? Colors.white : Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Semantics(
              button: true,
              label: 'Signaler un problème — ouvrir le formulaire de contact',
              child: TextButton.icon(
                onPressed: () => context.pushPage(const ContactScreen()),
                icon: Icon(Icons.bolt_rounded, size: 18, color: isHome ? Colors.white : AppColors.brand2),
                label: Text('Signaler', style: TextStyle(color: isHome ? Colors.white : AppColors.brand2)),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(index: _index, children: pages),
      floatingActionButton: const WhatsappFab(),
      bottomNavigationBar: FloatingNavBar(currentIndex: _index, items: _navItems, onTap: _goToTab),
    );
  }
}

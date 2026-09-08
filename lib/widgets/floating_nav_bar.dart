import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const NavItem({required this.icon, required this.activeIcon, required this.label});
}

/// Barre de navigation flottante en "pilule", avec indicateur qui glisse
/// et icône active qui grossit légèrement — plus proche des standards
/// d'app 2026 que la BottomNavigationBar par défaut. Reste pleinement
/// accessible : chaque item est un vrai bouton sémantique, sélection
/// annoncée aux lecteurs d'écran.
class FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final List<NavItem> items;
  final ValueChanged<int> onTap;

  const FloatingNavBar({super.key, required this.currentIndex, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: isDark ? AppColors.lineDark : AppColors.line),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: List.generate(items.length, (i) {
              final selected = i == currentIndex;
              final item = items[i];
              return Expanded(
                child: Semantics(
                  button: true,
                  selected: selected,
                  label: item.label,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      if (!selected) HapticFeedback.selectionClick();
                      onTap(i);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutCubic,
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                      decoration: BoxDecoration(
                        color: selected ? scheme.primary.withOpacity(isDark ? 0.18 : 0.10) : Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedScale(
                            scale: selected ? 1.12 : 1.0,
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOutBack,
                            child: Icon(
                              selected ? item.activeIcon : item.icon,
                              color: selected ? scheme.primary : (isDark ? AppColors.inkSoftDark : AppColors.inkSoft),
                              size: 22,
                            ),
                          ),
                          const SizedBox(height: 3),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 220),
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                              color: selected ? scheme.primary : (isDark ? AppColors.inkSoftDark : AppColors.inkSoft),
                            ),
                            child: Text(item.label, maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

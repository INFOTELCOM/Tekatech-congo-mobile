import 'package:flutter/material.dart';

/// Transition "fondu + glissement" fluide, utilisée pour toutes les
/// navigations de l'app. Respecte automatiquement la préférence
/// "réduire les animations" du système (Flutter réduit alors la durée
/// des transitions de route par défaut ; ici on la coupe explicitement).
class FadeSlideRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  FadeSlideRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 380),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
            if (reduceMotion) return child;

            final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(curved),
                child: child,
              ),
            );
          },
        );
}

extension NavigatorPush on BuildContext {
  Future<T?> pushPage<T>(Widget page) {
    return Navigator.of(this).push<T>(FadeSlideRoute<T>(page: page));
  }
}

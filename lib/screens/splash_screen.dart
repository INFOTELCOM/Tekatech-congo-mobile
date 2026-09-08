import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/network_background.dart';
import '../widgets/page_transitions.dart';
import 'root_shell.dart';

const _messages = [
  (0, 'Connexion au réseau…'),
  (30, 'Diagnostic des équipements…'),
  (60, 'Vérification des caméras…'),
  (85, "Préparation de l'espace client…"),
];

/// Écran de démarrage — reproduit le préchargeur du site (anneau de
/// progression + messages qui défilent) pour une continuité de marque
/// parfaite entre le site et l'appli. Un bouton "Passer l'intro" est
/// toujours proposé, et l'animation est coupée si l'utilisateur préfère
/// des animations réduites.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _navigated = false;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _reduceMotion = WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.disableAnimations;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _reduceMotion ? 1 : 2200),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) _goNext();
      });
    _controller.forward();
  }

  void _goNext() {
    if (_navigated || !mounted) return;
    _navigated = true;
    Navigator.of(context).pushReplacement(FadeSlideRoute(page: const RootShell()));
  }

  String _messageFor(int pct) {
    var msg = _messages.first.$2;
    for (final m in _messages) {
      if (pct >= m.$1) msg = m.$2;
    }
    return msg;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.hero),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const Positioned.fill(child: NetworkBackground()),
            SafeArea(
              child: Column(
                children: [
                  const Spacer(),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      final pct = (_controller.value * 100).round();
                      return Semantics(
                        label: 'Chargement, $pct pour cent',
                        liveRegion: true,
                        child: SizedBox(
                          width: 148,
                          height: 148,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 148,
                                height: 148,
                                child: CircularProgressIndicator(
                                  value: _controller.value,
                                  strokeWidth: 4,
                                  backgroundColor: Colors.white.withOpacity(0.15),
                                  valueColor: const AlwaysStoppedAnimation(AppColors.accentCyan),
                                ),
                              ),
                              Image.asset('assets/images/logo_mark.png', height: 76,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.hub_rounded, color: Colors.white, size: 64)),
                            ],
                          ),
                        ),
                      );
                    },
                  ).animate().fadeIn(duration: 450.ms).scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack, duration: 550.ms),
                  const SizedBox(height: 26),
                  const Text(
                    'TekaTech Congo',
                    style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700, letterSpacing: 0.2),
                  ).animate().fadeIn(delay: 250.ms, duration: 450.ms).slideY(begin: 0.3, end: 0, curve: Curves.easeOut),
                  const SizedBox(height: 6),
                  const Text(
                    "Produit numérique d'INFOTELCOM",
                    style: TextStyle(color: Colors.white60, fontSize: 12.5),
                  ).animate().fadeIn(delay: 400.ms, duration: 450.ms),
                  const SizedBox(height: 28),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      final pct = (_controller.value * 100).round();
                      return Column(
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            child: Text(
                              _messageFor(pct),
                              key: ValueKey(_messageFor(pct)),
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text('$pct%', style: const TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 1)),
                        ],
                      );
                    },
                  ),
                  const Spacer(),
                  if (!_reduceMotion)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 28),
                      child: TextButton(
                        onPressed: _goNext,
                        style: TextButton.styleFrom(foregroundColor: Colors.white70),
                        child: const Text("Passer l'intro"),
                      ),
                    ).animate().fadeIn(delay: 700.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

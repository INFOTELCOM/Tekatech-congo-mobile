import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/content.dart';

/// Bouton flottant WhatsApp avec halo qui pulse doucement — présent sur
/// tout le site, reproduit ici. Le halo se coupe automatiquement si
/// l'utilisateur a activé "réduire les animations".
class WhatsappFab extends StatefulWidget {
  const WhatsappFab({super.key});

  @override
  State<WhatsappFab> createState() => _WhatsappFabState();
}

class _WhatsappFabState extends State<WhatsappFab> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _open() async {
    HapticFeedback.lightImpact();
    final uri = Uri.parse('https://wa.me/${AppContent.whatsapp}');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    const color = Color(0xFF25D366);

    return Semantics(
      button: true,
      label: 'Nous écrire sur WhatsApp',
      child: SizedBox(
        width: 64,
        height: 64,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (!reduceMotion)
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final t = _controller.value;
                  return Container(
                    width: 56 + (t * 22),
                    height: 56 + (t * 22),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withOpacity((1 - t) * 0.35),
                    ),
                  );
                },
              ),
            FloatingActionButton(
              onPressed: _open,
              backgroundColor: color,
              elevation: 4,
              tooltip: 'Nous écrire sur WhatsApp',
              child: const Icon(Icons.chat, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

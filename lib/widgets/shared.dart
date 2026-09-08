import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

/// Panneau "verre dépoli" : flou + légère transparence + liseré lumineux.
/// Utilisé sur les héros et les panneaux mis en avant pour un rendu premium.
class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? tint;
  final Border? border;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = 20,
    this.tint,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: (tint ?? Colors.white).withOpacity(0.10),
            borderRadius: BorderRadius.circular(radius),
            border: border ?? Border.all(color: Colors.white.withOpacity(0.18)),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Bouton principal avec micro-interaction (échelle au toucher + retour
/// haptique) et halo lumineux — le geste tactile "premium" attendu d'une
/// app soignée.
class PulseButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color? background;
  final Color? foreground;
  final bool loading;
  final String? semanticsLabel;

  const PulseButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.background,
    this.foreground,
    this.loading = false,
    this.semanticsLabel,
  });

  @override
  State<PulseButton> createState() => _PulseButtonState();
}

class _PulseButtonState extends State<PulseButton> {
  double _scale = 1;

  void _down(_) => setState(() => _scale = 0.96);
  void _up(_) => setState(() => _scale = 1);

  @override
  Widget build(BuildContext context) {
    final bg = widget.background ?? AppColors.brand2;
    final fg = widget.foreground ?? Colors.white;

    return Semantics(
      button: true,
      enabled: !widget.loading,
      label: widget.semanticsLabel ?? widget.label,
      child: GestureDetector(
        onTapDown: widget.loading ? null : _down,
        onTapUp: widget.loading ? null : _up,
        onTapCancel: widget.loading ? null : () => setState(() => _scale = 1),
        onTap: widget.loading
            ? null
            : () {
                HapticFeedback.lightImpact();
                widget.onPressed();
              },
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 17),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(color: bg.withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            child: widget.loading
                ? Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.4, color: fg),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: fg, size: 19),
                        const SizedBox(width: 9),
                      ],
                      Text(widget.label, style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 15.5)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Petit badge arrondi (statuts, tags).
class GlowChip extends StatelessWidget {
  final String label;
  final Color color;
  const GlowChip({super.key, required this.label, this.color = AppColors.brand2});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }
}

/// Titre de section cohérent, avec support Semantics pour les lecteurs
/// d'écran (regroupe titre + sous-titre en un seul énoncé).
class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  const SectionTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      label: subtitle != null ? '$title. $subtitle' : title,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}

class CheckListTile extends StatelessWidget {
  final String text;
  const CheckListTile({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: 18,
            height: 18,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(Icons.check_rounded, size: 12, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

/// Panneau d'appel à l'action, en dégradé de marque.
class PrimaryCtaCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onPressed;

  const PrimaryCtaCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppGradients.hero,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppColors.brand2.withOpacity(0.30), blurRadius: 26, offset: const Offset(0, 12)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: Colors.white70, height: 1.5)),
          const SizedBox(height: 18),
          PulseButton(label: buttonLabel, onPressed: onPressed, background: Colors.white, foreground: AppColors.brand),
        ],
      ),
    );
  }
}

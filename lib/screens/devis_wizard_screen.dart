import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/shared.dart';
import 'contact_screen.dart';

const _serviceOptions = ['Support IT', 'Réseaux & Wi-Fi', 'Vidéosurveillance', 'Solutions digitales'];
const _urgencyOptions = ['Urgent — sous 24h', 'Cette semaine', 'Pas pressé, à planifier'];

const _responseCopy = {
  'Urgent — sous 24h':
      "Réponse prioritaire visée sous 24h : contactez-nous aussi par téléphone ou WhatsApp pour accélérer.",
  'Cette semaine': 'Réponse et premier diagnostic sous 2 à 3 jours ouvrés.',
  'Pas pressé, à planifier': 'On regarde ensemble le meilleur créneau, sans pression de délai.',
};

class DevisWizardScreen extends StatefulWidget {
  const DevisWizardScreen({super.key});

  @override
  State<DevisWizardScreen> createState() => _DevisWizardScreenState();
}

class _DevisWizardScreenState extends State<DevisWizardScreen> {
  int _step = 1;
  String? _service;
  String? _urgency;
  bool _burst = false;

  void _pickService(String v) {
    HapticFeedback.selectionClick();
    setState(() {
      _service = v;
      _step = 2;
    });
  }

  void _pickUrgency(String v) {
    HapticFeedback.mediumImpact();
    setState(() {
      _urgency = v;
      _step = 3;
      _burst = true;
    });
  }

  void _reset() {
    setState(() {
      _step = 1;
      _service = null;
      _urgency = null;
      _burst = false;
    });
  }

  void _back() {
    setState(() {
      if (_step == 3) {
        _step = 1;
        _service = null;
        _urgency = null;
      } else {
        _step = (_step - 1).clamp(1, 3);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Devis express')),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text('Une estimation en moins de 2 minutes', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'Répondez à 2 questions rapides : on vous dit tout de suite à quoi vous attendre, puis on vous envoie un devis chiffré, gratuit et sans engagement.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 26),
              _ProgressDots(step: _step),
              const SizedBox(height: 26),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween<Offset>(begin: const Offset(0.06, 0), end: Offset.zero).animate(anim),
                    child: child,
                  ),
                ),
                child: _buildStep(context),
              ),
            ],
          ),
          if (_burst) Positioned.fill(child: IgnorePointer(child: _ConfettiBurst(onDone: () => setState(() => _burst = false)))),
        ],
      ),
    );
  }

  Widget _buildStep(BuildContext context) {
    switch (_step) {
      case 1:
        return _OptionStep(
          key: const ValueKey('s1'),
          question: '1. Quel service vous concerne ?',
          options: _serviceOptions,
          selected: _service,
          onSelect: _pickService,
        );
      case 2:
        return _OptionStep(
          key: const ValueKey('s2'),
          question: "2. C'est urgent ?",
          options: _urgencyOptions,
          selected: _urgency,
          onSelect: _pickUrgency,
          onBack: _back,
        );
      default:
        return _ResultStep(key: const ValueKey('s3'), service: _service!, urgency: _urgency!, onReset: _reset);
    }
  }
}

class _ProgressDots extends StatelessWidget {
  final int step;
  const _ProgressDots({required this.step});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Row(
      children: List.generate(3, (i) {
        final n = i + 1;
        final active = n == step;
        final done = n < step;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
            height: 5,
            decoration: BoxDecoration(
              color: active || done ? color : color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}

class _OptionStep extends StatelessWidget {
  final String question;
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelect;
  final VoidCallback? onBack;

  const _OptionStep({
    super.key,
    required this.question,
    required this.options,
    required this.selected,
    required this.onSelect,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        ...List.generate(options.length, (i) {
          final opt = options[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _WizardOptionButton(label: opt, onTap: () => onSelect(opt))
                .animate()
                .fadeIn(delay: (i * 70).ms, duration: 300.ms)
                .slideX(begin: 0.08, end: 0, curve: Curves.easeOut),
          );
        }),
        if (onBack != null) ...[
          const SizedBox(height: 6),
          TextButton.icon(onPressed: onBack, icon: const Icon(Icons.arrow_back_rounded, size: 18), label: const Text('Précédent')),
        ],
      ],
    );
  }
}

class _WizardOptionButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _WizardOptionButton({required this.label, required this.onTap});

  @override
  State<_WizardOptionButton> createState() => _WizardOptionButtonState();
}

class _WizardOptionButtonState extends State<_WizardOptionButton> {
  double _scale = 1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      button: true,
      label: widget.label,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _scale = 0.97),
        onTapUp: (_) => setState(() => _scale = 1),
        onTapCancel: () => setState(() => _scale = 1),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 110),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isDark ? AppColors.lineDark : AppColors.line),
            ),
            child: Row(
              children: [
                Expanded(child: Text(widget.label, style: Theme.of(context).textTheme.titleMedium)),
                Icon(Icons.chevron_right_rounded, color: AppColors.brand2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultStep extends StatelessWidget {
  final String service;
  final String urgency;
  final VoidCallback onReset;
  const _ResultStep({super.key, required this.service, required this.urgency, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GlowChip(label: 'ESTIMATION', color: AppColors.success),
        const SizedBox(height: 14),
        Text('$service — $urgency', style: Theme.of(context).textTheme.headlineSmall)
            .animate()
            .fadeIn(duration: 300.ms)
            .slideY(begin: 0.15, end: 0),
        const SizedBox(height: 10),
        Text(_responseCopy[urgency] ?? '', style: Theme.of(context).textTheme.bodyLarge)
            .animate()
            .fadeIn(delay: 120.ms, duration: 300.ms),
        const SizedBox(height: 14),
        Text(
          "Estimation indicative, à confirmer par un devis gratuit et sans engagement — pas de montant fixé à l'avance.",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic, fontSize: 12.5),
        ),
        const SizedBox(height: 22),
        PulseButton(
          label: 'Recevoir mon devis gratuit',
          icon: Icons.send_rounded,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ContactScreen(preselectedService: service, prefillMessage: 'Urgence : $urgency'),
            ),
          ),
        ).animate().fadeIn(delay: 240.ms, duration: 320.ms),
        const SizedBox(height: 12),
        Center(child: TextButton(onPressed: onReset, child: const Text('Recommencer'))),
      ],
    );
  }
}

/// Petite pluie de confettis déclenchée à l'obtention du résultat —
/// reproduit fireConfetti() du site, sans dépendance externe.
class _ConfettiBurst extends StatefulWidget {
  final VoidCallback onDone;
  const _ConfettiBurst({required this.onDone});

  @override
  State<_ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<_ConfettiBurst> {
  final _rand = Random();
  late final List<_ConfettiPiece> _pieces;

  static const _colors = [AppColors.brand2, AppColors.accentCyan, AppColors.flagYellow, AppColors.flagGreen, AppColors.flagRed];

  @override
  void initState() {
    super.initState();
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    _pieces = reduceMotion
        ? []
        : List.generate(22, (i) {
            return _ConfettiPiece(
              dx: (_rand.nextDouble() - 0.5) * 260,
              dy: -(120 + _rand.nextDouble() * 160),
              color: _colors[i % _colors.length],
              delayMs: _rand.nextInt(120),
            );
          });
    if (_pieces.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => widget.onDone());
    } else {
      Future.delayed(const Duration(milliseconds: 1000), widget.onDone);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _pieces.map((p) {
        return Align(
          alignment: const Alignment(0, -0.3),
          child: Container(width: 8, height: 8, color: p.color)
              .animate(delay: p.delayMs.ms)
              .moveX(begin: 0, end: p.dx, duration: 700.ms, curve: Curves.easeOut)
              .moveY(begin: 0, end: p.dy, duration: 700.ms, curve: Curves.easeOut)
              .fadeOut(delay: 300.ms, duration: 400.ms)
              .rotate(begin: 0, end: 2),
        );
      }).toList(),
    );
  }
}

class _ConfettiPiece {
  final double dx, dy;
  final Color color;
  final int delayMs;
  _ConfettiPiece({required this.dx, required this.dy, required this.color, required this.delayMs});
}

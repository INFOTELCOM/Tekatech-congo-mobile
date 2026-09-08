import 'dart:math';
import 'package:flutter/material.dart';

/// Reproduction du fond animé du hero web (script.js → initNetworkCanvas) :
/// des nœuds qui dérivent doucement et se relient par des lignes quand ils
/// sont proches. Respecte les préférences d'accessibilité : si l'utilisateur
/// a activé "réduire les animations", les nœuds restent figés (un seul
/// rendu statique, comme sur le site).
class NetworkBackground extends StatefulWidget {
  final Color nodeColor;
  final Color lineColor;
  final int nodeCount;
  const NetworkBackground({
    super.key,
    this.nodeColor = Colors.white,
    this.lineColor = Colors.white,
    this.nodeCount = 34,
  });

  @override
  State<NetworkBackground> createState() => _NetworkBackgroundState();
}

class _Node {
  double x, y, vx, vy;
  _Node(this.x, this.y, this.vx, this.vy);
}

class _NetworkBackgroundState extends State<NetworkBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final _rand = Random(7);
  List<_Node> _nodes = [];
  Size _lastSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(days: 1))..repeat();
  }

  void _ensureNodes(Size size) {
    if (_nodes.isNotEmpty && _lastSize == size) return;
    _lastSize = size;
    _nodes = List.generate(widget.nodeCount, (_) {
      return _Node(
        _rand.nextDouble() * size.width,
        _rand.nextDouble() * size.height,
        (_rand.nextDouble() - 0.5) * 0.4,
        (_rand.nextDouble() - 0.5) * 0.4,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _ensureNodes(size);

        if (reduceMotion) {
          // Rendu statique unique — pas d'animation continue.
          return CustomPaint(
            size: size,
            painter: _NetworkPainter(
              nodes: _nodes,
              nodeColor: widget.nodeColor,
              lineColor: widget.lineColor,
            ),
          );
        }

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            for (final n in _nodes) {
              n.x += n.vx;
              n.y += n.vy;
              if (n.x < 0 || n.x > size.width) n.vx *= -1;
              if (n.y < 0 || n.y > size.height) n.vy *= -1;
            }
            return CustomPaint(
              size: size,
              painter: _NetworkPainter(
                nodes: _nodes,
                nodeColor: widget.nodeColor,
                lineColor: widget.lineColor,
              ),
            );
          },
        );
      },
    );
  }
}

class _NetworkPainter extends CustomPainter {
  final List<_Node> nodes;
  final Color nodeColor;
  final Color lineColor;
  static const linkDistance = 120.0;

  _NetworkPainter({required this.nodes, required this.nodeColor, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()..color = nodeColor.withOpacity(0.55);
    final linePaint = Paint()..strokeWidth = 1;

    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final a = nodes[i], b = nodes[j];
        final dx = a.x - b.x, dy = a.y - b.y;
        final dist = sqrt(dx * dx + dy * dy);
        if (dist < linkDistance) {
          linePaint.color = lineColor.withOpacity((1 - dist / linkDistance) * 0.35);
          canvas.drawLine(Offset(a.x, a.y), Offset(b.x, b.y), linePaint);
        }
      }
    }
    for (final n in nodes) {
      canvas.drawCircle(Offset(n.x, n.y), 2.2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _NetworkPainter oldDelegate) => true;
}

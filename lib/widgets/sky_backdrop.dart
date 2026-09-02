import 'package:flutter/material.dart';

class SkyBackdrop extends StatefulWidget {
  const SkyBackdrop({
    super.key,
    required this.asset,
    this.darken = 0.12,
    this.kenBurns = true,
  });

  final String asset;
  final double darken;
  final bool kenBurns;

  @override
  State<SkyBackdrop> createState() => _SkyBackdropState();
}

class _SkyBackdropState extends State<SkyBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 22),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset(
      widget.asset,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );

    if (widget.kenBurns) {
      image = ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 1.08).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        ),
        child: image,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        image,
        ColoredBox(color: Colors.black.withValues(alpha: widget.darken)),
      ],
    );
  }
}

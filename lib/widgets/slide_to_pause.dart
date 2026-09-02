import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SlideToPause extends StatefulWidget {
  const SlideToPause({
    super.key,
    required this.label,
    required this.onCompleted,
  });

  final String label;
  final VoidCallback onCompleted;

  @override
  State<SlideToPause> createState() => _SlideToPauseState();
}

class _SlideToPauseState extends State<SlideToPause> {
  double _t = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const thumb = 52.0;
        final max = constraints.maxWidth - thumb - 10;
        return Container(
          height: 64,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: (1 - _t * 1.4).clamp(0, 1),
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Transform.translate(
                  offset: Offset(_t * max, 0),
                  child: GestureDetector(
                    onHorizontalDragUpdate: (d) {
                      setState(() {
                        _t = (_t + d.delta.dx / max).clamp(0.0, 1.0);
                      });
                    },
                    onHorizontalDragEnd: (_) {
                      if (_t > 0.86) {
                        HapticFeedback.mediumImpact();
                        widget.onCompleted();
                      }
                      setState(() => _t = 0);
                    },
                    child: Container(
                      width: thumb,
                      height: thumb,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          image: AssetImage('assets/images/sunrise_sky.png'),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

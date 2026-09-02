import 'package:flutter/material.dart';

class PhoneWindow extends StatelessWidget {
  const PhoneWindow({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 19.4,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -3,
            top: 90,
            child: _sideButton(height: 28),
          ),
          Positioned(
            left: -3,
            top: 128,
            child: _sideButton(height: 48),
          ),
          Positioned(
            left: -3,
            top: 184,
            child: _sideButton(height: 48),
          ),
          Positioned(
            right: -3,
            top: 140,
            child: _sideButton(height: 64),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(44),
                border: Border.all(color: const Color(0xFFC9CCD1), width: 11),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.22),
                    blurRadius: 36,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  border: Border.all(
                    color: const Color(0xFFE8E8EC),
                    width: 1.2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(33),
                  child: Stack(
                    children: [
                      if (child != null) Positioned.fill(child: child!),
                      const Align(
                        alignment: Alignment(0, -0.92),
                        child: _DynamicIsland(),
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
  }

  Widget _sideButton({required double height}) {
    return Container(
      width: 4,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFB8B8BE),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _DynamicIsland extends StatelessWidget {
  const _DynamicIsland();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 26,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

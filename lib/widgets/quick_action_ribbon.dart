import 'package:flutter/material.dart';

class QuickActionRibbon extends StatelessWidget {
  final VoidCallback onTapSoundCenter;
  final VoidCallback onTapTasbih;

  const QuickActionRibbon({
    super.key,
    required this.onTapSoundCenter,
    required this.onTapTasbih,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;

    Widget buildButton({
      required IconData icon,
      required String label,
      required VoidCallback onTap,
    }) {
      return Expanded(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: primary, size: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A241C),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        children: [
          buildButton(
            icon: Icons.multitrack_audio,
            label: 'Suara Azan',
            onTap: onTapSoundCenter,
          ),
          const SizedBox(width: 12),
          buildButton(
            icon: Icons.fingerprint,
            label: 'Tasbih Digital',
            onTap: onTapTasbih,
          ),
        ],
      ),
    );
  }
}

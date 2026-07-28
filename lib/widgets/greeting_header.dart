import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_name_dialog.dart';

class GreetingHeader extends StatelessWidget {
  final String userName;
  final Function(String) onNameChanged;

  const GreetingHeader({
    super.key,
    required this.userName,
    required this.onNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentGold = theme.colorScheme.secondary;
    final primaryEmerald = theme.primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Assalamu\'alaikum,',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        color: const Color(0xFF4A6B5D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.waving_hand,
                      size: 16,
                      color: accentGold,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => EditNameDialog(
                        currentName: userName,
                        onSave: onNameChanged,
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          userName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0A241C),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: primaryEmerald.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit_outlined,
                          size: 15,
                          color: primaryEmerald,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.95),
                  const Color(0xFFE8F5E9).withValues(alpha: 0.85),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accentGold.withValues(alpha: 0.4), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: primaryEmerald.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Image.asset(
              'assets/images/logo.png',
              width: 38,
              height: 38,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.mosque,
                  size: 28,
                  color: primaryEmerald,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

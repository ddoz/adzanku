import 'package:flutter/material.dart';
import '../models/azan_sound.dart';

class SoundItemCard extends StatelessWidget {
  final AzanSound sound;
  final bool isSelected;
  final bool isPlaying;
  final bool isDownloading;
  final VoidCallback onSelect;
  final VoidCallback onPlayToggle;
  final VoidCallback onDownload;

  const SoundItemCard({
    super.key,
    required this.sound,
    required this.isSelected,
    required this.isPlaying,
    required this.isDownloading,
    required this.onSelect,
    required this.onPlayToggle,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? primary.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? primary : Colors.white.withValues(alpha: 0.9),
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Play / Pause Button
            InkWell(
              onTap: onPlayToggle,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isPlaying ? primary : primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: isPlaying ? Colors.white : primary,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Title & Reciter Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          sound.title,
                          style: const TextStyle(
                            color: Color(0xFF0A241C),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: sound.category == 'subuh'
                              ? const Color(0xFFB8860B).withValues(alpha: 0.15)
                              : primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: sound.category == 'subuh'
                                ? const Color(0xFFB8860B).withValues(alpha: 0.4)
                                : primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          sound.category == 'subuh' ? '🌅 Subuh' : '🕌 Reguler',
                          style: TextStyle(
                            color: sound.category == 'subuh' ? const Color(0xFFB8860B) : primary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (sound.isCustom) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Kustom',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${sound.reciter} • ${sound.durationText}',
                    style: const TextStyle(color: Color(0xFF4A6B5D), fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Download button or Selection indicator
            if (!sound.isDownloaded && !sound.isCustom)
              ElevatedButton.icon(
                onPressed: isDownloading ? null : onDownload,
                icon: isDownloading
                    ? SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(primary),
                        ),
                      )
                    : Icon(Icons.download, size: 16, color: primary),
                label: Text(
                  isDownloading ? 'Unduh...' : 'Unduh',
                  style: TextStyle(color: primary, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary.withValues(alpha: 0.1),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              )
            else
              InkWell(
                onTap: onSelect,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isSelected ? primary : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? primary : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.check,
                    size: 14,
                    color: isSelected ? Colors.white : Colors.transparent,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

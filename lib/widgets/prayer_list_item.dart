import 'package:flutter/material.dart';

class PrayerListItem extends StatelessWidget {
  final String prayerName;
  final String prayerTime;
  final String iconName;
  final bool isAlarmActive;
  final bool isNext;
  final ValueChanged<bool> onToggleAlarm;

  const PrayerListItem({
    super.key,
    required this.prayerName,
    required this.prayerTime,
    required this.iconName,
    required this.isAlarmActive,
    required this.isNext,
    required this.onToggleAlarm,
  });

  IconData _getIconData(String name) {
    switch (name) {
      case 'nights_stay':
        return Icons.nights_stay_outlined;
      case 'wb_twilight':
        return Icons.wb_twilight;
      case 'wb_sunny':
        return Icons.wb_sunny_outlined;
      case 'wb_sunny_outlined':
        return Icons.wb_sunny;
      case 'wb_cloudy':
        return Icons.cloud_outlined;
      case 'brightness_4':
        return Icons.brightness_4_outlined;
      case 'bedtime':
        return Icons.bedtime_outlined;
      default:
        return Icons.access_time;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;
    final accentGold = const Color(0xFFB8860B);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: isNext ? primary.withValues(alpha: 0.12) : Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isNext ? primary : Colors.white.withValues(alpha: 0.9),
          width: isNext ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isNext ? primary : primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getIconData(iconName),
            color: isNext ? Colors.white : primary,
            size: 22,
          ),
        ),
        title: Text(
          prayerName,
          style: TextStyle(
            color: const Color(0xFF0A241C),
            fontWeight: isNext ? FontWeight.bold : FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: isNext
            ? Text(
                'Waktu Sholat Berikutnya',
                style: TextStyle(color: accentGold, fontSize: 11, fontWeight: FontWeight.bold),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              prayerTime,
              style: TextStyle(
                color: isNext ? primary : const Color(0xFF0A241C),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 12),
            Switch(
              value: isAlarmActive,
              onChanged: onToggleAlarm,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../services/permission_service.dart';

class PermissionDialog extends StatelessWidget {
  final VoidCallback onGranted;

  const PermissionDialog({
    super.key,
    required this.onGranted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryEmerald = theme.primaryColor;
    final accentGold = const Color(0xFFB8860B);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Shield Icon Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryEmerald.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.security, color: primaryEmerald, size: 40),
            ),

            const SizedBox(height: 18),

            const Text(
              'Izin Akses Aplikasi Adzanku',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A241C),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            const Text(
              'Untuk mengumandangkan Azan tepat waktu dan mendeteksi jadwal sholat presisi, mohon berikan izin berikut:',
              style: TextStyle(fontSize: 12, color: Color(0xFF4A6B5D)),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Permission Items
            _buildPermissionItem(
              icon: Icons.location_on_outlined,
              color: primaryEmerald,
              title: 'Lokasi GPS Presisi',
              subtitle: 'Menyesuaikan jadwal sholat sesuai kota Anda',
            ),
            const SizedBox(height: 12),
            _buildPermissionItem(
              icon: Icons.notifications_active_outlined,
              color: accentGold,
              title: 'Notifikasi & Alarm Azan',
              subtitle: 'Mengumandangkan Azan otomatis saat masuk waktu sholat',
            ),
            const SizedBox(height: 12),
            _buildPermissionItem(
              icon: Icons.multitrack_audio_outlined,
              color: primaryEmerald,
              title: 'Akses File Audio & Suara',
              subtitle: 'Memutar nada Azan & mengunggah audio kustom',
            ),

            const SizedBox(height: 24),

            // Allow Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await PermissionService().requestAllAppPermissions();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    onGranted();
                  }
                },
                icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 22),
                label: const Text(
                  'IZINKAN AKSES APLIKASI',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryEmerald,
                  elevation: 4,
                  shadowColor: primaryEmerald.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A241C),
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF4A6B5D),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/prayer_provider.dart';
import '../services/notification_service.dart';
import '../widgets/edit_name_dialog.dart';
import 'azan_alarm_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const Map<int, String> calculationMethods = {
    20: 'Kemenag RI (Kementerian Agama RI)',
    3: 'MWL (Muslim World League)',
    2: 'ISNA (Islamic Society of North America)',
    4: 'Umm Al-Qura (Makkah Al-Mukarramah)',
    5: 'Egyptian General Authority of Survey',
    1: 'University of Islamic Sciences, Karachi',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryEmerald = theme.primaryColor;
    final userProvider = Provider.of<UserProvider>(context);
    final prayerProvider = Provider.of<PrayerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan & Profil'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // User Name Profile Tile (Glassmorphism)
            Card(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primaryEmerald.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person, color: primaryEmerald),
                ),
                title: const Text(
                  'Nama Pemilik',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A241C)),
                ),
                subtitle: Text(userProvider.userName, style: const TextStyle(color: Color(0xFF4A6B5D))),
                trailing: const Icon(Icons.chevron_right, color: Color(0xFF0A241C)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => EditNameDialog(
                      currentName: userProvider.userName,
                      onSave: (newName) => userProvider.updateUserName(newName),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            // Calculation Method Selection Tile
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calculate_outlined, color: primaryEmerald),
                        const SizedBox(width: 10),
                        const Text(
                          'Metode Perhitungan Sholat',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0A241C)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      initialValue: userProvider.calculationMethod,
                      isExpanded: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: calculationMethods.entries.map((entry) {
                        return DropdownMenuItem<int>(
                          value: entry.key,
                          child: Text(
                            entry.value,
                            style: const TextStyle(fontSize: 13, color: Color(0xFF0A241C)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (newMethod) async {
                        if (newMethod != null) {
                          await userProvider.updateCalculationMethod(newMethod);
                          await prayerProvider.refreshSchedule(method: newMethod);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // GPS Sync Button
            Card(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primaryEmerald.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.gps_fixed, color: primaryEmerald),
                ),
                title: const Text('Perbarui Lokasi GPS', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A241C))),
                subtitle: Text(
                  prayerProvider.userLocation != null
                      ? '${prayerProvider.userLocation!.cityName}, ${prayerProvider.userLocation!.countryName}'
                      : 'Belum Terdeteksi',
                  style: const TextStyle(color: Color(0xFF4A6B5D)),
                ),
                trailing: Icon(Icons.refresh, color: primaryEmerald),
                onTap: () async {
                  await prayerProvider.refreshSchedule(method: userProvider.calculationMethod);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Lokasi GPS berhasil diperbarui!'),
                        backgroundColor: primaryEmerald,
                      ),
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 14),

            // Test Layar Azan Screen Tile
            Card(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB8860B).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.volume_up, color: Color(0xFFB8860B)),
                ),
                title: const Text('Uji Tampilan Layar Azan', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A241C))),
                subtitle: const Text('Buka tampilan layar penuh azan & uji tombol hentikan', style: TextStyle(color: Color(0xFF4A6B5D))),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFB8860B)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AzanAlarmScreen(
                        prayerName: prayerProvider.nextPrayer?.name ?? 'Maghrib',
                        locationName: prayerProvider.userLocation?.cityName ?? 'Jakarta',
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            // Test Alarm Notification Button
            Card(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade700.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.notifications_active, color: Colors.amber.shade800),
                ),
                title: const Text('Uji Coba Alarm & Notifikasi', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A241C))),
                subtitle: const Text('Kirim notifikasi sampel untuk menguji alarm azan', style: TextStyle(color: Color(0xFF4A6B5D))),
                trailing: Icon(Icons.send, color: primaryEmerald),
                onTap: () async {
                  await NotificationService().showTestNotification(userName: userProvider.userName);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Notifikasi pengujian dikirim! Periksa bilah notifikasi HP Anda.'),
                        backgroundColor: primaryEmerald,
                      ),
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 24),

            // App Information & Version Card
            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.mosque, color: primaryEmerald, size: 20);
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Adzanku Mobile App',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0A241C)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Created by Digitalera',
                    style: TextStyle(color: Color(0xFF4A6B5D), fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

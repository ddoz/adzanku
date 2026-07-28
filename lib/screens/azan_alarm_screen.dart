import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/sound_provider.dart';
import '../providers/user_provider.dart';
import '../models/azan_sound.dart';

class AzanAlarmScreen extends StatefulWidget {
  final String prayerName;
  final String locationName;
  final AzanSound? azanSound;

  const AzanAlarmScreen({
    super.key,
    required this.prayerName,
    required this.locationName,
    this.azanSound,
  });

  @override
  State<AzanAlarmScreen> createState() => _AzanAlarmScreenState();
}

class _AzanAlarmScreenState extends State<AzanAlarmScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Play Azan audio on screen start according to prayer type (Subuh vs Reguler)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final soundProvider = Provider.of<SoundProvider>(context, listen: false);

      final isSubuh = widget.prayerName.toLowerCase().contains('subuh');
      final targetSoundId = isSubuh
          ? userProvider.selectedSubuhSoundId
          : userProvider.selectedRegulerSoundId;

      final soundToPlay = widget.azanSound ??
          soundProvider.allSounds.firstWhere(
            (s) => s.id == targetSoundId,
            orElse: () => soundProvider.presetSounds.firstWhere(
              (s) => isSubuh ? s.category == 'subuh' : s.category == 'reguler',
            ),
          );

      soundProvider.togglePlayPreview(soundToPlay);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _stopAzan() async {
    final soundProvider = Provider.of<SoundProvider>(context, listen: false);
    if (soundProvider.playingId != null) {
      final soundToStop = soundProvider.allSounds.firstWhere(
        (s) => s.id == soundProvider.playingId,
        orElse: () => soundProvider.presetSounds.first,
      );
      await soundProvider.togglePlayPreview(soundToStop);
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryEmerald = theme.primaryColor;
    final accentGold = const Color(0xFFB8860B);
    final soundProvider = Provider.of<SoundProvider>(context);
    final activeSound = widget.azanSound ??
        soundProvider.presetSounds.firstWhere(
          (s) => s.id == soundProvider.playingId,
          orElse: () => soundProvider.presetSounds.first,
        );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFEEF7F3),
              Color(0xFFE0F2EF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Active Alarm Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: primaryEmerald.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: primaryEmerald.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.notifications_active, color: primaryEmerald, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'WAKTU SHOLAT ${widget.prayerName.toUpperCase()}',
                        style: TextStyle(
                          color: primaryEmerald,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                // Center Pulsing Graphic & Calligraphy
                Column(
                  children: [
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: primaryEmerald.withValues(alpha: 0.2),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                            BoxShadow(
                              color: accentGold.withValues(alpha: 0.15),
                              blurRadius: 25,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.mosque, size: 90, color: primaryEmerald);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Arabic Bismillah Calligraphy
                    Text(
                      'اللَّهُ أَكْبَرُ اللَّهُ أَكْبَرُ',
                      style: GoogleFonts.amiri(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: accentGold,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Telah masuk waktu sholat ${widget.prayerName}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0A241C),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Untuk wilayah ${widget.locationName} dan sekitarnya',
                      style: const TextStyle(fontSize: 14, color: Color(0xFF4A6B5D)),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    // Active Sound Voice Info
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.volume_up, size: 16, color: primaryEmerald),
                          const SizedBox(width: 8),
                          Text(
                            activeSound.title,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0A241C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Bottom Stop & Snooze Buttons
                Column(
                  children: [
                    // Big "HENTIKAN AZAN" Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _stopAzan,
                        icon: const Icon(Icons.stop_circle, color: Colors.white, size: 24),
                        label: const Text(
                          'HENTIKAN AZAN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          elevation: 6,
                          shadowColor: Colors.red.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Secondary Snooze Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _stopAzan();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Alarm diingatkan 5 menit lagi.'),
                              backgroundColor: primaryEmerald,
                            ),
                          );
                        },
                        icon: Icon(Icons.snooze, color: primaryEmerald, size: 20),
                        label: Text(
                          'Ingatkan 5 Menit Lagi',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: primaryEmerald,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.8),
                          side: BorderSide(color: primaryEmerald, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

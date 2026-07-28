import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/prayer_timing.dart';

class InteractiveSolarArc extends StatefulWidget {
  final List<PrayerTiming> timings;
  final PrayerTiming? nextPrayer;
  final Duration timeRemaining;
  final Function(PrayerTiming)? onSelectPrayer;

  const InteractiveSolarArc({
    super.key,
    required this.timings,
    required this.nextPrayer,
    required this.timeRemaining,
    this.onSelectPrayer,
  });

  @override
  State<InteractiveSolarArc> createState() => _InteractiveSolarArcState();
}

class _InteractiveSolarArcState extends State<InteractiveSolarArc>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _updateSelectedIndex();
  }

  @override
  void didUpdateWidget(covariant InteractiveSolarArc oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    if (widget.nextPrayer != null) {
      final index = widget.timings.indexWhere(
        (t) => t.englishName == widget.nextPrayer!.englishName,
      );
      if (index != -1) {
        setState(() {
          _selectedIndex = index;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) return '00:00:00';
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours : $minutes : $seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryEmerald = theme.primaryColor;
    final accentGold = const Color(0xFFB8860B);
    final selectedPrayer = widget.timings.isNotEmpty && _selectedIndex < widget.timings.length
        ? widget.timings[_selectedIndex]
        : widget.nextPrayer;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: primaryEmerald.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryEmerald.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.wb_sunny_outlined, color: primaryEmerald, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Busur Waktu Sholat',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0A241C),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accentGold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  selectedPrayer?.name ?? '',
                  style: TextStyle(
                    color: accentGold,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Interactive Arc & Node Selector
          SizedBox(
            height: 90,
            child: Stack(
              children: [
                // Custom Paint Arc Curve
                Positioned.fill(
                  child: CustomPaint(
                    painter: _ArcPainter(
                      progress: _calculateDayProgress(),
                      primaryColor: primaryEmerald,
                      accentColor: accentGold,
                    ),
                  ),
                ),
                // Interactive Prayer Nodes Row
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(widget.timings.length, (index) {
                      final prayer = widget.timings[index];
                      final isSelected = index == _selectedIndex;
                      final isNext = widget.nextPrayer?.englishName == prayer.englishName;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                          if (widget.onSelectPrayer != null) {
                            widget.onSelectPrayer!(prayer);
                          }
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: EdgeInsets.all(isSelected ? 8 : 6),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primaryEmerald
                                    : (isNext ? accentGold : Colors.white),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? accentGold : Colors.white,
                                  width: 2,
                                ),
                                boxShadow: [
                                  if (isSelected)
                                    BoxShadow(
                                      color: primaryEmerald.withValues(alpha: 0.3),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                ],
                              ),
                              child: Icon(
                                _getIconForPrayer(prayer.name),
                                size: isSelected ? 18 : 14,
                                color: isSelected
                                    ? Colors.white
                                    : (isNext ? Colors.white : const Color(0xFF4A6B5D)),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              prayer.name,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? primaryEmerald : const Color(0xFF4A6B5D),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Colors.black12),
          const SizedBox(height: 12),

          // Selected Prayer Time & Countdown Display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Waktu ${selectedPrayer?.name ?? ''}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF4A6B5D)),
                  ),
                  Text(
                    selectedPrayer?.time ?? '--:--',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryEmerald,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Hitung Mundur Sholat',
                    style: TextStyle(fontSize: 11, color: Color(0xFF4A6B5D)),
                  ),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Text(
                        _formatDuration(widget.timeRemaining),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: accentGold,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateDayProgress() {
    final now = DateTime.now();
    final totalMinutes = now.hour * 60 + now.minute;
    return (totalMinutes / (24 * 60)).clamp(0.0, 1.0);
  }

  IconData _getIconForPrayer(String name) {
    switch (name) {
      case 'Imsak':
        return Icons.nights_stay_outlined;
      case 'Subuh':
        return Icons.wb_twilight;
      case 'Terbit':
        return Icons.wb_sunny_outlined;
      case 'Dzuhur':
        return Icons.wb_sunny;
      case 'Ashar':
        return Icons.cloud_outlined;
      case 'Maghrib':
        return Icons.brightness_4_outlined;
      case 'Isya':
        return Icons.bedtime_outlined;
      default:
        return Icons.access_time;
    }
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color accentColor;

  _ArcPainter({
    required this.progress,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintBase = Paint()
      ..color = primaryColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;



    final path = Path();
    path.moveTo(10, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2,
      5,
      size.width - 10,
      size.height - 30,
    );

    canvas.drawPath(path, paintBase);

    // Draw Sun indicator on arc
    final sunAngle = progress * pi;
    final sunX = (size.width / 2) - (size.width / 2 - 20) * cos(sunAngle);
    final sunY = (size.height - 25) - (size.height - 40) * sin(sunAngle);

    final sunPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(sunX, sunY), 6, sunPaint);
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../providers/tasbih_provider.dart';

class TasbihScreen extends StatelessWidget {
  const TasbihScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryEmerald = theme.primaryColor;
    final tasbihProvider = Provider.of<TasbihProvider>(context);
    final currentZikr = tasbihProvider.currentZikr;

    double percent = (tasbihProvider.count / tasbihProvider.target).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasbih Digital'),
        actions: [
          IconButton(
            onPressed: () => tasbihProvider.reset(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Hitungan',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Zikr Preset Horizontal Chips
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: TasbihProvider.zikrPresets.length,
                itemBuilder: (context, index) {
                  final zikr = TasbihProvider.zikrPresets[index];
                  final isSelected = tasbihProvider.selectedZikrIndex == index;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(
                        zikr.latin,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF0A241C),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: primaryEmerald,
                      backgroundColor: Colors.white.withValues(alpha: 0.7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.9)),
                      ),
                      onSelected: (_) => tasbihProvider.selectZikr(index),
                    ),
                  );
                },
              ),
            ),

            const Spacer(),

            // Arabic Zikr Text Display Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: primaryEmerald.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    currentZikr.arabic,
                    style: GoogleFonts.amiri(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: primaryEmerald,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentZikr.translation,
                    style: const TextStyle(color: Color(0xFF4A6B5D), fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Interactive Touch Circular Counter Button
            GestureDetector(
              onTap: () => tasbihProvider.increment(),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.85),
                  boxShadow: [
                    BoxShadow(
                      color: primaryEmerald.withValues(alpha: 0.12),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: CircularPercentIndicator(
                  radius: 110.0,
                  lineWidth: 12.0,
                  animation: true,
                  animateFromLastPercent: true,
                  percent: percent,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${tasbihProvider.count}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0A241C),
                        ),
                      ),
                      Text(
                        'Target: ${tasbihProvider.target}',
                        style: TextStyle(color: primaryEmerald, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: primaryEmerald,
                  backgroundColor: primaryEmerald.withValues(alpha: 0.12),
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Tekan lingkaran untuk menghitung',
              style: TextStyle(color: Color(0xFF4A6B5D), fontSize: 12),
            ),

            const Spacer(),

            // Target selector & Lap count info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Putaran Selesai: ${tasbihProvider.totalLapCount}',
                    style: const TextStyle(color: Color(0xFF0A241C), fontWeight: FontWeight.w700),
                  ),
                  Row(
                    children: [33, 100, 1000].map((targetVal) {
                      final isSelected = tasbihProvider.target == targetVal;
                      return Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: OutlinedButton(
                          onPressed: () => tasbihProvider.setTarget(targetVal),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: isSelected ? primaryEmerald : Colors.white.withValues(alpha: 0.8),
                            side: BorderSide(
                              color: isSelected ? primaryEmerald : Colors.white,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          ),
                          child: Text(
                            '$targetVal',
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF0A241C),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

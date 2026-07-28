import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/prayer_provider.dart';
import '../widgets/greeting_header.dart';
import '../widgets/location_bar.dart';
import '../widgets/interactive_solar_arc.dart';
import '../widgets/quick_action_ribbon.dart';
import '../widgets/daily_wisdom_card.dart';
import '../widgets/prayer_list_item.dart';

class HomeScreen extends StatelessWidget {
  final Function(int)? onNavigateTab;

  const HomeScreen({
    super.key,
    this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final prayerProvider = Provider.of<PrayerProvider>(context);
    final schedule = prayerProvider.schedule;
    final nextPrayer = prayerProvider.nextPrayer;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await prayerProvider.refreshSchedule();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Time-of-Day Greeting Header with Name Edit Dialog
                GreetingHeader(
                  userName: userProvider.userName,
                  onNameChanged: (newName) {
                    userProvider.updateUserName(newName);
                  },
                ),

                // GPS Location & Hijri Date Bar
                LocationBar(
                  cityName: prayerProvider.userLocation?.cityName ?? 'Lokasi Terdeteksi',
                  countryName: prayerProvider.userLocation?.countryName ?? 'Indonesia',
                  hijriDate: schedule?.hijriDate ?? '14 Safar 1448 H',
                  onRefresh: () => prayerProvider.refreshSchedule(),
                  isLoading: prayerProvider.isLoading,
                ),

                // Interactive Celestial Solar Arc (Dynamic Prayer Selector & Countdown)
                if (schedule != null)
                  InteractiveSolarArc(
                    timings: schedule.timings,
                    nextPrayer: nextPrayer,
                    timeRemaining: prayerProvider.timeToNextPrayer,
                  ),

                // Quick Action Ribbons
                QuickActionRibbon(
                  onTapSoundCenter: () {
                    if (onNavigateTab != null) onNavigateTab!(1);
                  },
                  onTapTasbih: () {
                    if (onNavigateTab != null) onNavigateTab!(2);
                  },
                ),

                // Daily Quranic Wisdom Card
                const DailyWisdomCard(),

                // Section Title: Daily Prayer Schedule
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Jadwal Sholat Hari Ini',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0A241C),
                        ),
                      ),
                      if (schedule != null)
                        Text(
                          schedule.gregorianDate,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF4A6B5D)),
                        ),
                    ],
                  ),
                ),

                // Prayer Timings List
                if (prayerProvider.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Center(
                      child: CircularProgressIndicator(color: Color(0xFF0F5A47)),
                    ),
                  )
                else if (schedule != null)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: schedule.timings.length,
                    itemBuilder: (context, index) {
                      final item = schedule.timings[index];
                      final isNext = nextPrayer?.englishName == item.englishName;

                      return PrayerListItem(
                        prayerName: item.name,
                        prayerTime: item.time,
                        iconName: item.iconName,
                        isAlarmActive: item.isAlarmActive,
                        isNext: isNext,
                        onToggleAlarm: (_) {
                          prayerProvider.togglePrayerAlarm(index);
                        },
                      );
                    },
                  ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

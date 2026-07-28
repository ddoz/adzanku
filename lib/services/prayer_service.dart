import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prayer_timing.dart';

class PrayerService {
  static const String _baseUrl = 'https://api.aladhan.com/v1/timings';

  Future<PrayerSchedule> fetchPrayerSchedule({
    required double latitude,
    required double longitude,
    required String locationName,
    int method = 20, // 20: Kemenag RI, 3: MWL, 2: ISNA, 4: Makkah
  }) async {
    final int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final Uri url = Uri.parse(
      '$_baseUrl/$timestamp?latitude=$latitude&longitude=$longitude&method=$method',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['code'] == 200 && data['data'] != null) {
          final timingsData = data['data']['timings'];
          final dateData = data['data']['date'];
          final hijriData = dateData['hijri'];
          final methodData = data['data']['meta']['method'];

          final String hijriStr = '${hijriData['day']} ${hijriData['month']['en']} ${hijriData['year']} H';
          final String gregorianStr = dateData['readable'] ?? '';
          final String methodName = methodData['name'] ?? 'Kemenag RI';

          final now = DateTime.now();

          DateTime parsePrayerTime(String timeStr) {
            final cleanTime = timeStr.split(' ').first; // remove "(WIB)" if any
            final parts = cleanTime.split(':');
            final hour = int.parse(parts[0]);
            final minute = int.parse(parts[1]);
            return DateTime(now.year, now.month, now.day, hour, minute);
          }

          final List<PrayerTiming> timings = [
            PrayerTiming(
              name: 'Imsak',
              englishName: 'Imsak',
              time: timingsData['Imsak']?.split(' ').first ?? '04:30',
              dateTime: parsePrayerTime(timingsData['Imsak'] ?? '04:30'),
              iconName: 'nights_stay',
              isAlarmActive: false,
            ),
            PrayerTiming(
              name: 'Subuh',
              englishName: 'Fajr',
              time: timingsData['Fajr']?.split(' ').first ?? '04:40',
              dateTime: parsePrayerTime(timingsData['Fajr'] ?? '04:40'),
              iconName: 'wb_twilight',
              isAlarmActive: true,
            ),
            PrayerTiming(
              name: 'Terbit',
              englishName: 'Sunrise',
              time: timingsData['Sunrise']?.split(' ').first ?? '05:55',
              dateTime: parsePrayerTime(timingsData['Sunrise'] ?? '05:55'),
              iconName: 'wb_sunny',
              isAlarmActive: false,
            ),
            PrayerTiming(
              name: 'Dzuhur',
              englishName: 'Dhuhr',
              time: timingsData['Dhuhr']?.split(' ').first ?? '12:00',
              dateTime: parsePrayerTime(timingsData['Dhuhr'] ?? '12:00'),
              iconName: 'wb_sunny_outlined',
              isAlarmActive: true,
            ),
            PrayerTiming(
              name: 'Ashar',
              englishName: 'Asr',
              time: timingsData['Asr']?.split(' ').first ?? '15:20',
              dateTime: parsePrayerTime(timingsData['Asr'] ?? '15:20'),
              iconName: 'wb_cloudy',
              isAlarmActive: true,
            ),
            PrayerTiming(
              name: 'Maghrib',
              englishName: 'Maghrib',
              time: timingsData['Maghrib']?.split(' ').first ?? '18:05',
              dateTime: parsePrayerTime(timingsData['Maghrib'] ?? '18:05'),
              iconName: 'brightness_4',
              isAlarmActive: true,
            ),
            PrayerTiming(
              name: 'Isya',
              englishName: 'Isha',
              time: timingsData['Isha']?.split(' ').first ?? '19:15',
              dateTime: parsePrayerTime(timingsData['Isha'] ?? '19:15'),
              iconName: 'bedtime',
              isAlarmActive: true,
            ),
          ];

          return PrayerSchedule(
            locationName: locationName,
            latitude: latitude,
            longitude: longitude,
            hijriDate: hijriStr,
            gregorianDate: gregorianStr,
            calculationMethod: methodName,
            timings: timings,
          );
        }
      }
    } catch (_) {
      // Fallback offline schedule if connection fails
    }

    return _generateFallbackSchedule(locationName, latitude, longitude);
  }

  PrayerSchedule _generateFallbackSchedule(String locationName, double lat, double lng) {
    final now = DateTime.now();
    return PrayerSchedule(
      locationName: locationName,
      latitude: lat,
      longitude: lng,
      hijriDate: '14 Safar 1448 H',
      gregorianDate: '${now.day} Jul ${now.year}',
      calculationMethod: 'Kemenag RI (Mode Offline)',
      timings: [
        PrayerTiming(
          name: 'Imsak',
          englishName: 'Imsak',
          time: '04:30',
          dateTime: DateTime(now.year, now.month, now.day, 4, 30),
          iconName: 'nights_stay',
          isAlarmActive: false,
        ),
        PrayerTiming(
          name: 'Subuh',
          englishName: 'Fajr',
          time: '04:40',
          dateTime: DateTime(now.year, now.month, now.day, 4, 40),
          iconName: 'wb_twilight',
          isAlarmActive: true,
        ),
        PrayerTiming(
          name: 'Terbit',
          englishName: 'Sunrise',
          time: '05:55',
          dateTime: DateTime(now.year, now.month, now.day, 5, 55),
          iconName: 'wb_sunny',
          isAlarmActive: false,
        ),
        PrayerTiming(
          name: 'Dzuhur',
          englishName: 'Dhuhr',
          time: '12:02',
          dateTime: DateTime(now.year, now.month, now.day, 12, 2),
          iconName: 'wb_sunny_outlined',
          isAlarmActive: true,
        ),
        PrayerTiming(
          name: 'Ashar',
          englishName: 'Asr',
          time: '15:24',
          dateTime: DateTime(now.year, now.month, now.day, 15, 24),
          iconName: 'wb_cloudy',
          isAlarmActive: true,
        ),
        PrayerTiming(
          name: 'Maghrib',
          englishName: 'Maghrib',
          time: '18:06',
          dateTime: DateTime(now.year, now.month, now.day, 18, 6),
          iconName: 'brightness_4',
          isAlarmActive: true,
        ),
        PrayerTiming(
          name: 'Isya',
          englishName: 'Isha',
          time: '19:18',
          dateTime: DateTime(now.year, now.month, now.day, 19, 18),
          iconName: 'bedtime',
          isAlarmActive: true,
        ),
      ],
    );
  }
}

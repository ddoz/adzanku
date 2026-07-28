class PrayerTiming {
  final String name; // e.g. "Subuh", "Dzuhur", "Ashar", "Maghrib", "Isya", "Imsak", "Terbit"
  final String englishName; // e.g. "Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"
  final String time; // e.g. "04:30"
  final DateTime dateTime;
  final bool isAlarmActive;
  final String iconName;

  PrayerTiming({
    required this.name,
    required this.englishName,
    required this.time,
    required this.dateTime,
    this.isAlarmActive = true,
    required this.iconName,
  });

  PrayerTiming copyWith({
    String? name,
    String? englishName,
    String? time,
    DateTime? dateTime,
    bool? isAlarmActive,
    String? iconName,
  }) {
    return PrayerTiming(
      name: name ?? this.name,
      englishName: englishName ?? this.englishName,
      time: time ?? this.time,
      dateTime: dateTime ?? this.dateTime,
      isAlarmActive: isAlarmActive ?? this.isAlarmActive,
      iconName: iconName ?? this.iconName,
    );
  }
}

class PrayerSchedule {
  final String locationName;
  final double latitude;
  final double longitude;
  final String hijriDate;
  final String gregorianDate;
  final String calculationMethod;
  final List<PrayerTiming> timings;

  PrayerSchedule({
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.hijriDate,
    required this.gregorianDate,
    required this.calculationMethod,
    required this.timings,
  });

  PrayerTiming? get nextPrayer {
    final now = DateTime.now();
    for (var prayer in timings) {
      if (prayer.englishName == 'Sunrise' || prayer.englishName == 'Imsak') continue;
      if (prayer.dateTime.isAfter(now)) {
        return prayer;
      }
    }
    // If all prayers today passed, return first prayer of tomorrow or Fajr
    return timings.firstWhere(
      (p) => p.englishName == 'Fajr',
      orElse: () => timings.first,
    );
  }
}

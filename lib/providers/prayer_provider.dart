import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/prayer_timing.dart';
import '../services/location_service.dart';
import '../services/prayer_service.dart';
import '../services/notification_service.dart';

class PrayerProvider extends ChangeNotifier {
  final PrayerService _prayerService = PrayerService();
  final LocationService _locationService = LocationService();
  final NotificationService _notificationService = NotificationService();

  PrayerSchedule? _schedule;
  UserLocation? _userLocation;
  bool _isLoading = true;
  String _errorMessage = '';
  Duration _timeToNextPrayer = Duration.zero;
  Timer? _countdownTimer;

  PrayerSchedule? get schedule => _schedule;
  UserLocation? get userLocation => _userLocation;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  Duration get timeToNextPrayer => _timeToNextPrayer;

  PrayerTiming? get nextPrayer => _schedule?.nextPrayer;

  PrayerProvider() {
    refreshSchedule();
  }

  Future<void> refreshSchedule({int method = 20}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _userLocation = await _locationService.getCurrentLocation();
      _schedule = await _prayerService.fetchPrayerSchedule(
        latitude: _userLocation!.latitude,
        longitude: _userLocation!.longitude,
        locationName: _userLocation!.cityName,
        method: method,
      );

      _startCountdownTimer();
      _scheduleNotifications();
    } catch (e) {
      _errorMessage = 'Gagal memuat jadwal sholat: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void togglePrayerAlarm(int index) {
    if (_schedule == null) return;
    final updatedTimings = List<PrayerTiming>.from(_schedule!.timings);
    final current = updatedTimings[index];

    updatedTimings[index] = current.copyWith(
      isAlarmActive: !current.isAlarmActive,
    );

    _schedule = PrayerSchedule(
      locationName: _schedule!.locationName,
      latitude: _schedule!.latitude,
      longitude: _schedule!.longitude,
      hijriDate: _schedule!.hijriDate,
      gregorianDate: _schedule!.gregorianDate,
      calculationMethod: _schedule!.calculationMethod,
      timings: updatedTimings,
    );

    notifyListeners();
    _scheduleNotifications();
  }

  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    _updateCountdown();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    final next = nextPrayer;
    if (next != null) {
      final now = DateTime.now();
      var target = next.dateTime;
      if (target.isBefore(now)) {
        target = target.add(const Duration(days: 1));
      }
      _timeToNextPrayer = target.difference(now);
      notifyListeners();
    }
  }

  Future<void> _scheduleNotifications() async {
    if (_schedule == null) return;
    await _notificationService.cancelAllNotifications();

    int id = 1;
    for (var prayer in _schedule!.timings) {
      if (prayer.isAlarmActive &&
          prayer.englishName != 'Sunrise' &&
          prayer.englishName != 'Imsak') {
        await _notificationService.schedulePrayerAlarm(
          id: id++,
          title: 'Waktu Sholat ${prayer.name}',
          body: 'Telah masuk waktu sholat ${prayer.name} untuk wilayah ${_schedule!.locationName} dan sekitarnya.',
          scheduledDateTime: prayer.dateTime,
        );
      }
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}

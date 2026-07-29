import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // Background notification trigger handler when app is closed/killed
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static const String prayerChannelId = 'adzanku_prayer_channel';
  static const String testChannelId = 'adzanku_test_channel';

  Future<void> initNotification() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification click
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Create high-importance Android Notification Channels for Android 8.0+
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      const AndroidNotificationChannel prayerChannel = AndroidNotificationChannel(
        prayerChannelId,
        'Waktu Sholat & Azan',
        description: 'Notifikasi Alarm Azan Waktu Sholat Adzanku',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

      const AndroidNotificationChannel testChannel = AndroidNotificationChannel(
        testChannelId,
        'Uji Coba Alarm Adzanku',
        description: 'Channel Uji Coba Suara & Notifikasi Azan',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

      await androidImplementation.createNotificationChannel(prayerChannel);
      await androidImplementation.createNotificationChannel(testChannel);
    }
  }

  Future<void> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      await androidImplementation.requestExactAlarmsPermission();
    }
  }

  Future<void> schedulePrayerAlarm({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDateTime,
    String? soundPath,
  }) async {
    if (scheduledDateTime.isBefore(DateTime.now())) return;

    final tz.TZDateTime tzTime = tz.TZDateTime.from(scheduledDateTime, tz.local);

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      prayerChannelId,
      'Waktu Sholat & Azan',
      channelDescription: 'Notifikasi Alarm Azan Waktu Sholat Adzanku',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
      visibility: NotificationVisibility.public,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(presentSound: true),
    );

    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzTime,
        platformDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (_) {
      try {
        await _notificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tzTime,
          platformDetails,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } catch (_) {}
    }
  }

  Future<void> showTestNotification({required String userName}) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      testChannelId,
      'Uji Coba Alarm Adzanku',
      channelDescription: 'Channel Uji Coba Suara & Notifikasi Azan',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      visibility: NotificationVisibility.public,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(presentSound: true),
    );

    await _notificationsPlugin.show(
      999,
      'Assalamu\'alaikum, $userName',
      'Sistem notifikasi Azan Adzanku berfungsi dengan baik! Notifikasi & Alarm aktif.',
      platformDetails,
    );
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}

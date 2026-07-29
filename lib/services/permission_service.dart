import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  /// Check if essential permissions (Location & Notification) are granted
  Future<bool> hasEssentialPermissions() async {
    final locationStatus = await Permission.locationWhenInUse.status;
    final notificationStatus = await Permission.notification.status;
    return locationStatus.isGranted && notificationStatus.isGranted;
  }

  /// Request all required app runtime permissions sequentially with system dialogs
  Future<Map<Permission, PermissionStatus>> requestAllAppPermissions() async {
    Map<Permission, PermissionStatus> statuses = {};

    // 1. Notification Permission
    statuses[Permission.notification] = await Permission.notification.request();

    // 2. Location Permission
    statuses[Permission.locationWhenInUse] = await Permission.locationWhenInUse.request();

    // 3. Exact Alarm Permission (Android 12+)
    if (await Permission.scheduleExactAlarm.isDenied) {
      statuses[Permission.scheduleExactAlarm] = await Permission.scheduleExactAlarm.request();
    }

    // 4. Audio / Media Storage Permission
    if (await Permission.audio.isDenied) {
      statuses[Permission.audio] = await Permission.audio.request();
    }

    return statuses;
  }
}

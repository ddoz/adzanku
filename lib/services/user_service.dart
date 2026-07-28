import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _keyUserName = 'user_name';
  static const String _keyCalculationMethod = 'calculation_method';
  static const String _keySelectedSoundId = 'selected_sound_id';
  static const String _keySelectedSubuhSoundId = 'selected_subuh_sound_id';
  static const String _keySelectedRegulerSoundId = 'selected_reguler_sound_id';

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName) ?? 'Sahabat Adzanku';
  }

  Future<bool> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_keyUserName, name.trim());
  }

  Future<int> getCalculationMethod() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyCalculationMethod) ?? 20;
  }

  Future<bool> setCalculationMethod(int methodId) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(_keyCalculationMethod, methodId);
  }

  Future<String> getSelectedSoundId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySelectedSoundId) ?? 'adzan_mekah';
  }

  Future<bool> setSelectedSoundId(String soundId) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_keySelectedSoundId, soundId);
  }

  Future<String> getSubuhSoundId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySelectedSubuhSoundId) ?? 'adzan_fajr_mekah';
  }

  Future<bool> setSubuhSoundId(String soundId) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_keySelectedSubuhSoundId, soundId);
  }

  Future<String> getRegulerSoundId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySelectedRegulerSoundId) ?? 'adzan_mekah';
  }

  Future<bool> setRegulerSoundId(String soundId) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_keySelectedRegulerSoundId, soundId);
  }

  Future<bool> getAlarmToggle(String prayerName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('alarm_$prayerName') ?? true;
  }

  Future<bool> setAlarmToggle(String prayerName, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setBool('alarm_$prayerName', value);
  }
}

import 'package:flutter/foundation.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();

  String _userName = 'Sahabat Adzanku';
  int _calculationMethod = 20; // 20: Kemenag RI
  String _selectedSoundId = 'adzan_mekah';
  String _selectedSubuhSoundId = 'adzan_fajr_mekah';
  String _selectedRegulerSoundId = 'adzan_mekah';
  bool _isLoading = true;

  String get userName => _userName;
  int get calculationMethod => _calculationMethod;
  String get selectedSoundId => _selectedSoundId;
  String get selectedSubuhSoundId => _selectedSubuhSoundId;
  String get selectedRegulerSoundId => _selectedRegulerSoundId;
  bool get isLoading => _isLoading;

  UserProvider() {
    loadUserData();
  }

  Future<void> loadUserData() async {
    _isLoading = true;
    notifyListeners();

    _userName = await _userService.getUserName();
    _calculationMethod = await _userService.getCalculationMethod();
    _selectedSoundId = await _userService.getSelectedSoundId();
    _selectedSubuhSoundId = await _userService.getSubuhSoundId();
    _selectedRegulerSoundId = await _userService.getRegulerSoundId();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateUserName(String newName) async {
    if (newName.trim().isEmpty) return;
    _userName = newName.trim();
    notifyListeners();
    await _userService.setUserName(_userName);
  }

  Future<void> updateCalculationMethod(int methodId) async {
    _calculationMethod = methodId;
    notifyListeners();
    await _userService.setCalculationMethod(methodId);
  }

  Future<void> updateSelectedSoundId(String soundId) async {
    _selectedSoundId = soundId;
    notifyListeners();
    await _userService.setSelectedSoundId(soundId);
  }

  Future<void> updateSelectedSubuhSoundId(String soundId) async {
    _selectedSubuhSoundId = soundId;
    notifyListeners();
    await _userService.setSubuhSoundId(soundId);
  }

  Future<void> updateSelectedRegulerSoundId(String soundId) async {
    _selectedRegulerSoundId = soundId;
    notifyListeners();
    await _userService.setRegulerSoundId(soundId);
  }
}

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../models/azan_sound.dart';
import '../services/sound_service.dart';

class SoundProvider extends ChangeNotifier {
  final SoundService _soundService = SoundService();

  final List<AzanSound> _presetSounds = List.from(SoundService.defaultPresets);
  final List<AzanSound> _customSounds = [];
  String _selectedCategory = 'all'; // 'all', 'subuh', 'reguler'
  String? _downloadingId;
  String? _playingId;

  List<AzanSound> get allSounds => [..._presetSounds, ..._customSounds];
  List<AzanSound> get presetSounds => _presetSounds;
  List<AzanSound> get customSounds => _customSounds;
  String get selectedCategory => _selectedCategory;
  String? get downloadingId => _downloadingId;
  String? get playingId => _playingId;

  List<AzanSound> get subuhSounds =>
      allSounds.where((s) => s.category == 'subuh').toList();

  List<AzanSound> get regulerSounds =>
      allSounds.where((s) => s.category == 'reguler').toList();

  List<AzanSound> get filteredSounds {
    if (_selectedCategory == 'subuh') {
      return subuhSounds;
    } else if (_selectedCategory == 'reguler') {
      return regulerSounds;
    }
    return allSounds;
  }

  SoundProvider() {
    _initAudioListeners();
  }

  void setCategoryFilter(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void _initAudioListeners() {
    _soundService.audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.stopped || state == PlayerState.completed) {
        _playingId = null;
        notifyListeners();
      }
    });
  }

  Future<void> togglePlayPreview(AzanSound sound) async {
    if (_playingId == sound.id) {
      await _soundService.stopSound();
      _playingId = null;
    } else {
      await _soundService.playSound(sound);
      _playingId = sound.id;
    }
    notifyListeners();
  }

  Future<bool> downloadSound(AzanSound sound) async {
    _downloadingId = sound.id;
    notifyListeners();

    final downloadedSound = await _soundService.downloadPresetSound(sound);

    bool success = false;
    if (downloadedSound != null) {
      final index = _presetSounds.indexWhere((s) => s.id == sound.id);
      if (index != -1) {
        _presetSounds[index] = downloadedSound;
        success = true;
      }
    }

    _downloadingId = null;
    notifyListeners();
    return success;
  }

  Future<AzanSound?> uploadCustomUserSound({String category = 'reguler'}) async {
    final customSound = await _soundService.pickCustomUserAudio(category: category);
    if (customSound != null) {
      _customSounds.add(customSound);
      notifyListeners();
      return customSound;
    }
    return null;
  }

  @override
  void dispose() {
    _soundService.dispose();
    super.dispose();
  }
}

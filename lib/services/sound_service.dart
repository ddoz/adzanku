import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/azan_sound.dart';

class SoundService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlayingId;

  // Pre-bundled Azan Preset Audio Files matched with assets/sounds/
  static final List<AzanSound> defaultPresets = [
    AzanSound(
      id: 'adzan_fajr_mekah',
      title: 'Azan Subuh Makkah Al-Mukarramah',
      reciter: 'Muadzin Masjidil Haram',
      audioUrl: 'assets/sounds/adzan_fajr_mekah.mp3',
      isDownloaded: true,
      category: 'subuh',
      durationText: 'Khusus Subuh',
    ),
    AzanSound(
      id: 'adzan_fajr_madinah',
      title: 'Azan Subuh Madinah Al-Munawwarah',
      reciter: 'Muadzin Masjid Nabawi',
      audioUrl: 'assets/sounds/adzan_fajr_madinah.mp3',
      isDownloaded: true,
      category: 'subuh',
      durationText: 'Khusus Subuh',
    ),
    AzanSound(
      id: 'adzan_mekah',
      title: 'Azan Reguler Makkah Al-Mukarramah',
      reciter: 'Muadzin Masjidil Haram',
      audioUrl: 'assets/sounds/adzan_mekah.mp3',
      isDownloaded: true,
      category: 'reguler',
      durationText: 'Reguler (Dzuhur - Isya)',
    ),
    AzanSound(
      id: 'adzan_mesir',
      title: 'Azan Reguler Mesir',
      reciter: 'Muadzin Qari Mesir',
      audioUrl: 'assets/sounds/adzan_mesir.mp3',
      isDownloaded: true,
      category: 'reguler',
      durationText: 'Reguler (Dzuhur - Isya)',
    ),
  ];

  AudioPlayer get audioPlayer => _audioPlayer;
  String? get currentlyPlayingId => _currentlyPlayingId;

  Future<void> playSound(AzanSound sound) async {
    try {
      await stopSound();
      _currentlyPlayingId = sound.id;

      if (sound.isCustom && sound.localPath.isNotEmpty && File(sound.localPath).existsSync()) {
        await _audioPlayer.play(DeviceFileSource(sound.localPath));
        return;
      }

      // Play bundled asset audio directly from assets/sounds/
      try {
        final assetPath = sound.audioUrl.startsWith('assets/')
            ? sound.audioUrl.replaceFirst('assets/', '')
            : 'sounds/${sound.id}.mp3';
        await _audioPlayer.play(AssetSource(assetPath));
      } catch (_) {
        await _audioPlayer.play(AssetSource('sounds/adzan_mekah.mp3'));
      }
    } catch (_) {
      _currentlyPlayingId = null;
    }
  }

  Future<void> stopSound() async {
    await _audioPlayer.stop();
    _currentlyPlayingId = null;
  }

  Future<AzanSound?> downloadPresetSound(AzanSound sound) async {
    return sound.copyWith(isDownloaded: true);
  }

  Future<AzanSound?> pickCustomUserAudio({String category = 'reguler'}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'm4a', 'aac', 'ogg'],
      );

      if (result != null && result.files.single.path != null) {
        String originalPath = result.files.single.path!;
        String filename = result.files.single.name;

        final dir = await getApplicationDocumentsDirectory();
        final targetPath = '${dir.path}/custom_${DateTime.now().millisecondsSinceEpoch}_$filename';
        await File(originalPath).copy(targetPath);

        return AzanSound(
          id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
          title: filename.replaceAll(RegExp(r'\.[^.]+$'), ''),
          reciter: 'Custom Upload (User)',
          audioUrl: targetPath,
          localPath: targetPath,
          isDownloaded: true,
          isCustom: true,
          category: category,
          durationText: category == 'subuh' ? 'Khusus Subuh' : 'Reguler',
        );
      }
    } catch (_) {}
    return null;
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

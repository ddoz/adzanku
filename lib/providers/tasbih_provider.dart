import 'package:flutter/foundation.dart';

class TasbihItem {
  final String arabic;
  final String latin;
  final String translation;

  const TasbihItem({
    required this.arabic,
    required this.latin,
    required this.translation,
  });
}

class TasbihProvider extends ChangeNotifier {
  static const List<TasbihItem> zikrPresets = [
    TasbihItem(
      arabic: 'سُبْحَانَ ٱللَّٰهِ',
      latin: 'Subhanallah',
      translation: 'Maha Suci Allah',
    ),
    TasbihItem(
      arabic: 'ٱلْحَمْدُ لِلَّٰهِ',
      latin: 'Alhamdulillah',
      translation: 'Segala Puji Bagi Allah',
    ),
    TasbihItem(
      arabic: 'ٱللَّٰهُ أَكْبَرُ',
      latin: 'Allahu Akbar',
      translation: 'Allah Maha Besar',
    ),
    TasbihItem(
      arabic: 'أَسْتَغْفِرُ ٱللَّٰهَ',
      latin: 'Astaghfirullah',
      translation: 'Aku memohon ampun kepada Allah',
    ),
    TasbihItem(
      arabic: 'لَا إِلَٰهَ إِلَّا ٱللَّٰهُ',
      latin: 'Laa ilaaha illallah',
      translation: 'Tiada Tuhan Selain Allah',
    ),
  ];

  int _count = 0;
  int _target = 33;
  int _selectedZikrIndex = 0;
  int _totalLapCount = 0;

  int get count => _count;
  int get target => _target;
  int get selectedZikrIndex => _selectedZikrIndex;
  int get totalLapCount => _totalLapCount;

  TasbihItem get currentZikr => zikrPresets[_selectedZikrIndex];

  void increment() {
    _count++;
    if (_count >= _target) {
      _totalLapCount++;
      _count = 0;
    }
    notifyListeners();
  }

  void reset() {
    _count = 0;
    _totalLapCount = 0;
    notifyListeners();
  }

  void setTarget(int newTarget) {
    _target = newTarget;
    _count = 0;
    notifyListeners();
  }

  void selectZikr(int index) {
    if (index >= 0 && index < zikrPresets.length) {
      _selectedZikrIndex = index;
      _count = 0;
      notifyListeners();
    }
  }
}

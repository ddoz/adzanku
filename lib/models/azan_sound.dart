class AzanSound {
  final String id;
  final String title;
  final String reciter;
  final String audioUrl; // Remote URL, asset path, or local file path
  final String localPath; // Saved local file path once downloaded
  final bool isDownloaded;
  final bool isCustom; // Uploaded by user
  final String durationText;
  final String category; // 'subuh' or 'reguler'

  AzanSound({
    required this.id,
    required this.title,
    required this.reciter,
    required this.audioUrl,
    this.localPath = '',
    this.isDownloaded = false,
    this.isCustom = false,
    this.durationText = '03:15',
    this.category = 'reguler',
  });

  String get categoryDisplayName => category == 'subuh' ? 'Azan Subuh' : 'Azan Reguler';

  AzanSound copyWith({
    String? id,
    String? title,
    String? reciter,
    String? audioUrl,
    String? localPath,
    bool? isDownloaded,
    bool? isCustom,
    String? durationText,
    String? category,
  }) {
    return AzanSound(
      id: id ?? this.id,
      title: title ?? this.title,
      reciter: reciter ?? this.reciter,
      audioUrl: audioUrl ?? this.audioUrl,
      localPath: localPath ?? this.localPath,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      isCustom: isCustom ?? this.isCustom,
      durationText: durationText ?? this.durationText,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'reciter': reciter,
      'audioUrl': audioUrl,
      'localPath': localPath,
      'isDownloaded': isDownloaded,
      'isCustom': isCustom,
      'durationText': durationText,
      'category': category,
    };
  }

  factory AzanSound.fromJson(Map<String, dynamic> json) {
    return AzanSound(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      reciter: json['reciter'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      localPath: json['localPath'] ?? '',
      isDownloaded: json['isDownloaded'] ?? false,
      isCustom: json['isCustom'] ?? false,
      durationText: json['durationText'] ?? '03:00',
      category: json['category'] ?? 'reguler',
    );
  }
}

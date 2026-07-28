import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/sound_provider.dart';
import '../widgets/sound_item_card.dart';

class SoundCenterScreen extends StatelessWidget {
  const SoundCenterScreen({super.key});

  void _showUploadCategoryDialog(BuildContext context, SoundProvider soundProvider) {
    String selectedCategory = 'reguler';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            final theme = Theme.of(context);
            final primaryEmerald = theme.primaryColor;

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              backgroundColor: Colors.white,
              title: Row(
                children: [
                  Icon(Icons.cloud_upload_outlined, color: primaryEmerald),
                  const SizedBox(width: 10),
                  const Text(
                    'Pilih Kategori Azan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A241C),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih kategori untuk suara azan yang ingin Anda upload:',
                    style: TextStyle(fontSize: 13, color: Color(0xFF4A6B5D)),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => setState(() => selectedCategory = 'subuh'),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: selectedCategory == 'subuh'
                            ? primaryEmerald.withValues(alpha: 0.1)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selectedCategory == 'subuh' ? primaryEmerald : Colors.grey.shade300,
                          width: selectedCategory == 'subuh' ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            selectedCategory == 'subuh' ? Icons.radio_button_checked : Icons.radio_button_off,
                            color: selectedCategory == 'subuh' ? primaryEmerald : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('🌅 Azan Subuh', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                Text('Khusus sholat Subuh (ada As-salatu khayrum minan-nawm)', style: TextStyle(fontSize: 11, color: Color(0xFF4A6B5D))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => setState(() => selectedCategory = 'reguler'),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: selectedCategory == 'reguler'
                            ? primaryEmerald.withValues(alpha: 0.1)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selectedCategory == 'reguler' ? primaryEmerald : Colors.grey.shade300,
                          width: selectedCategory == 'reguler' ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            selectedCategory == 'reguler' ? Icons.radio_button_checked : Icons.radio_button_off,
                            color: selectedCategory == 'reguler' ? primaryEmerald : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('🕌 Azan Reguler', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                Text('Untuk Dzuhur, Ashar, Maghrib, & Isya', style: TextStyle(fontSize: 11, color: Color(0xFF4A6B5D))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.of(ctx).pop();
                    final uploaded = await soundProvider.uploadCustomUserSound(
                      category: selectedCategory,
                    );
                    if (uploaded != null && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Berhasil upload azan: ${uploaded.title} (${uploaded.categoryDisplayName})'),
                          backgroundColor: primaryEmerald,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.folder_open, size: 18, color: Colors.white),
                  label: const Text('Pilih File Audio', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryEmerald,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryEmerald = theme.primaryColor;
    final accentGold = const Color(0xFFB8860B);
    final userProvider = Provider.of<UserProvider>(context);
    final soundProvider = Provider.of<SoundProvider>(context);

    final subuhDefaultSound = soundProvider.allSounds.firstWhere(
      (s) => s.id == userProvider.selectedSubuhSoundId,
      orElse: () => soundProvider.presetSounds.firstWhere((s) => s.category == 'subuh'),
    );

    final regulerDefaultSound = soundProvider.allSounds.firstWhere(
      (s) => s.id == userProvider.selectedRegulerSoundId,
      orElse: () => soundProvider.presetSounds.firstWhere((s) => s.category == 'reguler'),
    );

    final filteredList = soundProvider.filteredSounds;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card with Defaults Summary
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: primaryEmerald.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: primaryEmerald.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.multitrack_audio, color: primaryEmerald, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Set Default Suara Azan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A241C),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Default Active Summary Badges
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: accentGold.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: accentGold.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '🌅 Default Subuh',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: accentGold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                subuhDefaultSound.title,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0A241C),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: primaryEmerald.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: primaryEmerald.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '🕌 Default Reguler',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: primaryEmerald,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                regulerDefaultSound.title,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0A241C),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Category Filter Segment Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip(
                      context: context,
                      label: 'Semua Suara',
                      categoryKey: 'all',
                      count: soundProvider.allSounds.length,
                      isSelected: soundProvider.selectedCategory == 'all',
                      onTap: () => soundProvider.setCategoryFilter('all'),
                    ),
                    const SizedBox(width: 8),
                    _buildCategoryChip(
                      context: context,
                      label: '🌅 Azan Subuh',
                      categoryKey: 'subuh',
                      count: soundProvider.subuhSounds.length,
                      isSelected: soundProvider.selectedCategory == 'subuh',
                      onTap: () => soundProvider.setCategoryFilter('subuh'),
                    ),
                    const SizedBox(width: 8),
                    _buildCategoryChip(
                      context: context,
                      label: '🕌 Azan Reguler',
                      categoryKey: 'reguler',
                      count: soundProvider.regulerSounds.length,
                      isSelected: soundProvider.selectedCategory == 'reguler',
                      onTap: () => soundProvider.setCategoryFilter('reguler'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Sound List View
            Expanded(
              child: filteredList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.music_off_outlined, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          const Text(
                            'Belum ada suara azan di kategori ini',
                            style: TextStyle(color: Color(0xFF4A6B5D)),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final sound = filteredList[index];
                        final isSelected = (sound.category == 'subuh' && userProvider.selectedSubuhSoundId == sound.id) ||
                            (sound.category == 'reguler' && userProvider.selectedRegulerSoundId == sound.id);

                        final isPlaying = soundProvider.playingId == sound.id;
                        final isDownloading = soundProvider.downloadingId == sound.id;

                        return SoundItemCard(
                          sound: sound,
                          isSelected: isSelected,
                          isPlaying: isPlaying,
                          isDownloading: isDownloading,
                          onSelect: () {
                            if (sound.category == 'subuh') {
                              userProvider.updateSelectedSubuhSoundId(sound.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Default Azan Subuh diset ke: ${sound.title}'),
                                  backgroundColor: accentGold,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            } else {
                              userProvider.updateSelectedRegulerSoundId(sound.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Default Azan Reguler diset ke: ${sound.title}'),
                                  backgroundColor: primaryEmerald,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          onPlayToggle: () {
                            soundProvider.togglePlayPreview(sound);
                          },
                          onDownload: () {
                            soundProvider.downloadSound(sound);
                          },
                        );
                      },
                    ),
            ),

            // Upload Custom Audio Floating Bar
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _showUploadCategoryDialog(context, soundProvider),
                  icon: const Icon(Icons.upload_file, color: Colors.white, size: 22),
                  label: const Text(
                    'Upload Suara Azan Sendiri',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryEmerald,
                    elevation: 4,
                    shadowColor: primaryEmerald.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required BuildContext context,
    required String label,
    required String categoryKey,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;

    return ChoiceChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: primary,
      backgroundColor: Colors.white.withValues(alpha: 0.8),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF0A241C),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? primary : Colors.white,
          width: 1.5,
        ),
      ),
    );
  }
}

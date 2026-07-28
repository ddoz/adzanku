import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WisdomQuote {
  final String arabic;
  final String translation;
  final String reference;

  const WisdomQuote({
    required this.arabic,
    required this.translation,
    required this.reference,
  });
}

class DailyWisdomCard extends StatefulWidget {
  const DailyWisdomCard({super.key});

  static const List<WisdomQuote> quotes = [
    WisdomQuote(
      arabic: 'إِنَّ ٱلصَّلَوٰةَ كَانَتْ عَلَى ٱلْمُؤْمِنِينَ كِتَٰبً۠ا مَّوْقُوتً۠ا',
      translation: 'Sesungguhnya sholat itu adalah kewajiban yang ditentukan waktunya atas orang-orang yang beriman.',
      reference: 'QS. An-Nisa: 103',
    ),
    WisdomQuote(
      arabic: 'وَأَقِيمُوا۟ ٱلصَّلَوٰةَ وَءَاتُوا۟ ٱلزَّكَوٰةَ وَٱرْكَعُوا۟ مَعَ ٱلرَّٰكِعِينَ',
      translation: 'Dan laksanakanlah sholat, tunaikanlah zakat, dan rukuklah beserta orang-orang yang rukuk.',
      reference: 'QS. Al-Baqarah: 43',
    ),
    WisdomQuote(
      arabic: 'أَلَا بِذِكْرِ ٱللَّهِ تَطْمَئِنُّ ٱلْقُلُوبُ',
      translation: 'Ingatlah, hanya dengan mengingat Allah hati menjadi tenteram.',
      reference: 'QS. Ar-Ra\'d: 28',
    ),
    WisdomQuote(
      arabic: 'خَيْرُ النَّاسِ أَنْفَعُهُمْ لِلنَّاسِ',
      translation: 'Sebaik-baik manusia adalah yang paling bermanfaat bagi manusia lainnya.',
      reference: 'HR. Thabrani',
    ),
  ];

  @override
  State<DailyWisdomCard> createState() => _DailyWisdomCardState();
}

class _DailyWisdomCardState extends State<DailyWisdomCard> {
  int _currentIndex = 0;

  void _nextQuote() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % DailyWisdomCard.quotes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;
    final accentGold = const Color(0xFFB8860B);
    final current = DailyWisdomCard.quotes[_currentIndex];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.format_quote, color: accentGold, size: 22),
                  const SizedBox(width: 6),
                  const Text(
                    'Mutiara Islam Hari Ini',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF0A241C),
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: _nextQuote,
                icon: Icon(Icons.refresh, color: primary, size: 18),
                tooltip: 'Ganti Ayat/Hadits',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            current.arabic,
            style: GoogleFonts.amiri(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: primary,
              height: 1.6,
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 10),
          Text(
            '"${current.translation}"',
            style: const TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: Color(0xFF4A6B5D),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                current.reference,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

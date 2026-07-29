import 'package:flutter/material.dart';

class LocationBar extends StatelessWidget {
  final String cityName;
  final String countryName;
  final String hijriDate;
  final VoidCallback onRefresh;
  final bool isLoading;

  const LocationBar({
    super.key,
    required this.cityName,
    required this.countryName,
    required this.hijriDate,
    required this.onRefresh,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryEmerald = theme.primaryColor;

    final locationText = countryName.isNotEmpty ? '$cityName, $countryName' : cityName;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: primaryEmerald.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, color: primaryEmerald, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  locationText,
                  style: const TextStyle(
                    color: Color(0xFF0A241C),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  hijriDate,
                  style: const TextStyle(
                    color: Color(0xFF4A6B5D),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            onPressed: isLoading ? null : onRefresh,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: isLoading
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(primaryEmerald),
                    ),
                  )
                : Icon(Icons.my_location, color: primaryEmerald, size: 20),
            tooltip: 'Perbarui Lokasi GPS',
          ),
        ],
      ),
    );
  }
}

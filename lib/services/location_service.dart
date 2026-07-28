import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class UserLocation {
  final double latitude;
  final double longitude;
  final String cityName;
  final String countryName;

  UserLocation({
    required this.latitude,
    required this.longitude,
    required this.cityName,
    required this.countryName,
  });
}

class LocationService {
  Future<UserLocation> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return _fallbackLocation('Jakarta', 'Indonesia');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return _fallbackLocation('Jakarta', 'Indonesia');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return _fallbackLocation('Jakarta', 'Indonesia');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );

      String city = 'Lokasi Terdeteksi';
      String country = 'Indonesia';

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          city = place.locality ?? place.subAdministrativeArea ?? place.administrativeArea ?? 'Lokasi Terdeteksi';
          country = place.country ?? 'Indonesia';
        }
      } catch (_) {
        // Fallback placemark lookup
      }

      return UserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        cityName: city,
        countryName: country,
      );
    } catch (_) {
      return _fallbackLocation('Jakarta', 'Indonesia');
    }
  }

  UserLocation _fallbackLocation(String city, String country) {
    return UserLocation(
      latitude: -6.2088,
      longitude: 106.8456,
      cityName: city,
      countryName: country,
    );
  }
}

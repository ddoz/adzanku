import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/user_provider.dart';
import 'providers/prayer_provider.dart';
import 'providers/sound_provider.dart';
import 'providers/tasbih_provider.dart';
import 'services/notification_service.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification service and permissions
  final notificationService = NotificationService();
  await notificationService.initNotification();
  await notificationService.requestPermissions();

  runApp(const AdzankuApp());
}

class AdzankuApp extends StatelessWidget {
  const AdzankuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PrayerProvider()),
        ChangeNotifierProvider(create: (_) => SoundProvider()),
        ChangeNotifierProvider(create: (_) => TasbihProvider()),
      ],
      child: MaterialApp(
        title: 'Adzanku',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light, // Light Glassmorphism mode
        home: const SplashScreen(),
      ),
    );
  }
}

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Dapatkan daftar kamera yang tersedia
  final cameras = await availableCameras();
  
  runApp(AeraApp(cameras: cameras));
}

class AeraApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  
  const AeraApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AERA - AI Weather Recognition',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C5CE7),
          brightness: Brightness.dark,
        ),
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: Colors.transparent,
        cardTheme: const CardThemeData(
          elevation: 0,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      home: SplashScreen(cameras: cameras),
      debugShowCheckedModeBanner: false,
    );
  }
} 
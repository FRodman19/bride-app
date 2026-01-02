import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'screens/design_system_home.dart';
import 'screens/grow_out_loud_gallery_screen.dart';
import 'grow_out_loud/foundation/gol_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grow Out Loud Design System',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const DesignSystemHome(),
        if (kDebugMode)
          '/gallery': (context) => const GrowOutLoudGalleryScreen(),
      },
      theme: GOLThemeData.light(),
      darkTheme: GOLThemeData.dark(),
      themeMode: ThemeMode.system,
    );
  }
}

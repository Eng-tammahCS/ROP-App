import 'package:flutter/material.dart';

import '../screens/bedroom_screen.dart';

class IglooApp extends StatelessWidget {
  const IglooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Igloo',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF13101A),
        useMaterial3: true,
        fontFamily: 'sans-serif',
      ),
      home: const BedroomScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'navigation/bottom_nav_bar.dart';
import 'navigation/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Tabs Navigator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Tema Indonesia dengan warna merah dan putih
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          primary: Colors.red,
          secondary: Colors.white,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          elevation: 2,
          centerTitle: true,
        ),
      ),
      // Initial route
      initialRoute: AppRouter.home,
      // Route generator
      onGenerateRoute: AppRouter.generateRoute,
      // Home widget
      home: const BottomNavBar(),
    );
  }
}

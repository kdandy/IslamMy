import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';
import '../screens/qibla/qibla_screen.dart';
import '../screens/tasbih/tasbih_screen.dart';

/// App Router untuk mengelola navigation routes
class AppRouter {
  // Route names
  static const String home = '/';
  static const String qibla = '/qibla';
  static const String tasbih = '/tasbih';

  /// Generate routes untuk aplikasi
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const BottomNavBar());
      
      case qibla:
        return MaterialPageRoute(builder: (_) => const QiblaScreen());
      case tasbih:
        return MaterialPageRoute(builder: (_) => const TasbihScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Halaman tidak ditemukan: ${settings.name}'),
            ),
          ),
        );
    }
  }

  /// Navigate to specific route
  static void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  /// Navigate and replace current route
  static void navigateAndReplace(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  /// Go back to previous screen
  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}

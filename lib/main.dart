import 'package:app_practice/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'config/app_router.dart';

void main() {
   //  NECESARIO para SharedPreferences en web
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Mis tareas',
      theme: AppTheme(selectedColor: 0).getTheme(),
      routerConfig: appRouter,
    );
  }
}

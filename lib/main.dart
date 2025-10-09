
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/features/basic_calculator/screen/basic_calculator_screen.dart';
import 'package:project/shared/providers/thame_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

ThemeMode _getThemeMode(AppTheme appTheme, BuildContext context) {
  switch (appTheme) {
    case AppTheme.light:
      return ThemeMode.light;
    case AppTheme.dark:
      return ThemeMode.dark;
    case AppTheme.system:
      final brightness = MediaQuery.platformBrightnessOf(context);
      return brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Smart Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: _getThemeMode(themeState.themeMode, context),
      home: const BasicCalculatorScreen(),
    );
  }
}
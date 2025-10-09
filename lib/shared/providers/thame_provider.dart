
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppTheme { light, dark, system }

class ThemeState {
  final AppTheme themeMode;

  ThemeState({this.themeMode = AppTheme.system});
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeState> {
  static const String _themeKey = 'app_theme';

  ThemeNotifier() : super(ThemeState()) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 2; // 2 = system
    final theme = AppTheme.values[themeIndex];
    state = ThemeState(themeMode: theme);
  }

  Future<void> setTheme(AppTheme theme) async {
    state = ThemeState(themeMode: theme);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, theme.index);
  }
}
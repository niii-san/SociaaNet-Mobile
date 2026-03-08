import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark, system }

class ThemeState {
  final AppThemeMode mode;

  const ThemeState({this.mode = AppThemeMode.system});

  ThemeState copyWith({AppThemeMode? mode}) {
    return ThemeState(mode: mode ?? this.mode);
  }
}

class ThemeNotifier extends Notifier<ThemeState> {
  static const _themeKey = 'app_theme_mode';

  @override
  ThemeState build() {
    _loadTheme();
    return const ThemeState();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 2; // default system
    state = ThemeState(mode: AppThemeMode.values[themeIndex]);
  }

  Future<void> setTheme(AppThemeMode mode) async {
    state = state.copyWith(mode: mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
  }

  void toggleTheme() {
    final next = state.mode == AppThemeMode.light
        ? AppThemeMode.dark
        : AppThemeMode.light;
    setTheme(next);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(
  ThemeNotifier.new,
);

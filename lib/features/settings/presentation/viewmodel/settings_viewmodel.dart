import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/core/models/settings_model.dart';
import 'package:sociaanet/features/settings/data/repositories/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

final settingsViewModelProvider =
    NotifierProvider<SettingsViewModel, SettingsState>(
  SettingsViewModel.new,
);

class SettingsState {
  final UserSettings? settings;
  final bool isLoading;
  final String? error;

  const SettingsState({
    this.settings,
    this.isLoading = false,
    this.error,
  });

  SettingsState copyWith({
    UserSettings? settings,
    bool? isLoading,
    String? error,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class SettingsViewModel extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    return const SettingsState();
  }

  SettingsRepository get _repository =>
      ref.read(settingsRepositoryProvider);

  Future<void> loadSettings() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _repository.getSettings();
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (settings) => state = state.copyWith(isLoading: false, settings: settings),
    );
  }

  Future<bool> updatePrivacy(Map<String, dynamic> settings) async {
    final result = await _repository.updatePrivacy(settings);
    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return false;
      },
      (_) {
        loadSettings();
        return true;
      },
    );
  }

  Future<bool> updateNotifications(Map<String, dynamic> settings) async {
    final result = await _repository.updateNotifications(settings);
    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return false;
      },
      (_) {
        loadSettings();
        return true;
      },
    );
  }

  Future<bool> updateAppearance(Map<String, dynamic> settings) async {
    final result = await _repository.updateAppearance(settings);
    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return false;
      },
      (_) {
        loadSettings();
        return true;
      },
    );
  }

  Future<bool> updateFeed(Map<String, dynamic> settings) async {
    final result = await _repository.updateFeed(settings);
    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return false;
      },
      (_) {
        loadSettings();
        return true;
      },
    );
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final result = await _repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return false;
      },
      (_) => true,
    );
  }
}

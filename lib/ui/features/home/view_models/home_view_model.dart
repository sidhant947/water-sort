import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:watersort/data/repositories/progress_repository.dart';
import 'package:watersort/domain/models/user_progress.dart';
import 'package:watersort/domain/models/user_profile.dart';

class HomeViewModelState {
  const HomeViewModelState({
    this.progress,
    this.activeProfile,
    this.profiles = const [],
    this.isLoading = false,
    this.isTimerEnabled = true,
  });

  final UserProgress? progress;
  final UserProfile? activeProfile;
  final List<UserProfile> profiles;
  final bool isLoading;
  final bool isTimerEnabled;

  HomeViewModelState copyWith({
    UserProgress? progress,
    UserProfile? Function()? activeProfile,
    List<UserProfile>? profiles,
    bool? isLoading,
    bool? isTimerEnabled,
  }) {
    return HomeViewModelState(
      progress: progress ?? this.progress,
      activeProfile: activeProfile != null ? activeProfile() : this.activeProfile,
      profiles: profiles ?? this.profiles,
      isLoading: isLoading ?? this.isLoading,
      isTimerEnabled: isTimerEnabled ?? this.isTimerEnabled,
    );
  }
}

class HomeViewModel extends StateNotifier<HomeViewModelState> {
  HomeViewModel({required this._progressRepository})
      : super(const HomeViewModelState());

  final ProgressRepository _progressRepository;

  Future<void> loadProgress() async {
    state = state.copyWith(isLoading: true);
    try {
      final progress = await _progressRepository.getProgress();
      final activeProfile = await _progressRepository.getActiveProfile();
      final profiles = await _progressRepository.getProfiles();
      final isTimerEnabled = _progressRepository.isTimerEnabled();
      state = state.copyWith(
        progress: progress,
        activeProfile: () => activeProfile,
        profiles: profiles,
        isTimerEnabled: isTimerEnabled,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> toggleTimer() async {
    final newValue = !state.isTimerEnabled;
    await _progressRepository.setTimerEnabled(newValue);
    state = state.copyWith(isTimerEnabled: newValue);
  }

  Future<void> resetProgress() async {
    await _progressRepository.resetProgress();
    await loadProgress();
  }

  Future<void> createProfile(String name, String emoji) async {
    state = state.copyWith(isLoading: true);
    await _progressRepository.createProfile(name, emoji);
    await loadProgress();
  }

  Future<void> switchProfile(String profileId) async {
    state = state.copyWith(isLoading: true);
    await _progressRepository.switchProfile(profileId);
    await loadProgress();
  }

  Future<void> deleteProfile(String profileId) async {
    state = state.copyWith(isLoading: true);
    await _progressRepository.deleteProfile(profileId);
    await loadProgress();
  }

  Future<void> updateProfile(UserProfile profile) async {
    state = state.copyWith(isLoading: true);
    await _progressRepository.updateProfile(profile);
    await loadProgress();
  }
}

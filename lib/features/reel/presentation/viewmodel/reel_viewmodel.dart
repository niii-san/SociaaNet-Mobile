import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/core/models/reel_model.dart';
import 'package:sociaanet/features/reel/data/repositories/reel_repository.dart';

final reelRepositoryProvider = Provider<ReelRepository>((ref) {
  return ReelRepository();
});

final reelViewModelProvider =
    NotifierProvider<ReelViewModel, ReelState>(
  ReelViewModel.new,
);

class ReelState {
  final List<Reel> reels;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;
  final int currentIndex;
  final String? error;

  const ReelState({
    this.reels = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.currentIndex = 0,
    this.error,
  });

  ReelState copyWith({
    List<Reel>? reels,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
    int? currentIndex,
    String? error,
  }) {
    return ReelState(
      reels: reels ?? this.reels,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      currentIndex: currentIndex ?? this.currentIndex,
      error: error,
    );
  }
}

class ReelViewModel extends Notifier<ReelState> {
  @override
  ReelState build() {
    return const ReelState();
  }

  ReelRepository get _repository => ref.read(reelRepositoryProvider);

  Future<void> loadReels({bool refresh = false}) async {
    if (state.isLoading) return;

    final page = refresh ? 1 : state.currentPage;
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.getReelsFeed(page: page);
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (data) {
        final newReels = data['reels'] as List<Reel>;
        final pagination = data['pagination'] as Map<String, dynamic>?;
        final totalPages = pagination?['totalPages'] ?? 1;

        state = state.copyWith(
          reels: refresh ? newReels : [...state.reels, ...newReels],
          isLoading: false,
          hasMore: page < totalPages,
          currentPage: page + 1,
        );
      },
    );
  }

  void setCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
    // Record view for the current reel
    if (index < state.reels.length) {
      _repository.recordView(state.reels[index].id);
    }
    // Load more if near the end
    if (index >= state.reels.length - 3 && state.hasMore && !state.isLoading) {
      loadReels();
    }
  }

  Future<void> likeReel(String reelId) async {
    // Optimistic update
    state = state.copyWith(
      reels: state.reels.map((r) {
        if (r.id == reelId) {
          return r.copyWith(isLiked: true, likesCount: r.likesCount + 1);
        }
        return r;
      }).toList(),
    );
    final result = await _repository.likeReel(reelId);
    result.fold(
      (_) {
        // Revert on failure
        state = state.copyWith(
          reels: state.reels.map((r) {
            if (r.id == reelId) {
              return r.copyWith(isLiked: false, likesCount: r.likesCount - 1);
            }
            return r;
          }).toList(),
        );
      },
      (_) {},
    );
  }

  Future<void> unlikeReel(String reelId) async {
    state = state.copyWith(
      reels: state.reels.map((r) {
        if (r.id == reelId) {
          return r.copyWith(isLiked: false, likesCount: (r.likesCount - 1).clamp(0, r.likesCount));
        }
        return r;
      }).toList(),
    );
    final result = await _repository.unlikeReel(reelId);
    result.fold(
      (_) {
        state = state.copyWith(
          reels: state.reels.map((r) {
            if (r.id == reelId) {
              return r.copyWith(isLiked: true, likesCount: r.likesCount + 1);
            }
            return r;
          }).toList(),
        );
      },
      (_) {},
    );
  }

  Future<void> saveReel(String reelId) async {
    state = state.copyWith(
      reels: state.reels.map((r) {
        if (r.id == reelId) return r.copyWith(isSaved: true);
        return r;
      }).toList(),
    );
    await _repository.saveReel(reelId);
  }

  Future<void> unsaveReel(String reelId) async {
    state = state.copyWith(
      reels: state.reels.map((r) {
        if (r.id == reelId) return r.copyWith(isSaved: false);
        return r;
      }).toList(),
    );
    await _repository.unsaveReel(reelId);
  }
}

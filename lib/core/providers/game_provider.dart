import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merge_odyssey/core/models/player_progress.dart';
import 'package:merge_odyssey/core/models/world.dart';
import 'package:merge_odyssey/core/models/challenge.dart';
import 'package:merge_odyssey/core/services/firebase_service.dart';

final gameProvider = StateNotifierProvider<GameController, GameState>((ref) {
  return GameController();
});

class GameState {
  final PlayerProgress playerProgress;
  final List<World> availableWorlds;
  final List<Challenge> featuredChallenges;
  final bool isLoading;

  const GameState({
    required this.playerProgress,
    required this.availableWorlds,
    required this.featuredChallenges,
    this.isLoading = false,
  });

  GameState copyWith({
    PlayerProgress? playerProgress,
    List<World>? availableWorlds,
    List<Challenge>? featuredChallenges,
    bool? isLoading,
  }) {
    return GameState(
      playerProgress: playerProgress ?? this.playerProgress,
      availableWorlds: availableWorlds ?? this.availableWorlds,
      featuredChallenges: featuredChallenges ?? this.featuredChallenges,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class GameController extends StateNotifier<GameState> {
  GameController()
      : super(GameState(
          playerProgress: PlayerProgress(playerId: 'default_player'),
          availableWorlds: [],
          featuredChallenges: [],
          isLoading: true,
        ));

  Future<void> initializeGame(String playerId) async {
    state = state.copyWith(isLoading: true);

    try {
      // Load player progress
      final progress =
          await FirebaseService.instance().getPlayerProgress(playerId);
      final playerProgress = progress ?? PlayerProgress(playerId: playerId);

      // Load available worlds (this would come from Firebase or local data)
      final worlds = await _loadAvailableWorlds();

      // Load featured challenges
      final challenges =
          await FirebaseService.instance().getOfficialChallenges();

      state = state.copyWith(
        playerProgress: playerProgress,
        availableWorlds: worlds,
        featuredChallenges: challenges.take(5).toList(),
        isLoading: false,
      );
    } catch (e) {
      print('Error initializing game: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  Future<List<World>> _loadAvailableWorlds() async {
    // In a real implementation, this would fetch from Firebase or local JSON
    return [
      World(
        id: 'forest_world',
        name: 'Forest Realm',
        description: 'Begin your journey in the peaceful forest',
        biomeType: 'forest',
        backgroundImage: 'assets/images/forest_bg.png',
        minLevelRequired: 1,
        themeColor: Colors.green,
      ),
      World(
        id: 'ice_world',
        name: 'Ice Kingdom',
        description: 'Chill adventures in the frozen lands',
        biomeType: 'ice',
        backgroundImage: 'assets/images/ice_bg.png',
        minLevelRequired: 5,
        unlockRequirements: ['dragon_scale'],
        themeColor: Colors.blue,
      ),
    ];
  }

  void updatePlayerProgress(PlayerProgress newProgress) {
    state = state.copyWith(playerProgress: newProgress);

    // Save to Firebase
    FirebaseService.instance().savePlayerProgress(newProgress);
  }

  void addCoins(int amount) {
    final newProgress = state.playerProgress.copyWith(
      coins: state.playerProgress.coins + amount,
    );
    updatePlayerProgress(newProgress);
  }

  void addGems(int amount) {
    final newProgress = state.playerProgress.copyWith(
      gems: state.playerProgress.gems + amount,
    );
    updatePlayerProgress(newProgress);
  }

  void incrementLevel() {
    final newProgress = state.playerProgress.copyWith(
      level: state.playerProgress.level + 1,
    );
    updatePlayerProgress(newProgress);
  }

  void completeChallenge(Challenge challenge) {
    // This would be called after successfully completing a challenge
    final newProgress = state.playerProgress.completeChallenge(
      challenge.id,
      100, // reward coins
      10, // reward gems
    );
    updatePlayerProgress(newProgress);
  }
}

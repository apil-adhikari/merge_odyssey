import 'package:merge_odyssey/core/models/world.dart';

class PlayerProgress {
  final String playerId;
  final int level;
  final int totalMerges;
  final int coins;
  final int gems;
  final DateTime createdAt;
  final DateTime lastLogin;
  final List<String> unlockedItems;
  final List<String> completedWorlds;
  final Map<String, int> itemCounts; // Item ID -> count
  final int totalScore;
  final int maxCombo;
  final int longestStreak;
  final int currentStreak;
  final DateTime? lastRewardClaimed;
  final int dailyRewardDay;
  final String? currentChallengeId;
  final int challengeProgress;
  final List<String> favoriteChallenges;

  PlayerProgress({
    required this.playerId,
    this.level = 1,
    this.totalMerges = 0,
    this.coins = 100,
    this.gems = 10,
    DateTime? createdAt,
    DateTime? lastLogin,
    this.unlockedItems = const [],
    this.completedWorlds = const [],
    this.itemCounts = const {},
    this.totalScore = 0,
    this.maxCombo = 0,
    this.longestStreak = 0,
    this.currentStreak = 0,
    this.lastRewardClaimed,
    this.dailyRewardDay = 0,
    this.currentChallengeId,
    this.challengeProgress = 0,
    this.favoriteChallenges = const [],
  })  : createdAt = createdAt ?? DateTime.now(),
        lastLogin = lastLogin ?? DateTime.now();

  factory PlayerProgress.fromJson(Map<String, dynamic> json) {
    return PlayerProgress(
      playerId: json['playerId'],
      level: json['level'] ?? 1,
      totalMerges: json['totalMerges'] ?? 0,
      coins: json['coins'] ?? 100,
      gems: json['gems'] ?? 10,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      lastLogin: DateTime.fromMillisecondsSinceEpoch(json['lastLogin']),
      unlockedItems: List<String>.from(json['unlockedItems'] ?? []),
      completedWorlds: List<String>.from(json['completedWorlds'] ?? []),
      itemCounts: Map<String, int>.from(json['itemCounts'] ?? {}),
      totalScore: json['totalScore'] ?? 0,
      maxCombo: json['maxCombo'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
      lastRewardClaimed: json['lastRewardClaimed'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastRewardClaimed'])
          : null,
      dailyRewardDay: json['dailyRewardDay'] ?? 0,
      currentChallengeId: json['currentChallengeId'],
      challengeProgress: json['challengeProgress'] ?? 0,
      favoriteChallenges: List<String>.from(json['favoriteChallenges'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'level': level,
      'totalMerges': totalMerges,
      'coins': coins,
      'gems': gems,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastLogin': lastLogin.millisecondsSinceEpoch,
      'unlockedItems': unlockedItems,
      'completedWorlds': completedWorlds,
      'itemCounts': itemCounts,
      'totalScore': totalScore,
      'maxCombo': maxCombo,
      'longestStreak': longestStreak,
      'currentStreak': currentStreak,
      'lastRewardClaimed': lastRewardClaimed?.millisecondsSinceEpoch,
      'dailyRewardDay': dailyRewardDay,
      'currentChallengeId': currentChallengeId,
      'challengeProgress': challengeProgress,
      'favoriteChallenges': favoriteChallenges,
    };
  }

  PlayerProgress copyWith({
    String? playerId,
    int? level,
    int? totalMerges,
    int? coins,
    int? gems,
    DateTime? createdAt,
    DateTime? lastLogin,
    List<String>? unlockedItems,
    List<String>? completedWorlds,
    Map<String, int>? itemCounts,
    int? totalScore,
    int? maxCombo,
    int? longestStreak,
    int? currentStreak,
    DateTime? lastRewardClaimed,
    int? dailyRewardDay,
    String? currentChallengeId,
    int? challengeProgress,
    List<String>? favoriteChallenges,
  }) {
    return PlayerProgress(
      playerId: playerId ?? this.playerId,
      level: level ?? this.level,
      totalMerges: totalMerges ?? this.totalMerges,
      coins: coins ?? this.coins,
      gems: gems ?? this.gems,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      unlockedItems: unlockedItems ?? this.unlockedItems,
      completedWorlds: completedWorlds ?? this.completedWorlds,
      itemCounts: itemCounts ?? this.itemCounts,
      totalScore: totalScore ?? this.totalScore,
      maxCombo: maxCombo ?? this.maxCombo,
      longestStreak: longestStreak ?? this.longestStreak,
      currentStreak: currentStreak ?? this.currentStreak,
      lastRewardClaimed: lastRewardClaimed ?? this.lastRewardClaimed,
      dailyRewardDay: dailyRewardDay ?? this.dailyRewardDay,
      currentChallengeId: currentChallengeId ?? this.currentChallengeId,
      challengeProgress: challengeProgress ?? this.challengeProgress,
      favoriteChallenges: favoriteChallenges ?? this.favoriteChallenges,
    );
  }

  // Update progress after a merge
  PlayerProgress incrementMerge() {
    final newLevel = _calculateNewLevel(totalMerges + 1);
    return copyWith(
      totalMerges: totalMerges + 1,
      level: newLevel,
      totalScore: totalScore + 10, // Base score for merge
    );
  }

  // Update progress after completing a challenge
  PlayerProgress completeChallenge(
      String challengeId, int rewardCoins, int rewardGems) {
    final newCompletedChallenges = List<String>.from(completedWorlds);
    if (!newCompletedChallenges.contains(challengeId)) {
      newCompletedChallenges.add(challengeId);
    }

    return copyWith(
      completedWorlds: newCompletedChallenges,
      coins: coins + rewardCoins,
      gems: gems + rewardGems,
      currentChallengeId: null,
      challengeProgress: 0,
    );
  }

  // Claim daily reward
  PlayerProgress claimDailyReward() {
    final day = dailyRewardDay + 1;
    final reward = _getDailyReward(day);

    return copyWith(
      coins: coins + reward.coins,
      gems: gems + reward.gems,
      lastRewardClaimed: DateTime.now(),
      dailyRewardDay: day,
      currentStreak: currentStreak + 1,
      longestStreak:
          currentStreak + 1 > longestStreak ? currentStreak + 1 : longestStreak,
    );
  }

  // Calculate new level based on total merges
  int _calculateNewLevel(int totalMerges) {
    return (totalMerges ~/ 10) + 1; // Level up every 10 merges
  }

  // Get daily reward amount based on streak
  (int coins, int gems) _getDailyReward(int day) {
    final weeklyCycle = (day - 1) % 7;
    final baseReward = 50 + (day * 10); // Increasing base reward

    switch (weeklyCycle) {
      case 0:
        return (baseReward, 5); // Monday
      case 1:
        return (baseReward + 10, 5);
      case 2:
        return (baseReward + 20, 5);
      case 3:
        return (baseReward + 30, 10); // Mid-week bonus
      case 4:
        return (baseReward + 40, 10);
      case 5:
        return (baseReward + 50, 10);
      case 6:
        return (baseReward + 100, 15); // Weekend bonus
      default:
        return (baseReward, 5);
    }
  }

  // Check if daily reward is available
  bool get isDailyRewardAvailable {
    if (lastRewardClaimed == null) return true;

    final now = DateTime.now();
    final last = lastRewardClaimed!;

    // Check if it's been at least 24 hours since last claim
    return now.difference(last).inHours >= 24;
  }
}

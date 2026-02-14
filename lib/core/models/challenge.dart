import 'package:merge_odyssey/core/models/grid.dart';
import 'package:merge_odyssey/core/models/item.dart';
import 'package:merge_odyssey/core/models/world.dart';

class Challenge {
  final String id;
  final String title;
  final String description;
  final ChallengeType type;
  final int targetScore;
  final int timeLimitSeconds;
  final int moveLimit;
  final Grid startingGrid;
  final List<String> requiredItems;
  final List<Reward> rewards;
  final Difficulty difficulty;
  final String authorId;
  final DateTime createdAt;
  final int likes;
  final int plays;
  final double rating;
  final bool isOfficial;
  final List<String> tags; // For categorization
  final String? worldId; // Which world this challenge belongs to

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.targetScore = 1000,
    this.timeLimitSeconds = 300, // 5 minutes
    this.moveLimit = 0, // 0 means unlimited
    required this.startingGrid,
    this.requiredItems = const [],
    this.rewards = const [],
    this.difficulty = Difficulty.medium,
    required this.authorId,
    DateTime? createdAt,
    this.likes = 0,
    this.plays = 0,
    this.rating = 0.0,
    this.isOfficial = false,
    this.tags = const [],
    this.worldId,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: ChallengeType.values.firstWhere(
        (t) => t.toString().split('.').last == json['type'],
        orElse: () => ChallengeType.score,
      ),
      targetScore: json['targetScore'] ?? 1000,
      timeLimitSeconds: json['timeLimitSeconds'] ?? 300,
      moveLimit: json['moveLimit'] ?? 0,
      startingGrid: Grid.fromJson(json['startingGrid']),
      requiredItems: List<String>.from(json['requiredItems'] ?? []),
      rewards: (json['rewards'] as List<dynamic>?)
              ?.map((rewardJson) => Reward.fromJson(rewardJson))
              .toList() ??
          [],
      difficulty: Difficulty.values.firstWhere(
        (d) => d.toString().split('.').last == json['difficulty'],
        orElse: () => Difficulty.medium,
      ),
      authorId: json['authorId'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      likes: json['likes'] ?? 0,
      plays: json['plays'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      isOfficial: json['isOfficial'] ?? false,
      tags: List<String>.from(json['tags'] ?? []),
      worldId: json['worldId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'targetScore': targetScore,
      'timeLimitSeconds': timeLimitSeconds,
      'moveLimit': moveLimit,
      'startingGrid': startingGrid.toJson(),
      'requiredItems': requiredItems,
      'rewards': rewards.map((reward) => reward.toJson()).toList(),
      'difficulty': difficulty.toString().split('.').last,
      'authorId': authorId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'likes': likes,
      'plays': plays,
      'rating': rating,
      'isOfficial': isOfficial,
      'tags': tags,
      'worldId': worldId,
    };
  }

  Challenge copyWith({
    String? id,
    String? title,
    String? description,
    ChallengeType? type,
    int? targetScore,
    int? timeLimitSeconds,
    int? moveLimit,
    Grid? startingGrid,
    List<String>? requiredItems,
    List<Reward>? rewards,
    Difficulty? difficulty,
    String? authorId,
    DateTime? createdAt,
    int? likes,
    int? plays,
    double? rating,
    bool? isOfficial,
    List<String>? tags,
    String? worldId,
  }) {
    return Challenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      targetScore: targetScore ?? this.targetScore,
      timeLimitSeconds: timeLimitSeconds ?? this.timeLimitSeconds,
      moveLimit: moveLimit ?? this.moveLimit,
      startingGrid: startingGrid ?? this.startingGrid,
      requiredItems: requiredItems ?? this.requiredItems,
      rewards: rewards ?? this.rewards,
      difficulty: difficulty ?? this.difficulty,
      authorId: authorId ?? this.authorId,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      plays: plays ?? this.plays,
      rating: rating ?? this.rating,
      isOfficial: isOfficial ?? this.isOfficial,
      tags: tags ?? this.tags,
      worldId: worldId ?? this.worldId,
    );
  }

  bool isScoreTargetReached(int currentScore) {
    return currentScore >= targetScore;
  }

  bool isTimeUp(DateTime startTime) {
    return DateTime.now().difference(startTime).inSeconds >= timeLimitSeconds;
  }

  bool hasMovesLeft(int usedMoves) {
    if (moveLimit <= 0) return true; // Unlimited moves
    return usedMoves < moveLimit;
  }

  ChallengeResult evaluateResult(
      int finalScore, DateTime startTime, int movesUsed) {
    final timeTaken = DateTime.now().difference(startTime).inSeconds;
    final isTimeUp = isTimeUp(startTime);
    final hasMovesLeft = this.hasMovesLeft(movesUsed);
    final isScoreReached = isScoreTargetReached(finalScore);

    final success =
        isScoreReached && (!isTimeUp || timeLimitSeconds == 0) && hasMovesLeft;

    return ChallengeResult(
      isSuccess: success,
      finalScore: finalScore,
      timeUsed: timeTaken,
      movesUsed: movesUsed,
      rating: calculateRating(finalScore, timeTaken, movesUsed),
    );
  }

  double calculateRating(int score, int timeUsed, int movesUsed) {
    // Rating calculation based on performance
    double rating = 0.0;

    // Score-based rating (0-5 points)
    rating += (score / targetScore) * 5.0;

    // Time efficiency bonus (if time limit exists)
    if (timeLimitSeconds > 0) {
      final timeEfficiency = (timeLimitSeconds - timeUsed) / timeLimitSeconds;
      rating += timeEfficiency.clamp(0.0, 1.0) *
          2.0; // Max 2 points for time efficiency
    }

    // Move efficiency bonus (if move limit exists)
    if (moveLimit > 0) {
      final moveEfficiency = (moveLimit - movesUsed) / moveLimit;
      rating += moveEfficiency.clamp(0.0, 1.0) *
          2.0; // Max 2 points for move efficiency
    }

    return rating.clamp(0.0, 5.0);
  }
}

enum ChallengeType { score, time, moves, survival, puzzle }

enum Difficulty { easy, medium, hard, expert }

class ChallengeResult {
  final bool isSuccess;
  final int finalScore;
  final int timeUsed;
  final int movesUsed;
  final double rating;

  ChallengeResult({
    required this.isSuccess,
    required this.finalScore,
    required this.timeUsed,
    required this.movesUsed,
    required this.rating,
  });
}

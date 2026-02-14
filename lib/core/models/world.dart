import 'package:flame/palette.dart';
import 'package:merge_odyssey/core/models/item.dart';

class World {
  final String id;
  final String name;
  final String description;
  final String biomeType; // forest, ice, wasteland, dragon_realm
  final String backgroundImage;
  final List<String> unlockRequirements; // List of item IDs needed to unlock
  final List<Item> availableItems;
  final int minLevelRequired;
  final List<Event> events;
  final List<Quest> quests;
  final Color themeColor;
  final double unlockCost; // Cost in coins to unlock
  final String? specialEffect; // Special visual effect for this world

  World({
    required this.id,
    required this.name,
    required this.description,
    required this.biomeType,
    required this.backgroundImage,
    this.unlockRequirements = const [],
    this.availableItems = const [],
    this.minLevelRequired = 1,
    this.events = const [],
    this.quests = const [],
    required this.themeColor,
    this.unlockCost = 0,
    this.specialEffect,
  });

  factory World.fromJson(Map<String, dynamic> json) {
    return World(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      biomeType: json['biomeType'],
      backgroundImage: json['backgroundImage'],
      unlockRequirements: List<String>.from(json['unlockRequirements'] ?? []),
      availableItems: (json['availableItems'] as List<dynamic>?)
              ?.map((itemJson) => Item.fromJson(itemJson))
              .toList() ??
          [],
      minLevelRequired: json['minLevelRequired'] ?? 1,
      events: (json['events'] as List<dynamic>?)
              ?.map((eventJson) => Event.fromJson(eventJson))
              .toList() ??
          [],
      quests: (json['quests'] as List<dynamic>?)
              ?.map((questJson) => Quest.fromJson(questJson))
              .toList() ??
          [],
      themeColor: Color(json['themeColor'] ?? 0xFF000000),
      unlockCost: json['unlockCost']?.toDouble() ?? 0,
      specialEffect: json['specialEffect'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'biomeType': biomeType,
      'backgroundImage': backgroundImage,
      'unlockRequirements': unlockRequirements,
      'availableItems': availableItems.map((item) => item.toJson()).toList(),
      'minLevelRequired': minLevelRequired,
      'events': events.map((event) => event.toJson()).toList(),
      'quests': quests.map((quest) => quest.toJson()).toList(),
      'themeColor': themeColor.value,
      'unlockCost': unlockCost,
      'specialEffect': specialEffect,
    };
  }

  World copyWith({
    String? id,
    String? name,
    String? description,
    String? biomeType,
    String? backgroundImage,
    List<String>? unlockRequirements,
    List<Item>? availableItems,
    int? minLevelRequired,
    List<Event>? events,
    List<Quest>? quests,
    Color? themeColor,
    double? unlockCost,
    String? specialEffect,
  }) {
    return World(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      biomeType: biomeType ?? this.biomeType,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      unlockRequirements: unlockRequirements ?? this.unlockRequirements,
      availableItems: availableItems ?? this.availableItems,
      minLevelRequired: minLevelRequired ?? this.minLevelRequired,
      events: events ?? this.events,
      quests: quests ?? this.quests,
      themeColor: themeColor ?? this.themeColor,
      unlockCost: unlockCost ?? this.unlockCost,
      specialEffect: specialEffect ?? this.specialEffect,
    );
  }

  bool isUnlocked(List<String> ownedItems, int playerLevel) {
    // Check if all requirements are met
    final hasAllRequirements =
        unlockRequirements.every((req) => ownedItems.contains(req));

    // Check minimum level requirement
    final hasMinLevel = playerLevel >= minLevelRequired;

    return hasAllRequirements && hasMinLevel;
  }
}

class Event {
  final String id;
  final String name;
  final String description;
  final EventType type;
  final int durationMinutes;
  final int difficulty;
  final List<Reward> rewards;
  final String? specialCondition; // Condition to trigger event
  final bool isActive;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.durationMinutes = 30,
    this.difficulty = 1,
    this.rewards = const [],
    this.specialCondition,
    this.isActive = true,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: EventType.values.firstWhere(
        (t) => t.toString().split('.').last == json['type'],
        orElse: () => EventType.timed,
      ),
      durationMinutes: json['durationMinutes'] ?? 30,
      difficulty: json['difficulty'] ?? 1,
      rewards: (json['rewards'] as List<dynamic>?)
              ?.map((rewardJson) => Reward.fromJson(rewardJson))
              .toList() ??
          [],
      specialCondition: json['specialCondition'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.toString().split('.').last,
      'durationMinutes': durationMinutes,
      'difficulty': difficulty,
      'rewards': rewards.map((reward) => reward.toJson()).toList(),
      'specialCondition': specialCondition,
      'isActive': isActive,
    };
  }
}

enum EventType { timed, survival, puzzle, boss }

class Quest {
  final String id;
  final String title;
  final String description;
  final QuestType type;
  final int targetCount;
  final List<Reward> rewards;
  final bool isRepeatable;
  final String? prerequisiteQuestId;
  final List<String> requiredItems;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.targetCount = 1,
    this.rewards = const [],
    this.isRepeatable = false,
    this.prerequisiteQuestId,
    this.requiredItems = const [],
  });

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: QuestType.values.firstWhere(
        (t) => t.toString().split('.').last == json['type'],
        orElse: () => QuestType.collection,
      ),
      targetCount: json['targetCount'] ?? 1,
      rewards: (json['rewards'] as List<dynamic>?)
              ?.map((rewardJson) => Reward.fromJson(rewardJson))
              .toList() ??
          [],
      isRepeatable: json['isRepeatable'] ?? false,
      prerequisiteQuestId: json['prerequisiteQuestId'],
      requiredItems: List<String>.from(json['requiredItems'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'targetCount': targetCount,
      'rewards': rewards.map((reward) => reward.toJson()).toList(),
      'isRepeatable': isRepeatable,
      'prerequisiteQuestId': prerequisiteQuestId,
      'requiredItems': requiredItems,
    };
  }
}

enum QuestType { collection, merge, survival, exploration, challenge }

class Reward {
  final String type; // coins, gems, items, experience
  final int amount;
  final String? itemId; // For item rewards

  Reward({
    required this.type,
    required this.amount,
    this.itemId,
  });

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      type: json['type'],
      amount: json['amount'],
      itemId: json['itemId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'amount': amount,
      'itemId': itemId,
    };
  }
}

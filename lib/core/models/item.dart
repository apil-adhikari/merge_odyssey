import 'package:flutter/material.dart';

enum ItemRarity { common, uncommon, rare, epic, legendary }

class Item {
  final String id;
  final String name;
  final int tier;
  final ItemRarity rarity;
  final String spritePath;
  final String description;
  final int mergeCost; // Cost to perform merge
  final String?
      mergeResultId; // ID of result when merged with another identical item
  final bool isMergeable;
  final Color backgroundColor;

  Item({
    required this.id,
    required this.name,
    required this.tier,
    required this.rarity,
    required this.spritePath,
    required this.description,
    this.mergeCost = 0,
    this.mergeResultId,
    this.isMergeable = true,
    this.backgroundColor = Colors.grey,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      tier: json['tier'],
      rarity: ItemRarity.values.firstWhere(
        (r) => r.toString().split('.').last == json['rarity'],
        orElse: () => ItemRarity.common,
      ),
      spritePath: json['spritePath'],
      description: json['description'] ?? '',
      mergeCost: json['mergeCost'] ?? 0,
      mergeResultId: json['mergeResultId'],
      isMergeable: json['isMergeable'] ?? true,
      backgroundColor: _getColorFromRarity(ItemRarity.values.firstWhere(
        (r) => r.toString().split('.').last == json['rarity'],
        orElse: () => ItemRarity.common,
      )),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tier': tier,
      'rarity': rarity.toString().split('.').last,
      'spritePath': spritePath,
      'description': description,
      'mergeCost': mergeCost,
      'mergeResultId': mergeResultId,
      'isMergeable': isMergeable,
    };
  }

  static Color _getColorFromRarity(ItemRarity rarity) {
    switch (rarity) {
      case ItemRarity.common:
        return Colors.grey[400]!;
      case ItemRarity.uncommon:
        return Colors.green[400]!;
      case ItemRarity.rare:
        return Colors.blue[400]!;
      case ItemRarity.epic:
        return Colors.purple[400]!;
      case ItemRarity.legendary:
        return Colors.orange[400]!;
    }
  }

  Item copyWith({
    String? id,
    String? name,
    int? tier,
    ItemRarity? rarity,
    String? spritePath,
    String? description,
    int? mergeCost,
    String? mergeResultId,
    bool? isMergeable,
    Color? backgroundColor,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      tier: tier ?? this.tier,
      rarity: rarity ?? this.rarity,
      spritePath: spritePath ?? this.spritePath,
      description: description ?? this.description,
      mergeCost: mergeCost ?? this.mergeCost,
      mergeResultId: mergeResultId ?? this.mergeResultId,
      isMergeable: isMergeable ?? this.isMergeable,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}

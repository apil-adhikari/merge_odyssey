import 'package:merge_odyssey/core/models/item.dart';

class Grid {
  final int width;
  final int height;
  List<List<Item?>> cells;

  Grid({required this.width, required this.height})
      : cells = List.generate(height, (_) => List.filled(width, null));

  Item? getItemAt(int x, int y) {
    if (isValidPosition(x, y)) {
      return cells[y][x];
    }
    return null;
  }

  void setItemAt(int x, int y, Item? item) {
    if (isValidPosition(x, y)) {
      cells[y][x] = item;
    }
  }

  bool isValidPosition(int x, int y) {
    return x >= 0 && x < width && y >= 0 && y < height;
  }

  List<(int, int)> getEmptyPositions() {
    List<(int, int)> emptyPositions = [];
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        if (cells[y][x] == null) {
          emptyPositions.add((x, y));
        }
      }
    }
    return emptyPositions;
  }

  bool hasEmptySpace() {
    return getEmptyPositions().isNotEmpty;
  }

  // Check if two adjacent items can be merged
  bool canMergeAt(int x1, int y1, int x2, int y2) {
    if (!isValidPosition(x1, y1) || !isValidPosition(x2, y2)) {
      return false;
    }

    final item1 = cells[y1][x1];
    final item2 = cells[y2][x2];

    if (item1 == null || item2 == null) {
      return false;
    }

    return item1.id == item2.id &&
        item1.isMergeable &&
        item2.isMergeable &&
        item1.mergeResultId != null;
  }

  // Perform merge operation between two adjacent cells
  bool performMerge(int x1, int y1, int x2, int y2) {
    if (!canMergeAt(x1, y1, x2, y2)) {
      return false;
    }

    final item1 = cells[y1][x1]!;
    final item2 = cells[y2][x2]!;

    // Remove both items
    cells[y1][x1] = null;
    cells[y2][x2] = null;

    // Create merged item
    final mergedItem = Item(
      id: '${item1.id}_merged_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Merged ${item1.name}',
      tier: item1.tier + 1,
      rarity: _getNextRarity(item1.rarity),
      spritePath: item1.mergeResultId ?? item1.spritePath,
      description: 'Merged item from ${item1.name}',
      mergeResultId: item1.mergeResultId,
      isMergeable: item1.mergeResultId != null,
    );

    // Place merged item at first position
    cells[y1][x1] = mergedItem;

    return true;
  }

  ItemRarity _getNextRarity(ItemRarity current) {
    switch (current) {
      case ItemRarity.common:
        return ItemRarity.uncommon;
      case ItemRarity.uncommon:
        return ItemRarity.rare;
      case ItemRarity.rare:
        return ItemRarity.epic;
      case ItemRarity.epic:
        return ItemRarity.legendary;
      case ItemRarity.legendary:
        return ItemRarity.legendary; // Max tier
    }
  }

  // Auto-merge idle functionality
  void processIdleMerges() {
    // Find all adjacent identical items and merge them automatically
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final currentItem = cells[y][x];
        if (currentItem == null) continue;

        // Check right neighbor
        if (x + 1 < width) {
          final rightItem = cells[y][x + 1];
          if (rightItem != null &&
              currentItem.id == rightItem.id &&
              currentItem.isMergeable &&
              rightItem.isMergeable) {
            performMerge(x, y, x + 1, y);
          }
        }

        // Check bottom neighbor
        if (y + 1 < height) {
          final bottomItem = cells[y + 1][x];
          if (bottomItem != null &&
              currentItem.id == bottomItem.id &&
              currentItem.isMergeable &&
              bottomItem.isMergeable) {
            performMerge(x, y, x, y + 1);
          }
        }
      }
    }
  }

  // Get all items of specific type
  List<(int, int, Item)> getAllItemsOfType(String itemId) {
    List<(int, int, Item)> foundItems = [];
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final item = cells[y][x];
        if (item != null && item.id == itemId) {
          foundItems.add((x, y, item));
        }
      }
    }
    return foundItems;
  }

  // Count total items on grid
  int getTotalItemCount() {
    int count = 0;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        if (cells[y][x] != null) {
          count++;
        }
      }
    }
    return count;
  }

  // Calculate total value of items on grid
  int getTotalGridValue() {
    int totalValue = 0;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final item = cells[y][x];
        if (item != null) {
          totalValue += item.tier * 10; // Simple value calculation
        }
      }
    }
    return totalValue;
  }
}

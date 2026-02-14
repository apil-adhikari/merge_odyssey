import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:merge_odyssey/core/models/grid.dart';
import 'package:merge_odyssey/core/models/item.dart';
import 'package:merge_odyssey/features/merge_game/components/tile_component.dart';

class GridComponent extends PositionComponent {
  final Grid grid;
  final double tileSize;
  final Function(int x, int y)? onTileTap;
  final Function(int x1, int y1, int x2, int y2)? onMergeAttempt;
  final List<TileComponent> _tiles = [];
  late final Paint _gridPaint;

  GridComponent({
    required this.grid,
    required this.tileSize,
    this.onTileTap,
    this.onMergeAttempt,
  }) : super(size: Vector2(grid.width * tileSize, grid.height * tileSize));

  @override
  Future<void> onLoad() async {
    super.onLoad();

    _gridPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    _createTiles();
  }

  void _createTiles() {
    for (int y = 0; y < grid.height; y++) {
      for (int x = 0; x < grid.width; x++) {
        final item = grid.getItemAt(x, y);
        final tile = TileComponent(
          position: Vector2(x * tileSize, y * tileSize),
          size: Vector2.all(tileSize),
          item: item,
          onTap: () => _handleTileTap(x, y),
        );
        add(tile);
        _tiles.add(tile);
      }
    }
  }

  void _handleTileTap(int x, int y) {
    // Highlight potential merge targets
    _highlightMergeTargets(x, y);
    onTileTap?.call(x, y);
  }

  void _highlightMergeTargets(int x, int y) {
    // Reset all highlights
    _tiles.forEach((tile) => tile.setHighlight(false));

    // Highlight adjacent tiles that can be merged
    final directions = [
      (-1, 0), (1, 0), (0, -1), (0, 1), // Horizontal and vertical
    ];

    for (final (dx, dy) in directions) {
      final nx = x + dx;
      final ny = y + dy;

      if (grid._isValidPosition(nx, ny) && grid.canMergeAt(x, y, nx, ny)) {
        final index = ny * grid.width + nx;
        if (index >= 0 && index < _tiles.length) {
          _tiles[index].setHighlight(true);
        }
      }
    }
  }

  void updateGrid() {
    for (int y = 0; y < grid.height; y++) {
      for (int x = 0; x < grid.width; x++) {
        final item = grid.getItemAt(x, y);
        final index = y * grid.width + x;
        if (index >= 0 && index < _tiles.length) {
          _tiles[index].updateItem(item);
        }
      }
    }
  }

  void animateMerge(int x1, int y1, int x2, int y2) {
    // Get the positions of the tiles to merge
    final pos1 = Vector2(x1 * tileSize, y1 * tileSize);
    final pos2 = Vector2(x2 * tileSize, y2 * tileSize);

    // Animate the merge effect
    _animateMergeEffect(pos1, pos2);
  }

  void _animateMergeEffect(Vector2 pos1, Vector2 pos2) {
    // Create a merge animation effect
    final centerPos = Vector2(
      (pos1.x + pos2.x) / 2,
      (pos1.y + pos2.y) / 2,
    );

    // Add a temporary particle effect at the merge location
    // This would involve creating and animating particle components
    // For simplicity, we'll just log the merge
    print('Animating merge at: $centerPos');
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw grid lines
    for (int i = 0; i <= grid.width; i++) {
      canvas.drawLine(
        Offset(i * tileSize, 0),
        Offset(i * tileSize, grid.height * tileSize),
        _gridPaint,
      );
    }

    for (int i = 0; i <= grid.height; i++) {
      canvas.drawLine(
        Offset(0, i * tileSize),
        Offset(grid.width * tileSize, i * tileSize),
        _gridPaint,
      );
    }
  }

  void refresh() {
    // Remove all existing tiles
    _tiles.clear();
    children.whereType<TileComponent>().forEach(remove);

    // Recreate tiles
    _createTiles();
  }
}

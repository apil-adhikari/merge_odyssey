import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:merge_odyssey/core/models/item.dart';

class TileComponent extends PositionComponent {
  Item? item;
  final Function()? onTap;
  bool _isHighlighted = false;
  late final Paint _highlightPaint;
  late final Paint _borderPaint;

  TileComponent({
    required super.position,
    required super.size,
    this.item,
    this.onTap,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    _highlightPaint = Paint()
      ..color = Colors.yellow.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    _borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Add tap detection
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = item?.backgroundColor ?? Colors.grey[300]!,
    );

    // Draw highlight if needed
    if (_isHighlighted) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.x, size.y),
        _highlightPaint,
      );
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.x, size.y),
        _borderPaint,
      );
    }

    // Draw item if present
    if (item != null) {
      _drawItem(canvas);
    }
  }

  void _drawItem(Canvas canvas) {
    final itemRect = Rect.fromCenter(
      center: Offset(size.x / 2, size.y / 2),
      width: size.x * 0.8,
      height: size.y * 0.8,
    );

    // For this example, we'll draw a simple colored rectangle
    // In a real implementation, you would load and draw the actual sprite
    final paint = Paint()
      ..color = item!.backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(itemRect, Radius.circular(8)),
      paint,
    );

    // Draw item tier number
    final textPainter = TextPainter(
      text: TextSpan(
        text: item!.tier.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: size.x * 0.3,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.x / 2 - textPainter.width / 2,
        size.y / 2 - textPainter.height / 2,
      ),
    );
  }

  void updateItem(Item? newItem) {
    item = newItem;
    // In a real implementation, you would update the sprite
    // and potentially trigger animations
  }

  void setHighlight(bool highlighted) {
    _isHighlighted = highlighted;
    // Trigger re-render
    markNeedsRender();
  }

  @override
  bool onTapDown(TapDownInfo info) {
    onTap?.call();
    return true;
  }
}

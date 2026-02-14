import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:merge_odyssey/core/models/player_progress.dart';

class HUDComponent extends PositionComponent {
  PlayerProgress playerProgress;
  int currentScore = 0;
  int currentLevel = 1;
  int movesUsed = 0;
  int timeRemaining = 0; // In seconds
  String? challengeTitle;
  bool isChallengeMode = false;
  final Function()? onMenuPressed;
  final Function()? onSettingsPressed;
  final Function()? onSharePressed;

  HUDComponent({
    required this.playerProgress,
    this.currentScore = 0,
    this.currentLevel = 1,
    this.movesUsed = 0,
    this.timeRemaining = 0,
    this.challengeTitle,
    this.isChallengeMode = false,
    this.onMenuPressed,
    this.onSettingsPressed,
    this.onSharePressed,
  }) : super(size: Vector2(800, 100)); // Adjust size as needed

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = Colors.black.withOpacity(0.6),
    );

    // Draw UI elements
    _drawCoins(canvas);
    _drawGems(canvas);
    _drawScore(canvas);
    _drawLevel(canvas);
    _drawMovesOrTime(canvas);
    _drawChallengeTitle(canvas);
    _drawButtons(canvas);
  }

  void _drawCoins(Canvas canvas) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: '💰 ${playerProgress.coins}',
        style: TextStyle(
          color: Colors.yellow[600],
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(20, 10));
  }

  void _drawGems(Canvas canvas) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: '💎 ${playerProgress.gems}',
        style: TextStyle(
          color: Colors.cyan[400],
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(150, 10));
  }

  void _drawScore(Canvas canvas) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Score: $currentScore',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(20, 40));
  }

  void _drawLevel(Canvas canvas) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Lvl: $currentLevel',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(150, 40));
  }

  void _drawMovesOrTime(Canvas canvas) {
    String displayText;
    if (isChallengeMode) {
      if (timeRemaining > 0) {
        displayText = '⏱️ ${_formatTime(timeRemaining)}';
      } else {
        displayText = 'Moves: $movesUsed';
      }
    } else {
      displayText = 'Merges: ${playerProgress.totalMerges}';
    }

    final textPainter = TextPainter(
      text: TextSpan(
        text: displayText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(20, 70));
  }

  void _drawChallengeTitle(Canvas canvas) {
    if (challengeTitle != null && isChallengeMode) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: challengeTitle,
          style: TextStyle(
            color: Colors.orangeAccent,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(size.x - textPainter.width - 20, 10));
    }
  }

  void _drawButtons(Canvas canvas) {
    // Menu button
    _drawButton(canvas, size.x - 150, 10, 40, 40, '☰', onMenuPressed);

    // Settings button
    _drawButton(canvas, size.x - 100, 10, 40, 40, '⚙️', onSettingsPressed);

    // Share button (only in challenge mode)
    if (isChallengeMode) {
      _drawButton(canvas, size.x - 150, 60, 40, 40, '📤', onSharePressed);
    }
  }

  void _drawButton(Canvas canvas, double x, double y, double width,
      double height, String label, Function()? onPressed) {
    // Button background
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, width, height),
        Radius.circular(8),
      ),
      Paint()
        ..color = Colors.grey[700]!
        ..style = PaintingStyle.fill,
    );

    // Button border
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, width, height),
        Radius.circular(8),
      ),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // Button label
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        x + width / 2 - textPainter.width / 2,
        y + height / 2 - textPainter.height / 2,
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void updateProgress(PlayerProgress newProgress) {
    playerProgress = newProgress;
  }

  void updateScore(int newScore) {
    currentScore = newScore;
  }

  void updateTime(int newTime) {
    timeRemaining = newTime;
  }

  void updateMoves(int newMoves) {
    movesUsed = newMoves;
  }

  void setChallengeMode(String? title, bool enabled) {
    challengeTitle = title;
    isChallengeMode = enabled;
  }
}

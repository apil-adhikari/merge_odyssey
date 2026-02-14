import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:merge_odyssey/core/models/grid.dart';
import 'package:merge_odyssey/core/models/player_progress.dart';
import 'package:merge_odyssey/core/models/item.dart';
import 'package:merge_odyssey/features/merge_game/components/grid_component.dart';
import 'package:merge_odyssey/features/merge_game/components/hud_component.dart';
import 'package:merge_odyssey/core/services/firebase_service.dart';

class MergeOdysseyGame extends FlameGame with HasDraggables, HasTappables {
  late Grid _grid;
  late PlayerProgress _playerProgress;
  late GridComponent _gridComponent;
  late HUDComponent _hudComponent;

  int _selectedX = -1;
  int _selectedY = -1;
  int _currentScore = 0;
  int _movesUsed = 0;
  DateTime? _startTime;
  String? _currentChallengeId;
  bool _isChallengeMode = false;

  MergeOdysseyGame({
    required Grid grid,
    required PlayerProgress playerProgress,
    String? challengeId,
  }) {
    _grid = grid;
    _playerProgress = playerProgress;
    _currentChallengeId = challengeId;
    _isChallengeMode = challengeId != null;
    _startTime = DateTime.now();
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Initialize components
    _initializeGridComponent();
    _initializeHUD();

    // Add components to the game
    add(_gridComponent);
    add(_hudComponent);
  }

  void _initializeGridComponent() {
    _gridComponent = GridComponent(
      grid: _grid,
      tileSize: 80.0,
      onTileTap: _handleTileTap,
      onMergeAttempt: _handleMergeAttempt,
    );
    _gridComponent.position = Vector2(50, 150); // Position below HUD
  }

  void _initializeHUD() {
    _hudComponent = HUDComponent(
      playerProgress: _playerProgress,
      currentScore: _currentScore,
      currentLevel: _playerProgress.level,
      movesUsed: _movesUsed,
      isChallengeMode: _isChallengeMode,
      challengeTitle: _currentChallengeId != null ? 'Challenge Mode' : null,
      onMenuPressed: _showMenu,
      onSettingsPressed: _showSettings,
      onSharePressed: _shareChallenge,
    );
    _hudComponent.position = Vector2(0, 0);
  }

  void _handleTileTap(int x, int y) {
    if (_selectedX == -1 && _selectedY == -1) {
      // First selection
      _selectedX = x;
      _selectedY = y;
    } else {
      // Second selection - attempt merge
      if (_selectedX == x && _selectedY == y) {
        // Same tile selected twice, deselect
        _selectedX = -1;
        _selectedY = -1;
      } else if (_grid.canMergeAt(_selectedX, _selectedY, x, y)) {
        _attemptMerge(_selectedX, _selectedY, x, y);
      } else {
        // Invalid merge, select new tile instead
        _selectedX = x;
        _selectedY = y;
      }
    }
  }

  void _attemptMerge(int x1, int y1, int x2, int y2) {
    if (_grid.performMerge(x1, y1, x2, y2)) {
      _movesUsed++;

      // Update score based on merged items
      final mergedItem = _grid.getItemAt(x1, y1);
      if (mergedItem != null) {
        _currentScore += mergedItem.tier * 10; // Score based on tier
      }

      // Update HUD
      _hudComponent.updateScore(_currentScore);
      _hudComponent.updateMoves(_movesUsed);

      // Update grid component
      _gridComponent.updateGrid();

      // Log merge event
      FirebaseService.instance().logMergeAction(
        'merged_item',
        mergedItem?.tier ?? 1,
        1, // Combo size
      );

      // Process any auto-merges
      _processAutoMerges();

      // Check win condition if in challenge mode
      if (_isChallengeMode) {
        _checkChallengeWinCondition();
      }

      // Reset selection
      _selectedX = -1;
      _selectedY = -1;
    }
  }

  void _processAutoMerges() {
    // Process idle merges after each manual merge
    _grid.processIdleMerges();
    _gridComponent.updateGrid();
  }

  void _checkChallengeWinCondition() {
    // This would check if the challenge objectives are met
    // For now, we'll just log it
    print('Checking challenge win condition...');
  }

  void _showMenu() {
    // Navigate to menu screen
    // This would typically use a navigator or state management
    print('Showing menu...');
  }

  void _showSettings() {
    // Navigate to settings screen
    print('Showing settings...');
  }

  void _shareChallenge() {
    // Share current challenge
    print('Sharing challenge...');
  }

  // Public methods for external interaction
  void addNewItem(Item item) {
    final emptyPositions = _grid.getEmptyPositions();
    if (emptyPositions.isNotEmpty) {
      final (x, y) = emptyPositions.first;
      _grid.setItemAt(x, y, item);
      _gridComponent.refresh(); // Refresh the grid display
    }
  }

  PlayerProgress getUpdatedPlayerProgress() {
    return _playerProgress.copyWith(
      totalMerges: _playerProgress.totalMerges + _movesUsed,
      totalScore: _playerProgress.totalScore + _currentScore,
    );
  }

  int getCurrentScore() => _currentScore;
  int getMovesUsed() => _movesUsed;
  Grid getGrid() => _grid;

  // Handle game pause/resume
  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    // Handle resize if needed
  }
}

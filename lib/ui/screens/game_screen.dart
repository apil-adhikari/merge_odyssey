import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:merge_odyssey/core/providers/game_provider.dart';
import 'package:merge_odyssey/features/merge_game/merge_game.dart';
import 'package:merge_odyssey/core/models/grid.dart';
import 'package:merge_odyssey/core/models/item.dart';

class GameScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late MergeOdysseyGame _game;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    final gameController = ref.read(gameProvider.notifier);
    final playerProgress =
        ref.read(gameProvider.select((value) => value.playerProgress));

    // Create initial grid
    final grid = Grid(width: 8, height: 8);

    // Add some starting items
    grid.setItemAt(
        0,
        0,
        Item(
          id: 'rock_1',
          name: 'Rock',
          tier: 1,
          rarity: ItemRarity.common,
          spritePath: 'assets/images/rock.png',
          description: 'Basic rock',
          isMergeable: true,
          mergeResultId: 'pebble_tool',
        ));

    grid.setItemAt(
        1,
        0,
        Item(
          id: 'rock_2',
          name: 'Rock',
          tier: 1,
          rarity: ItemRarity.common,
          spritePath: 'assets/images/rock.png',
          description: 'Basic rock',
          isMergeable: true,
          mergeResultId: 'pebble_tool',
        ));

    // Initialize the game
    _game = MergeOdysseyGame(
      grid: grid,
      playerProgress: playerProgress,
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Merge Odyssey'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('How to Play'),
                    content: Text(
                      'Tap on two adjacent identical items to merge them!\n\n'
                      'Merge items to create better ones and achieve objectives.\n\n'
                      'Try to reach the target score or complete challenges.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: GameWidget(
        game: _game,
        loadingBuilder: (context) => Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add a new random item to the grid
          final gameController = ref.read(gameProvider.notifier);
          final playerProgress =
              ref.read(gameProvider.select((value) => value.playerProgress));

          // This would add a new item based on player progress
          _game.addNewItem(Item(
            id: 'random_item_${DateTime.now().millisecondsSinceEpoch}',
            name: 'Random Item',
            tier: playerProgress.level,
            rarity: ItemRarity.common,
            spritePath: 'assets/images/random_item.png',
            description: 'Randomly generated item',
            isMergeable: true,
            mergeResultId: 'upgraded_item',
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

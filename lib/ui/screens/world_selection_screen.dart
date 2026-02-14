import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merge_odyssey/core/providers/game_provider.dart';
import 'package:merge_odyssey/core/models/world.dart';

class WorldSelectionScreen extends ConsumerWidget {
  const WorldSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Worlds'),
        elevation: 0,
      ),
      body: gameState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : gameState.availableWorlds.isEmpty
              ? _buildEmptyState(context)
              : _buildWorldList(context, gameState.availableWorlds, gameState.playerProgress),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.explore,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No worlds available',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new worlds!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorldList(
    BuildContext context,
    List<World> worlds,
    playerProgress,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: worlds.length,
      itemBuilder: (context, index) {
        final world = worlds[index];
        final isUnlocked = world.isUnlocked(
          playerProgress.unlockedItems,
          playerProgress.level,
        );

        return _WorldCard(
          world: world,
          isUnlocked: isUnlocked,
          onTap: () => _handleWorldTap(context, world, isUnlocked),
        );
      },
    );
  }

  void _handleWorldTap(BuildContext context, World world, bool isUnlocked) {
    if (!isUnlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unlock this world by reaching level ${world.minLevelRequired}',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    // Navigate to the world (this would typically start a level or show world details)
    showDialog(
      context: context,
      builder: (context) => _WorldDetailsDialog(world: world),
    );
  }
}

class _WorldCard extends StatelessWidget {
  final World world;
  final bool isUnlocked;
  final VoidCallback onTap;

  const _WorldCard({
    required this.world,
    required this.isUnlocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isUnlocked ? 4 : 2,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background placeholder (would use actual image)
            Container(
              color: world.themeColor.withOpacity(0.3),
              child: Center(
                child: Icon(
                  _getBiomeIcon(world.biomeType),
                  size: 48,
                  color: world.themeColor.withOpacity(0.5),
                ),
              ),
            ),
            // Content
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      world.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      world.description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!isUnlocked)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.lock,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Level ${world.minLevelRequired}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getBiomeIcon(String biomeType) {
    switch (biomeType) {
      case 'forest':
        return Icons.park;
      case 'ice':
        return Icons.ac_unit;
      case 'wasteland':
        return Icons.terrain;
      case 'dragon_realm':
        return Icons.local_fire_department;
      default:
        return Icons.public;
    }
  }
}

class _WorldDetailsDialog extends StatelessWidget {
  final World world;

  const _WorldDetailsDialog({required this.world});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            _getBiomeIcon(world.biomeType),
            color: world.themeColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              world.name,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(world.description),
            const SizedBox(height: 16),
            if (world.minLevelRequired > 1) ...[
              Row(
                children: [
                  const Icon(Icons.star, size: 16),
                  const SizedBox(width: 4),
                  Text('Required Level: ${world.minLevelRequired}'),
                ],
              ),
              const SizedBox(height: 8),
            ],
            if (world.unlockCost > 0) ...[
              Row(
                children: [
                  const Icon(Icons.monetization_on, size: 16),
                  const SizedBox(width: 4),
                  Text('Unlock Cost: ${world.unlockCost.toInt()} coins'),
                ],
              ),
              const SizedBox(height: 8),
            ],
            if (world.availableItems.isNotEmpty) ...[
              const Text(
                'Available Items:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              ...world.availableItems.take(3).map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(left: 16, top: 2),
                      child: Text('• ${item.name}'),
                    ),
                  ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            // Navigate to the game with this world selected
            // This would typically involve setting the current world and starting gameplay
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Starting ${world.name}...'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: world.themeColor,
          ),
          child: const Text('Enter World'),
        ),
      ],
    );
  }

  IconData _getBiomeIcon(String biomeType) {
    switch (biomeType) {
      case 'forest':
        return Icons.park;
      case 'ice':
        return Icons.ac_unit;
      case 'wasteland':
        return Icons.terrain;
      case 'dragon_realm':
        return Icons.local_fire_department;
      default:
        return Icons.public;
    }
  }
}

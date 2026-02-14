import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merge_odyssey/core/providers/game_provider.dart';
import 'package:merge_odyssey/ui/widgets/daily_reward_widget.dart';
import 'package:merge_odyssey/ui/widgets/leaderboard_widget.dart';
import 'package:merge_odyssey/ui/widgets/event_banner.dart';
import 'package:merge_odyssey/ui/widgets/challenge_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final playerProgress =
        ref.watch(gameProvider.select((value) => value.playerProgress));

    return Scaffold(
      appBar: AppBar(
        title: Text('Merge Odyssey'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Player stats header
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard(
                      '💰', 'Coins', playerProgress.coins.toString()),
                  _buildStatCard('💎', 'Gems', playerProgress.gems.toString()),
                  _buildStatCard(
                      '🏆', 'Level', playerProgress.level.toString()),
                ],
              ),
            ),

            // Daily reward
            DailyRewardWidget(
              playerProgress: playerProgress,
              onRewardClaimed: (newProgress) {
                ref
                    .read(gameProvider.notifier)
                    .updatePlayerProgress(newProgress);
              },
            ),

            SizedBox(height: 16),

            // Current event
            EventBanner(
              title: 'Winter Merge Festival',
              description: 'Special winter items and challenges!',
              endDate: DateTime.now().add(Duration(days: 7)),
            ),

            SizedBox(height: 16),

            // Featured challenges
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Featured Challenges',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 8),

            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3, // Sample challenges
                itemBuilder: (context, index) {
                  return ChallengeCard(
                    title: 'Beginner Challenge $index',
                    description: 'Merge 10 items to win',
                    difficulty: 'Easy',
                    reward: '+100 coins',
                    onTap: () {
                      // Navigate to challenge
                    },
                  );
                },
              ),
            ),

            SizedBox(height: 16),

            // Leaderboard
            LeaderboardWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String icon, String label, String value) {
    return Card(
      elevation: 4,
      child: Container(
        width: 100,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(icon, style: TextStyle(fontSize: 24)),
            SizedBox(height: 8),
            Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
            SizedBox(height: 4),
            Text(value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

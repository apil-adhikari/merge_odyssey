import 'package:flutter/material.dart';
import 'package:merge_odyssey/core/models/player_progress.dart';

class DailyRewardWidget extends StatefulWidget {
  final PlayerProgress playerProgress;
  final Function(PlayerProgress) onRewardClaimed;

  const DailyRewardWidget({
    Key? key,
    required this.playerProgress,
    required this.onRewardClaimed,
  }) : super(key: key);

  @override
  State<DailyRewardWidget> createState() => _DailyRewardWidgetState();
}

class _DailyRewardWidgetState extends State<DailyRewardWidget> {
  @override
  Widget build(BuildContext context) {
    final isAvailable = widget.playerProgress.isDailyRewardAvailable;
    final day = widget.playerProgress.dailyRewardDay + 1;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daily Reward - Day $day',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (isAvailable)
                  ElevatedButton(
                    onPressed: _claimReward,
                    child: Text('Claim Reward'),
                  )
                else
                  Text(
                    'Available tomorrow',
                    style: TextStyle(color: Colors.grey),
                  ),
              ],
            ),
            SizedBox(height: 8),
            _buildRewardPreview(day),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardPreview(int day) {
    final weeklyCycle = (day - 1) % 7;
    final baseReward = 50 + (day * 10);

    int coins;
    int gems;

    switch (weeklyCycle) {
      case 0:
        coins = baseReward;
        gems = 5;
        break;
      case 3:
        coins = baseReward + 30;
        gems = 10;
        break;
      case 6:
        coins = baseReward + 100;
        gems = 15;
        break;
      default:
        coins = baseReward + (weeklyCycle * 10);
        gems = 5;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildRewardItem('💰', '$coins Coins'),
        _buildRewardItem('💎', '$gems Gems'),
        if (day % 7 == 0) _buildRewardItem('🎁', 'Special Bonus'),
      ],
    );
  }

  Widget _buildRewardItem(String icon, String label) {
    return Column(
      children: [
        Text(icon, style: TextStyle(fontSize: 24)),
        Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  void _claimReward() {
    final newProgress = widget.playerProgress.claimDailyReward();
    widget.onRewardClaimed(newProgress);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Daily reward claimed!')),
    );
  }
}

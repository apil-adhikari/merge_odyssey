import 'package:flutter/material.dart';
import 'package:merge_odyssey/core/services/firebase_service.dart';

class LeaderboardWidget extends StatefulWidget {
  @override
  State<LeaderboardWidget> createState() => _LeaderboardWidgetState();
}

class _LeaderboardWidgetState extends State<LeaderboardWidget> {
  List<Map<String, dynamic>> _topPlayers = [];
  bool _isLoading = true;
  int _viewMode = 0; // 0 = Score, 1 = Merges

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    setState(() {
      _isLoading = true;
    });

    if (_viewMode == 0) {
      _topPlayers = await FirebaseService.instance().getTopPlayersByScore(10);
    } else {
      _topPlayers = await FirebaseService.instance().getTopPlayersByMerges(10);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Leaderboard',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _viewMode == 0
                        ? null
                        : () {
                            setState(() {
                              _viewMode = 0;
                            });
                            _loadLeaderboard();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _viewMode == 0 ? Colors.blue : null,
                    ),
                    child: Text('Top Scores'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _viewMode == 1
                        ? null
                        : () {
                            setState(() {
                              _viewMode = 1;
                            });
                            _loadLeaderboard();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _viewMode == 1 ? Colors.blue : null,
                    ),
                    child: Text('Top Merges'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _topPlayers.length,
                separatorBuilder: (context, index) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final player = _topPlayers[index];
                  return ListTile(
                    leading: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: _getRankColor(index),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                        'Player ${player['playerId'].toString().substring(0, 8)}...'),
                    trailing: Text(
                      _viewMode == 0
                          ? '${player['score']} pts'
                          : '${player['merges']} merges',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Level ${player['level']}'),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 0:
        return Colors.orange[600]!;
      case 1:
        return Colors.grey[600]!;
      case 2:
        return Colors.brown[600]!;
      default:
        return Colors.blue[400]!;
    }
  }
}

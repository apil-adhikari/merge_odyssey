import 'package:flutter/material.dart';

class ChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final String difficulty;
  final String reward;
  final VoidCallback onTap;

  const ChallengeCard({
    Key? key,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.reward,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color difficultyColor;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        difficultyColor = Colors.green;
        break;
      case 'medium':
        difficultyColor = Colors.orange;
        break;
      case 'hard':
        difficultyColor = Colors.red;
        break;
      default:
        difficultyColor = Colors.grey;
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 200,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: difficultyColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      difficulty,
                      style: TextStyle(
                        color: difficultyColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              Row(
                children: [
                  Icon(Icons.monetization_on, size: 16, color: Colors.amber),
                  SizedBox(width: 4),
                  Text(
                    reward,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.amber[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

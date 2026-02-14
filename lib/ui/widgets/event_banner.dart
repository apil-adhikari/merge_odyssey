import 'package:flutter/material.dart';

class EventBanner extends StatelessWidget {
  final String title;
  final String description;
  final DateTime endDate;
  final VoidCallback? onTap;

  const EventBanner({
    Key? key,
    required this.title,
    required this.description,
    required this.endDate,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final daysLeft = endDate.difference(DateTime.now()).inDays;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      color: Colors.orange[100],
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange[600],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${daysLeft > 0 ? daysLeft : 0} days left',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(description),
              SizedBox(height: 8),
              LinearProgressIndicator(
                value: _calculateProgress(),
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateProgress() {
    final totalDuration =
        endDate.difference(DateTime.parse('2026-02-01')).inDays.toDouble();
    final elapsed = DateTime.now()
        .difference(DateTime.parse('2026-02-01'))
        .inDays
        .toDouble();
    return (elapsed / totalDuration).clamp(0.0, 1.0);
  }
}

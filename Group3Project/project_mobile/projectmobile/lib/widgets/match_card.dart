import 'package:flutter/material.dart';

class MatchCard extends StatelessWidget {
  final dynamic match;

  const MatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final homeTeam = match['homeTeam']?['name'] ?? 'Đội nhà';
    final awayTeam = match['awayTeam']?['name'] ?? 'Đội khách';
    final utcDate = match['utcDate'] ?? 'Chưa cập nhật';
    final competition = match['competition']?['name'] ?? 'Không rõ';

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 4,
      child: ListTile(
        leading: Icon(Icons.sports_soccer, color: Colors.green),
        title: Text(
          '$homeTeam vs $awayTeam',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thời gian: $utcDate'),
            Text('Giải đấu: $competition'),
          ],
        ),
      ),
    );
  }
}

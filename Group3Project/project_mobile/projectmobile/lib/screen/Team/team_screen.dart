import 'package:flutter/material.dart';
import 'package:projectmobile/Model/scoccerModel.dart';

class TeamDetailsScreen extends StatelessWidget {
  final Standing team;

  const TeamDetailsScreen({Key? key, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(team.team?.name ?? 'Đội bóng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              team.team?.logo ?? '',
              width: 100,
              height: 100,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.red, size: 50),
            ),
            const SizedBox(height: 10),
            Text(
              team.team?.name ?? 'Không có tên đội',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Xếp hạng: ${team.rank}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Điểm số: ${team.points}',
              style: const TextStyle(fontSize: 18, color: Colors.green),
            ),
            const SizedBox(height: 10),
            Text(
              'Số trận: ${team.all?.played ?? 0}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Thắng: ${team.all?.win ?? 0}  |  Hòa: ${team.all?.draw ?? 0}  |  Thua: ${team.all?.lose ?? 0}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: team.form?.split('').map((result) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: result == 'W' ? Colors.green : result == 'D' ? Colors.grey : Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            result,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    );
                  }).toList() ??
                  [],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:projectmobile/api/event_api.dart';
import 'package:projectmobile/Model/match_model/event_model.dart';

class EventTab extends StatelessWidget {
  final int fixtureId;

  const EventTab({super.key, required this.fixtureId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<int, List<MatchEvent>>>(
      future: fetchMatchEvents(fixtureId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có sự kiện nào.'));
        }

        final eventsByTeam = snapshot.data!;
        final allEvents = eventsByTeam.entries
            .expand((entry) => entry.value)
            .toList()
          ..sort((a, b) => a.time.compareTo(b.time)); // Sắp xếp theo thời gian

        final teamIds = eventsByTeam.keys.toList();
        final teamA = teamIds.isNotEmpty ? teamIds[0] : null;
        final teamB = teamIds.length > 1 ? teamIds[1] : null;

        return Container(
          color: Colors.black,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  teamA != null
                      ? Text(
                          eventsByTeam[teamA]![0].teamName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )
                      : const SizedBox(),
                  teamB != null
                      ? Text(
                          eventsByTeam[teamB]![0].teamName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )
                      : const SizedBox(),
                ],
              ),
              const Divider(color: Colors.grey),
              Expanded(
                child: ListView.builder(
                  itemCount: allEvents.length,
                  itemBuilder: (context, index) {
                    final event = allEvents[index];
                    final isTeamA = event.teamId == teamA;

                    return Row(
                      children: [
                        Expanded(
                          child: isTeamA
                              ? EventItem(event: event, alignRight: false)
                              : const SizedBox(),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: !isTeamA
                              ? EventItem(event: event, alignRight: true)
                              : const SizedBox(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class EventItem extends StatelessWidget {
  final MatchEvent event;
  final bool alignRight;

  const EventItem({super.key, required this.event, required this.alignRight});

  IconData getEventIcon(String type, String detail) {
    if (type == 'Goal') {
      return Icons.sports_soccer;
    } else if (type == 'Card') {
      return detail == 'Yellow Card' ? Icons.square : Icons.square;
    } else if (type == 'subst') {
      return Icons.swap_horiz;
    } else {
      return Icons.info;
    }
  }

  Color getEventColor(String type, String detail) {
    if (type == 'Card') {
      return detail == 'Yellow Card' ? Colors.yellow : Colors.red;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!alignRight) ...[
              Icon(getEventIcon(event.type, event.detail),
                  color: getEventColor(event.type, event.detail), size: 14),
              const SizedBox(width: 4),
            ],
            Column(
              crossAxisAlignment: alignRight
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  "${event.time}' - ${event.player}",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                if (event.type == 'Goal' && event.assist != null)
                  Text(
                    "Kiến tạo: ${event.assist}",
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                if (event.type == 'subst')
                  Row(
                    children: [
                      Text(
                        '${event.assist} - ', // Rời sân
                        style: const TextStyle(color: Colors.red, fontSize: 10),
                      ),
                      Text(
                        '${event.player}', // Vào sân
                        style:
                            const TextStyle(color: Colors.green, fontSize: 10),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
              ],
            ),
            if (alignRight) ...[
              const SizedBox(width: 4),
              Icon(getEventIcon(event.type, event.detail),
                  color: getEventColor(event.type, event.detail), size: 14),
            ],
          ],
        ),
      ),
    );
  }
}

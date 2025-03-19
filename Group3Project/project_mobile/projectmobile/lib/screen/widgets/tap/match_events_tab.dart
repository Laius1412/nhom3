import 'package:flutter/material.dart';
import '/api/events_api.dart';
import '/model/livescore_model.dart';
import '/model/match_model/event_model.dart';

class MatchEventsTab extends StatelessWidget {
  final LiveScore match;

  const MatchEventsTab({Key? key, required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MatchEvent>>(
      future: EventAPI.fetchMatchEvents(match.fixtureId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}', style: TextStyle(color: Colors.white)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có sự kiện nào.', style: TextStyle(color: Colors.white)));
        }

        final events = snapshot.data!;
        events.sort((a, b) => a.time.compareTo(b.time)); // Sắp xếp theo thời gian

        final teamIds = events.map((e) => e.teamId).toSet().toList();
        final teamB = teamIds.isNotEmpty ? teamIds[0] : null;
        final teamA = teamIds.length > 1 ? teamIds[1] : null;

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
                          events.firstWhere((e) => e.teamId == teamA).teamName,
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        )
                      : const SizedBox(),
                  teamB != null
                      ? Text(
                          events.firstWhere((e) => e.teamId == teamB).teamName,
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        )
                      : const SizedBox(),
                ],
              ),
              const Divider(color: Colors.grey),
              Expanded(
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    final isTeamA = event.teamId == teamA;

                    return Row(
                      children: [
                        Expanded(
                          child: isTeamA ? EventItem(event: event, alignRight: false) : const SizedBox(),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: !isTeamA ? EventItem(event: event, alignRight: true) : const SizedBox(),
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

  const EventItem({Key? key, required this.event, required this.alignRight}) : super(key: key);

  IconData getEventIcon(String type, String detail) {
    if (type == 'Goal') {
      return Icons.sports_soccer;
    } else if (type == 'Card') {
      return detail == 'Yellow Card' ? Icons.square : Icons.square_outlined;
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
              Icon(getEventIcon(event.type, event.detail), color: getEventColor(event.type, event.detail), size: 14),
              const SizedBox(width: 4),
            ],
            Column(
              crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
                      Text('${event.player}', style: const TextStyle(color: Colors.red, fontSize: 10)),
                      const SizedBox(width: 4),
                      Text('${event.assist}', style: const TextStyle(color: Colors.green, fontSize: 10)),
                    ],
                  ),
              ],
            ),
            if (alignRight) ...[
              const SizedBox(width: 4),
              Icon(getEventIcon(event.type, event.detail), color: getEventColor(event.type, event.detail), size: 14),
            ],
          ],
        ),
      ),
    );
  }
}

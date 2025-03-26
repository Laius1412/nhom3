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
        events.sort((a, b) => a.time.compareTo(b.time)); // ✅ Sắp xếp theo thời gian

        return Container(
          color: Colors.black,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // ✅ Hiển thị tên đội (Đội nhà bên trái, Đội khách bên phải)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(match.homeTeam,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  Text(match.awayTeam,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(color: Colors.grey),

              // ✅ Hiển thị danh sách sự kiện theo thời gian
              Expanded(
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    bool isHomeTeam = event.teamId == match.homeTeamId;
                    return EventItem(event: event, alignRight: !isHomeTeam);
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

// 📌 Widget hiển thị từng sự kiện
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
              Icon(getEventIcon(event.type, event.detail), 
                  color: getEventColor(event.type, event.detail), 
                  size: 14),
              const SizedBox(width: 4),
            ],
            Column(
              crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 120, // Giới hạn độ rộng tối đa
                  child: Text(
                    "${event.time}' - ${event.player}",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // Cắt bớt nếu quá dài
                  ),
                ),
                if (event.type == 'Goal' && event.assist != null)
                  SizedBox(
                    width: 120, 
                    child: Text(
                      "Kiến tạo: ${event.assist}",
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (event.type == 'subst')
                  Row(
                    children: [
                      SizedBox(
                        width: 60, 
                        child: Text(
                          '${event.player}',
                          style: const TextStyle(color: Colors.red, fontSize: 10),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      SizedBox(
                        width: 60, 
                        child: Text(
                          '${event.assist}',
                          style: const TextStyle(color: Colors.green, fontSize: 10),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            if (alignRight) ...[
              const SizedBox(width: 4),
              Icon(getEventIcon(event.type, event.detail), 
                  color: getEventColor(event.type, event.detail), 
                  size: 14),
            ],
          ],
        ),
      ),
    );
  }
}

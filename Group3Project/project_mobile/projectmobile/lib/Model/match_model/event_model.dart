class MatchEvent {
  final int time;
  final String type;
  final String detail;
  final String player;
  final String? assist;
  final int teamId;
  final String teamName;

  MatchEvent({
    required this.time,
    required this.type,
    required this.detail,
    required this.player,
    this.assist,
    required this.teamId,
    required this.teamName,
  });

  factory MatchEvent.fromJson(Map<String, dynamic> json) {
    return MatchEvent(
      time: json['time']['elapsed'],
      type: json['type'],
      detail: json['detail'],
      player: json['player']['name'],
      assist: json['assist'] != null ? json['assist']['name'] : null,
      teamId: json['team']['id'],
      teamName: json['team']['name'],
    );
  }
}

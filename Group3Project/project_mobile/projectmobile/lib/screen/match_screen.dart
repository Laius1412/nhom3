import 'package:flutter/material.dart';
import 'package:projectmobile/api/fixtures_api.dart';

class MatchScreen extends StatefulWidget {
  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  late Future<Map<int, List<Match>>> futureMatches;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    futureMatches = fetchMatchesByDate(selectedDate);
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        futureMatches = fetchMatchesByDate(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match Schedule'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: FutureBuilder<Map<int, List<Match>>>(
        future: futureMatches,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(child: Text('No matches found for selected date.'));
            }
            return ListView(
              children: snapshot.data!.entries.map((entry) {
                int leagueId = entry.key;
                List<Match> matches = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'League $leagueId',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...matches.asMap().entries.map((matchEntry) {
                      int index = matchEntry.key;
                      Match match = matchEntry.value;

                      return Container(
                        color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
                        child: ListTile(
                          leading: Image.network(match.homeTeamLogo),
                          title: Text('${match.homeTeam} vs ${match.awayTeam}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Status: ${match.status}'),
                              if (match.result.isNotEmpty)
                                Text('Result: ${match.result}'),
                              Text(
                                'Time: ${match.date.toLocal().hour}:${match.date.toLocal().minute.toString().padLeft(2, '0')}',
                              ),
                            ],
                          ),
                          trailing: Image.network(match.awayTeamLogo),
                        ),
                      );
                    }).toList(),
                  ],
                );
              }).toList(),
            );
          } else {
            return Center(child: Text('No matches found.'));
          }
        },
      ),
    );
  }
}

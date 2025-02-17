import 'package:flutter/material.dart';
import 'package:projectmobile/api/fixtures_api.dart';


// class MatchScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: Container(
//         // color: Color(0xFF0A0A23),
//         child: Center(
//           child: Text('This is the Home Screen'),
//         ),
//       ),
//     );
//   }
// }


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
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.green[800]!,
              onPrimary: Colors.white,
              surface: Colors.black,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.black,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        futureMatches = fetchMatchesByDate(selectedDate);
      });
    }
  }

  void _previousDate() {
    setState(() {
      selectedDate = selectedDate.subtract(Duration(days: 1));
      futureMatches = fetchMatchesByDate(selectedDate);
    });
  }

  void _nextDate() {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: 1));
      futureMatches = fetchMatchesByDate(selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch thi đấu', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.green[800]),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Container(
              color: Colors.black,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.green[800]),
                    onPressed: _previousDate,
                  ),
                  Text(
                    '${selectedDate.toLocal()}'.split(' ')[0],
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward, color: Colors.green[800]),
                    onPressed: _nextDate,
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<Map<int, List<Match>>>(
                future: futureMatches,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error: ${snapshot.error}',
                            style: TextStyle(color: Colors.white)));
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Center(
                          child: Text('Không có trận đấu nào trong hôm nay.',
                              style: TextStyle(color: Colors.white)));
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        int leagueId = snapshot.data!.keys.elementAt(index);
                        String leagueName =
                            leagueNames[leagueId] ?? 'League $leagueId';
                        List<Match> matches = snapshot.data![leagueId]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: Colors.black,
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                leagueName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ...matches.map((match) {
                              bool isCompleted = match.status == 'FT';
                              return Card(
                                color: const Color.fromARGB(255, 55, 55, 55),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.green[800]!, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                elevation: 10,
                                shadowColor:
                                    Colors.green[800]!.withOpacity(0.5),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  leading: Image.network(match.homeTeamLogo,
                                      width: 30),
                                  title: Center(
                                    child: Text(
                                      isCompleted
                                          ? '${match.homeTeam} ${match.result.split('-')[0]} - ${match.result.split('-')[1]} ${match.awayTeam}'
                                          : '${match.homeTeam} vs ${match.awayTeam}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  subtitle: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text('Trạng thái: ${match.status}',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        Text(
                                          'Thời gian: ${match.date.toLocal().hour}:${match.date.toLocal().minute.toString().padLeft(2, '0')}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: Image.network(match.awayTeamLogo,
                                      width: 30),
                                ),
                              );
                            }).toList(),
                          ],
                        );
                      },
                    );
                  } else {
                    return Center(
                        child: Text('Không tìm thấy trận đấu.',
                            style: TextStyle(color: Colors.white)));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

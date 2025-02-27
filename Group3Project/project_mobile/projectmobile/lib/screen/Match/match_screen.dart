import 'package:flutter/material.dart';
import 'package:projectmobile/api/fixtures_api.dart';
import 'package:projectmobile/screen/Match/infor_match_screen.dart';
import 'package:projectmobile/Model/match_model/fixtures_model.dart';

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
            icon: Icon(Icons.calendar_month, color: Colors.green[800]),
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
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InforMatchScreen(
                                          fixtureId: match.fixtureId),
                                    ),
                                  );
                                },
                                child: Card(
                                  color: Color(0xFF1E1E1E),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.green[800]!, width: 1),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  elevation: 10,
                                  shadowColor:
                                      Colors.green[800]!.withOpacity(0.5),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Cột 1: Thời gian & trạng thái
                                        SizedBox(
                                          width: 50,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${match.date.toLocal().hour}:${match.date.toLocal().minute.toString().padLeft(2, '0')}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                match.status,
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Cột 2: Logo đội bóng
                                        SizedBox(
                                          width: 40,
                                          child: Column(
                                            children: [
                                              Image.network(match.homeTeamLogo,
                                                  width: 30, height: 30),
                                              SizedBox(height: 8),
                                              Image.network(match.awayTeamLogo,
                                                  width: 30, height: 30),
                                            ],
                                          ),
                                        ),

                                        // Cột 3: Tên đội bóng (chiều rộng lớn hơn)
                                        SizedBox(
                                          width: 200,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(match.homeTeam,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17)),
                                              SizedBox(height: 8),
                                              Text(match.awayTeam,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17)),
                                            ],
                                          ),
                                        ),

                                        // Cột 4: Tỉ số hoặc chuông thông báo
                                        SizedBox(
                                          width: 40,
                                          child: Column(
                                            children: [
                                              isCompleted
                                                  ? Text(
                                                      match.result
                                                          .split('-')[0],
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                      textAlign: TextAlign.end,
                                                    )
                                                  : Icon(
                                                      Icons.notifications_none,
                                                      color: Colors.grey,
                                                      size: 24),
                                              SizedBox(height: 8),
                                              isCompleted
                                                  ? Text(
                                                      match.result
                                                          .split('-')[1],
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                      textAlign: TextAlign.end,
                                                    )
                                                  : Container(), // Không hiển thị icon thứ 2
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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

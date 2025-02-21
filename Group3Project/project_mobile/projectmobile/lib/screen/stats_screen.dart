import 'package:flutter/material.dart';
import 'package:projectmobile/Model/scoccerModel.dart';
import 'package:projectmobile/api/standingApi.dart';
import 'package:projectmobile/screen/Team/team_screen.dart';

// class StandingsScreen extends StatelessWidget {
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
class StandingsScreen extends StatefulWidget {
  const StandingsScreen({super.key});

  @override
  _StandingsScreenState createState() => _StandingsScreenState();
}

class _StandingsScreenState extends State<StandingsScreen> {
  final StandingEPL api = StandingEPL(); // Instance of the API class
  List<Standing> standings = []; // List to hold the standings
  bool isLoading = true; // Loading indicator
  String errorMessage = ''; // Error message placeholder
  String selectedSeason = '2024-2025';
  String selectedLeague = 'Premier League';
  @override
  void initState() {
    super.initState();
    fetchStandingsData();
  }
  final Map<String, String> leagueIds ={
      'Premier League' : '39',
      'La Liga' : '140',
      'Serie A' : '135',
      'BundesLiga' : '78',
      'Ligue 1' : '61'
  };
  final Map<String, String> seasonIds = {
    '2022-2023' : '2022',
    '2023-2024' : '2023',
    '2024-2025' : '2024',
    '2025-2026' : '2025',
    '2026-2027' : '2026',
    '2027-2028' : '2027',
  };
  /// Fetch standings data from API
  Future<void> fetchStandingsData() async {
  setState(() {
    isLoading = true;
    errorMessage = '';
  });

  try {
    final leagueId = leagueIds[selectedLeague]!;
    final seasonId = seasonIds[selectedSeason]!;

    // Fetch data from API
    final data = await api.fetchStandings(
      leagueId: leagueId,
      seasonId: seasonId,
    );

    final soccerMatch = SoccerMatch.fromJson(data); // Map data to model
    final response = soccerMatch.response;

    if (response.isNotEmpty) {
      setState(() {
        standings = response.first.league?.standings.first ?? [];
      });
    } else {
      setState(() {
        errorMessage = 'No data available';
      });
    }
  } catch (e) {
    setState(() {
      errorMessage = 'Error fetching standings: $e';
    });
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}
  DropdownButton<String> buildSeasonDropdown() {
  return DropdownButton<String>(
    value: selectedLeague,
    dropdownColor: Colors.black,
    onChanged: (String? newValue) {
      setState(() {
        selectedLeague = newValue?? '';
      });
      fetchStandingsData();
    },
    underline: Container(),
    items: leagueIds.keys.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            ),
        
        ),
      );
    }).toList(),
  );
  }
  DropdownButton<String> buildLeagueDropdown() {
    return DropdownButton<String>(
      value: selectedSeason,
      dropdownColor: Colors.black,
      onChanged: (String? newValue) {
        setState(() {
          selectedSeason = newValue?? '';
        });
        fetchStandingsData();
      },
      underline: Container(),
      items: seasonIds.keys.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white
              ),
            ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 45,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 0, 0, 0), Color.fromARGB(255, 77, 16, 28)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end, // Căn giữa DropdownButton
          children: [
            Container(
              height: 30.0,
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0),
              decoration: BoxDecoration(
              color: const Color.fromARGB(255, 36, 34, 34),
              border: Border.all(
                color: const Color.fromARGB(255, 36, 34, 34), // Màu xám cho viền
                width: 2.0,        // Độ rộng của viền
                ),
              ),
              child: buildLeagueDropdown(),
            ),
            const SizedBox(width: 25),
            Container(
              height: 30.0,
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0),
              decoration: BoxDecoration(
              color: const Color.fromARGB(255, 36, 34, 34),
              border: Border.all(
                color: const Color.fromARGB(255, 36, 34, 34), // Màu xám cho viền
                width: 2.0,        // Độ rộng của viền
                ),
              ),
              child: buildSeasonDropdown()
              ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              : standings.isEmpty
                  ? const Center(child: Text('No standings data found'))
                  : SingleChildScrollView( // Bọc cả hai bảng trong SingleChildScrollView để cuộn đồng thời
                    child: Stack(
                      children: [
                        buildStandingsTable(), // Bảng đứng sẽ nằm dưới bảng ngắn
                        Positioned(
                          top: 0, // Đặt bảng ngắn ở trên cùng
                          child: buildShortTable(), // Bảng ngắn sẽ nằm trên bảng đứng
                        ),
                      ],
                    ),
                  ),
                );
  }
  /// Builds the standings table
  Widget buildStandingsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Cho phép cuộn ngang
        child: Column(
          children: [
            Container(
              // color: const Color.fromARGB(255, 10, 29, 15),
              decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 10, 29, 15), Color.fromARGB(255, 26, 61, 27)],
                ),
              ),
              child: DefaultTextStyle( // Áp dụng màu chữ mặc định
              style: const TextStyle(
                color: Colors.white, // Đặt màu chữ trắng
                fontWeight: FontWeight.normal,
                ),
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(40), // Cột #
                  1: FixedColumnWidth(60), // Cột Logo
                  2: FixedColumnWidth(150), // Cột CLB
                  3: FixedColumnWidth(40), // Cột Tr
                  4: FixedColumnWidth(40), // Cột T
                  5: FixedColumnWidth(40), // Cột H
                  6: FixedColumnWidth(40), // Cột B
                  7: FixedColumnWidth(40), // Cột HS
                  8: FixedColumnWidth(40), // Cột Đ
                  9: FixedColumnWidth(150), // Cột 5 trận gần nhất
                },
                border: TableBorder(
                  top: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 5, 19, 8),
                      ),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '#',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Logo',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'CLB',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Tr',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'T',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'H',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'B',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'HS',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Đ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '5 trận gần nhất',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  ...standings.map((team) {
                    return TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: const Color.fromARGB(255, 18, 51, 27),
                            width: 1,
                          )
                        )
                      ),
                      children: [
                        TableCell(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamDetailsScreen(team: team),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${team.rank}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ),
                        TableCell(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamDetailsScreen(team: team),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Image.network(
                                team.team?.logo ?? '',
                                width: 25,
                                height: 25,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error, color: Colors.red),
                              ),
                            ),
                          )
                        ),
                      TableCell(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamDetailsScreen(team: team),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${team.team?.name ?? 'N/A'}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ),
                        TableCell(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamDetailsScreen(team: team),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${team.all?.played ?? 0}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ),
                        TableCell(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamDetailsScreen(team: team),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${team.all?.win ?? 0}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ),
                        TableCell(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamDetailsScreen(team: team),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${team.all?.draw ?? 0}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ),
                        TableCell(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamDetailsScreen(team: team),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${team.all?.lose ?? 0}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ),
                        TableCell(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamDetailsScreen(team: team),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${team.goalsDiff ?? 0}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ),
                        TableCell(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamDetailsScreen(team: team),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${team.points ?? 0}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ),
                        TableCell(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamDetailsScreen(team: team),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: team.form?.split('').map((result) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.symmetric(horizontal: 2),
                                        child: Container(
                                          width: 15,
                                          height: 15,
                                          decoration: BoxDecoration(
                                            color: result == 'W'
                                                ? Colors.green
                                                : result == 'D'
                                                    ? Colors.grey
                                                    : Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              result,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList() ??
                                    [],
                              ),
                            ),
                          )
                        ),
                    ]);
                  }).toList(),
                ],
              ),
            ),
            ),
          ],
        ),
    );
  }
  Widget buildShortTable() {
  return SingleChildScrollView(
    scrollDirection: Axis.vertical, // Đảm bảo cuộn theo chiều dọc
    child: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 1, 17, 5), Color.fromARGB(255, 3, 41, 3)],
           ),
        ),
      child: DefaultTextStyle( // Áp dụng màu chữ mặc định
              style: const TextStyle(
                color: Colors.white, // Đặt màu chữ trắng
                fontWeight: FontWeight.normal, // Tuỳ chỉnh khác nếu cần
                ),
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(40), // Cột #
          1: FixedColumnWidth(60), // Cột Logo
        },
        border: TableBorder(
          top: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 5, 19, 8),

            ),
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '#',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Logo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          ...standings.map((team) {
            return TableRow(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color.fromARGB(255, 18, 51, 27),
                    width: 1,
                    )
                  )
                ),
              children: [
                TableCell(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeamDetailsScreen(team: team),
                        ),
                      );
                    },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${team.rank}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                    ),
                  ),
                )
              ),
              TableCell(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeamDetailsScreen(team: team),
                        ),
                      );
                    },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Image.network(
                      team.team?.logo ?? '',
                      width: 25,
                      height: 25,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                )
              ),
            ]);
          }).toList(),
        ],
      ),
    ),
    ),
  );
}
}

import 'package:flutter/material.dart';
import 'package:projectmobile/class/scoccerModel.dart';
import 'package:projectmobile/api/standingApi.dart';


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
    onChanged: (String? newValue) {
      setState(() {
        selectedLeague = newValue?? '';
      });
      fetchStandingsData();
    },
    items: leagueIds.keys.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
  );
}
DropdownButton<String> buildLeagueDropdown() {
  return DropdownButton<String>(
    value: selectedSeason,
    onChanged: (String? newValue) {
      setState(() {
        selectedSeason = newValue?? '';
      });
      fetchStandingsData();
    },
    items: seasonIds.keys.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Căn giữa DropdownButton
          children: [
            buildLeagueDropdown(),
            const SizedBox(width: 16),
            buildSeasonDropdown(),
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
              padding: const EdgeInsets.symmetric(horizontal: 8),
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
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey.shade200),
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
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'H',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'B',
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                    return TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${team.rank}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          team.team?.logo ?? '',
                          width: 30,
                          height: 30,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error, color: Colors.red),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${team.team?.name ?? 'N/A'}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${team.all?.played ?? 0}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${team.all?.win ?? 0}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${team.all?.draw ?? 0}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${team.all?.lose ?? 0}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${team.goalsDiff ?? 0}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${team.points ?? 0}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
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
                    ]);
                  }).toList(),
                ],
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
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(40), // Cột #
          1: FixedColumnWidth(60), // Cột Logo
        },
        border: TableBorder(
          top: BorderSide(color: Colors.grey.shade300, width: 1),
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        children: [
          TableRow(
            decoration: BoxDecoration(color: Colors.grey.shade200),
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
            ],
          ),
          ...standings.map((team) {
            return TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${team.rank}',
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  team.team?.logo ?? '',
                  width: 30,
                  height: 30,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, color: Colors.red),
                ),
              ),
            ]);
          }).toList(),
        ],
      ),
    ),
  );
}
}

import 'package:flutter/material.dart';
import 'package:projectmobile/api/fixtures_api.dart';
import 'package:projectmobile/screen/Match/infor_match_screen.dart';
import 'package:projectmobile/Model/match_model/fixtures_model.dart';
import 'package:projectmobile/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final Map<String, bool> _subscribedMatches = {};
  final NotificationService _notificationService = NotificationService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    futureMatches = fetchMatchesByDate(selectedDate);
    _loadSubscribedMatches();
  }

  // Kiểm tra xem người dùng đã đăng nhập hay chưa
  bool get isUserLoggedIn => _auth.currentUser != null;

  // Lấy ID của người dùng hiện tại
  String? get currentUserId => _auth.currentUser?.uid;

  Future<void> _loadSubscribedMatches() async {
    // Chỉ tải các đăng ký thông báo nếu người dùng đã đăng nhập
    if (!isUserLoggedIn) {
      setState(() {
        _subscribedMatches.clear();
      });
      return;
    }

    final userId = currentUserId!;

    try {
      // Tải các đăng ký thông báo từ collection của người dùng
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('match_subscriptions')
          .where('status', isEqualTo: 'active')
          .get();

      setState(() {
        _subscribedMatches.clear();
        for (var doc in snapshot.docs) {
          final fixtureId = doc.data()['fixtureId'] as String;
          _subscribedMatches[fixtureId] = true;
        }
      });
    } catch (e) {
      print('Error loading subscribed matches: $e');
    }
  }

  Future<void> _toggleMatchNotification(String fixtureId, DateTime matchTime,
      String homeTeam, String awayTeam) async {
    // Kiểm tra đăng ký hiện tại
    final isCurrentlySubscribed =
        await _notificationService.isMatchSubscribed(fixtureId);

    if (isCurrentlySubscribed) {
      // Hủy đăng ký
      final result = await _notificationService.unsubscribeFromMatch(fixtureId);

      if (result['success']) {
        setState(() {
          _subscribedMatches[fixtureId] = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      try {
        print('Subscribing to match notifications:');
        print('Match ID: $fixtureId');
        print('Match Time: $matchTime');
        print('Home Team: $homeTeam');
        print('Away Team: $awayTeam');

        // Đăng ký và hiển thị thông báo
        final result = await _notificationService.subscribeToMatch(
          fixtureId,
          matchTime,
          homeTeam: homeTeam,
          awayTeam: awayTeam,
          context: context, // Thêm tham số context
        );

        if (result['success']) {
          setState(() {
            _subscribedMatches[fixtureId] = true;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'])),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print('Error toggling match notification: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể đăng ký thông báo. Vui lòng thử lại sau.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
          // Thêm nút đăng nhập/đăng xuất nếu cần
          if (!isUserLoggedIn)
            IconButton(
              icon: Icon(Icons.login, color: Colors.green[800]),
              onPressed: () {
                // Điều hướng đến trang đăng nhập
                // Navigator.pushNamed(context, '/login');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Vui lòng đăng nhập để đăng ký thông báo trận đấu'),
                    action: SnackBarAction(
                      label: 'Đăng nhập',
                      onPressed: () {
                        // Điều hướng đến trang đăng nhập
                        // Navigator.pushNamed(context, '/login');
                      },
                    ),
                  ),
                );
              },
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
                                                    color: isCompleted
                                                        ? Colors.green
                                                        : Colors.red),
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
                                                  : IconButton(
                                                      icon: Icon(
                                                        Icons.notifications,
                                                        color: _subscribedMatches[match
                                                                    .fixtureId
                                                                    .toString()] ==
                                                                true
                                                            ? Colors.yellow
                                                            : Colors.grey,
                                                        size: 24,
                                                      ),
                                                      onPressed: () =>
                                                          _toggleMatchNotification(
                                                        match.fixtureId
                                                            .toString(),
                                                        match.date,
                                                        match.homeTeam,
                                                        match.awayTeam,
                                                      ),
                                                    ),
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

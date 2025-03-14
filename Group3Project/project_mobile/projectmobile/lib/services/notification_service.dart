import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectmobile/screen/Athu/login_screen.dart';
import 'dart:async';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  // Kiểm tra xem người dùng đã đăng nhập hay chưa
  bool get isUserLoggedIn => _auth.currentUser != null;

  // Lấy ID của người dùng hiện tại
  String? get currentUserId => _auth.currentUser?.uid;

  Future<void> initialize() async {
    try {
      // Initialize timezone
      tz.initializeTimeZones();

      // Request permission for notifications with all features
      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: true,
        carPlay: true,
        criticalAlert: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }

      // Initialize local notifications with detailed settings
      const initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) {
          // Handle notification tap
          print('Notification tapped: ${details.payload}');
        },
      );

      // Configure FCM
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Get FCM token and save to Firestore if user is logged in
      String? token = await _fcm.getToken();
      if (token != null && isUserLoggedIn) {
        await _saveFCMToken(token);
        print('FCM Token: $token');
      }

      // Listen for token refresh
      _fcm.onTokenRefresh.listen((token) {
        if (isUserLoggedIn) {
          _saveFCMToken(token);
          print('FCM Token refreshed: $token');
        }
      });

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Received foreground message: ${message.messageId}');
        showLocalNotification(
          message.notification?.title ?? 'Thông báo mới',
          message.notification?.body ?? '',
        );
      });
    } catch (e) {
      print('Error initializing notification service: $e');
    }
  }

  Future<void> _saveFCMToken(String token) async {
    if (!isUserLoggedIn) return;

    final userId = currentUserId!;

    // Lưu token vào collection users
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'fcmTokens': FieldValue.arrayUnion([token]),
      'lastTokenUpdate': FieldValue.serverTimestamp(),
    });

    // Lưu thông tin token với userId
    await FirebaseFirestore.instance.collection('fcm_tokens').doc(token).set({
      'token': token,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> scheduleMatchNotification(String fixtureId, DateTime matchTime,
      String homeTeam, String awayTeam) async {
    try {
      if (!isUserLoggedIn) return;

      final userId = currentUserId!;

      // Tính thời điểm 30 phút trước trận đấu
      final scheduledTime = matchTime.subtract(Duration(minutes: 30));
      final now = DateTime.now();

      // Chỉ lên lịch thông báo nếu thời gian thông báo còn trong tương lai
      if (scheduledTime.isAfter(now)) {
        final scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);

        // Tạo ID thông báo duy nhất cho mỗi người dùng và trận đấu
        final notificationId = int.parse(fixtureId) % 100000;

        // Hủy thông báo cũ nếu có
        await _localNotifications.cancel(notificationId);

        // Lưu thông tin thông báo vào Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('scheduled_notifications')
            .doc(fixtureId)
            .set({
          'fixtureId': fixtureId,
          'matchTime': Timestamp.fromDate(matchTime),
          'notificationTime': Timestamp.fromDate(scheduledTime),
          'homeTeam': homeTeam,
          'awayTeam': awayTeam,
          'status': 'scheduled',
          'userId': userId,
        });

        // Lên lịch thông báo 30 phút
        await _localNotifications.zonedSchedule(
          notificationId,
          'Trận đấu sắp diễn ra!',
          'Trận đấu giữa $homeTeam và $awayTeam sẽ bắt đầu sau 30 phút nữa',
          scheduledDate,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'match_notifications',
              'Thông báo trận đấu',
              channelDescription: 'Thông báo về các trận đấu bóng đá',
              importance: Importance.max,
              priority: Priority.max,
              enableLights: true,
              enableVibration: true,
              playSound: true,
              channelShowBadge: true,
              visibility: NotificationVisibility.public,
              styleInformation: BigTextStyleInformation(
                'Trận đấu giữa $homeTeam và $awayTeam sẽ bắt đầu sau 30 phút nữa',
              ),
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
              interruptionLevel: InterruptionLevel.timeSensitive,
            ),
          ),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );

        print('Scheduled 30-minute reminder for match: $homeTeam vs $awayTeam');
      }
    } catch (e) {
      print('Error scheduling match notification: $e');
    }
  }

  // Kiểm tra xem người dùng đã đăng ký thông báo cho trận đấu chưa
  Future<bool> isMatchSubscribed(String fixtureId) async {
    if (!isUserLoggedIn) return false;

    final userId = currentUserId!;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('match_subscriptions')
          .doc(fixtureId)
          .get();

      return doc.exists && doc.data()?['status'] == 'active';
    } catch (e) {
      print('Error checking match subscription: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> subscribeToMatch(
      String fixtureId, DateTime matchTime,
      {required String homeTeam,
      required String awayTeam,
      required BuildContext context}) async {
    try {
      // Kiểm tra đăng nhập
      if (!isUserLoggedIn) {
        // Hiển thị thông báo yêu cầu đăng nhập
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bạn cần đăng nhập để đăng ký thông báo trận đấu'),
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Đăng nhập',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
            ),
          ),
        );
        return {
          'success': false,
          'message': 'Bạn cần đăng nhập để đăng ký thông báo'
        };
      }

      final userId = currentUserId!;

      // Subscribe to FCM topic với userId
      await _fcm.subscribeToTopic('match_${fixtureId}_$userId');

      final now = DateTime.now();
      final difference = matchTime.difference(now);

      // Tạo thông điệp về thời gian còn lại
      String timeMessage;
      final days = difference.inDays;
      final hours = (difference.inHours % 24);
      final minutes = (difference.inMinutes % 60);

      if (days > 0) {
        timeMessage = '$days ngày';
        if (hours > 0) {
          timeMessage += ' $hours giờ';
        }
      } else if (hours > 0) {
        timeMessage = '$hours giờ';
        if (minutes > 0) {
          timeMessage += ' $minutes phút';
        }
      } else if (minutes > 0) {
        timeMessage = '$minutes phút';
      } else {
        timeMessage = 'vài phút';
      }

      // Lưu thông tin vào Firestore trong collection của user
      final userMatchRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('match_subscriptions')
          .doc(fixtureId);

      await userMatchRef.set({
        'fixtureId': fixtureId,
        'matchTime': Timestamp.fromDate(matchTime),
        'registrationTime': Timestamp.fromDate(now),
        'homeTeam': homeTeam,
        'awayTeam': awayTeam,
        'timeUntilMatch': {
          'days': days,
          'hours': hours,
          'minutes': minutes,
          'totalMinutes': difference.inMinutes
        },
        'status': 'active',
        'userId': userId,
      });

      // Lưu thông tin vào collection chung để quản lý
      await FirebaseFirestore.instance
          .collection('match_subscriptions')
          .doc('${fixtureId}_$userId')
          .set({
        'fixtureId': fixtureId,
        'userId': userId,
        'matchTime': Timestamp.fromDate(matchTime),
        'registrationTime': Timestamp.fromDate(now),
        'homeTeam': homeTeam,
        'awayTeam': awayTeam,
        'status': 'active',
      });

      // Hiển thị thông báo đăng ký với thời gian còn lại
      await showLocalNotification(
        'Flash Soccer',
        'Trận đấu giữa $homeTeam và $awayTeam sẽ diễn ra trong $timeMessage nữa',
      );

      // Lên lịch thông báo trước 30 phút
      if (matchTime.isAfter(now)) {
        await scheduleMatchNotification(
            fixtureId, matchTime, homeTeam, awayTeam);
      }

      print('Successfully subscribed to match: $homeTeam vs $awayTeam');
      print('Time until match: $timeMessage');

      return {'success': true, 'message': 'Đã đăng ký thông báo thành công'};
    } catch (e) {
      print('Error in subscribeToMatch: $e');
      print('Stack trace: ${e.toString()}');
      return {
        'success': false,
        'message': 'Đã xảy ra lỗi khi đăng ký thông báo'
      };
    }
  }

  Future<Map<String, dynamic>> unsubscribeFromMatch(String fixtureId) async {
    try {
      if (!isUserLoggedIn) {
        return {
          'success': false,
          'message': 'Bạn cần đăng nhập để hủy đăng ký thông báo'
        };
      }

      final userId = currentUserId!;

      // Hủy đăng ký topic FCM
      await _fcm.unsubscribeFromTopic('match_${fixtureId}_$userId');

      // Hủy thông báo đã lên lịch
      final notificationId = int.parse(fixtureId) % 100000;
      await _localNotifications.cancel(notificationId);

      // Cập nhật trạng thái trong Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('match_subscriptions')
          .doc(fixtureId)
          .update({
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
      });

      // Cập nhật trạng thái trong collection chung
      await FirebaseFirestore.instance
          .collection('match_subscriptions')
          .doc('${fixtureId}_$userId')
          .update({
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'message': 'Đã hủy đăng ký thông báo thành công'
      };
    } catch (e) {
      print('Error unsubscribing from match: $e');
      return {
        'success': false,
        'message': 'Đã xảy ra lỗi khi hủy đăng ký thông báo'
      };
    }
  }

  Future<void> showLocalNotification(String title, String body) async {
    try {
      final androidDetails = AndroidNotificationDetails(
        'match_notifications',
        'Thông báo trận đấu',
        channelDescription: 'Thông báo về các trận đấu bóng đá',
        importance: Importance.max,
        priority: Priority.max,
        enableLights: true,
        enableVibration: true,
        playSound: true,
        channelShowBadge: true,
        visibility: NotificationVisibility.public,
        styleInformation: BigTextStyleInformation(body),
      );

      final iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.timeSensitive,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final id = DateTime.now().millisecondsSinceEpoch % 100000;

      await _localNotifications.show(
        id,
        title,
        body,
        notificationDetails,
      );
    } catch (e) {
      print('Error showing notification: $e');
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages
  print("Đã nhận thông báo khi ứng dụng ở chế độ nền: ${message.messageId}");
}

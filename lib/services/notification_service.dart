import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        await _handleNotificationAction(response);
      },
    );
  }

  static Future<void> _handleNotificationAction(
      NotificationResponse response) async {
    if (response.payload == null) return;

    final companyId = response.payload;

    if (response.actionId == 'register') {
      try {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('userId');

        if (userId == null) return;

        final functions = FirebaseFunctions.instance;
        final result = await functions.httpsCallable('registerForCompany').call({
          'userId': userId,
          'companyId': companyId,
        });

        if (result.data != null && result.data['success'] == true) {
          // Show success notification
          await _showSuccessNotification(
              'Registration Successful', result.data['message']);
        } else {
          // Show error notification
          await _showErrorNotification(
              'Registration Failed', result.data['message']);
        }
      } catch (e) {
        await _showErrorNotification(
            'Registration Failed', 'An error occurred: $e');
      }
    }
  }

  static Future<void> _showSuccessNotification(
      String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'registration_results',
      'Registration Results',
      channelDescription: 'Notifications for registration results',
      importance: Importance.max,
      priority: Priority.high,
      color: Color(0xFF4CAF50),
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
    );
  }

  static Future<void> _showErrorNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'registration_results',
      'Registration Results',
      channelDescription: 'Notifications for registration results',
      importance: Importance.max,
      priority: Priority.high,
      color: Color(0xFFF44336),
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
    );
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:cloud_functions/cloud_functions.dart';

// Task names
const String emailCheckTask = 'com.placeMate.emailCheck';

// Initialize notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class BackgroundService {
  // Initialize the background service
  static Future<void> initialize() async {
    // Initialize Workmanager
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );

    // Initialize notifications
    await _initializeNotifications();

    // Register periodic task for email checking
    await registerEmailCheckTask();
  }

  // Register the email check task to run every 30 minutes
  static Future<void> registerEmailCheckTask() async {
    await Workmanager().registerPeriodicTask(
      emailCheckTask,
      emailCheckTask,
      frequency: Duration(minutes: 30),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      backoffPolicy: BackoffPolicy.linear,
    );
  }

  // Initialize notifications
  static Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  // Show a notification
  static Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'placement_notifications',
      'Placement Notifications',
      channelDescription: 'Notifications for placement opportunities',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}

// The callback function that will be called by Workmanager
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      switch (task) {
        case emailCheckTask:
          await _checkEmails();
          break;
        default:
          return Future.value(false);
      }
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}

// Check for new placement emails
Future<void> _checkEmails() async {
  try {
    // Check if user is logged in
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Call the cloud function to check emails
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('checkEmails');
    final result = await callable.call();

    // If new placements were found, show a notification
    if (result.data['newPlacementsFound'] == true) {
      await BackgroundService.showNotification(
        'New Placement Opportunity',
        'A new placement opportunity is available. Open the app to check details.',
      );
    }
  } catch (e) {
    debugPrint('Error checking emails in background: $e');
  }
}

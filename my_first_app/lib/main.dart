import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
  }

Future<void> _requestNotificationPermission() async {
  if (Platform.isAndroid) {
    final status = await Permission.notification.request();
    debugPrint("Notification permission status: $status");
  }
}

  Future<void> _scheduleCustomNotification(String reason) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'custom_channel',
      'Custom Notifications',
      channelDescription: 'Channel for user-triggered custom reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Reminder',
      'Reminder for $reason',
      platformDetails,
    );

    debugPrint("Notification scheduled for: $reason");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Custom Timer Notifications')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _scheduleCustomNotification("Task A"),
                child: Text("Trigger Notification for Task A"),
              ),
              ElevatedButton(
                onPressed: () => _scheduleCustomNotification("Task B"),
                child: Text("Trigger Notification for Task B"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

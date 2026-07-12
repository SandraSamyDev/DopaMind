import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FocusNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> showRunningNotification({
    required int secondsLeft,
    bool paused = false,
  }) async {
    final minutes = secondsLeft ~/ 60;
    final seconds = secondsLeft % 60;

    final time =
        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

    final android = AndroidNotificationDetails(
      'focus_channel',
      'Focus Session',
      channelDescription: 'Running focus timer',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      onlyAlertOnce: true,
      showWhen: false,
    );

    await _notifications.show(
      500,
      paused ? "⏸ Focus Paused" : "Focus Running",
      "Remaining: $time",
      NotificationDetails(android: android),
    );
  }

  static Future<void> stopNotification() async {
    await _notifications.cancel(500);
  }
}
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:dopamind/models/task_model.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    tz.initializeTimeZones();

    tz.setLocalLocation(
    tz.getLocation('Africa/Cairo'),
  );

    await _notifications.initialize(settings);
  }

  static Future<void> requestPermission() async {
    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  static Future<void> scheduleNotification({
  required int id,
  required String title,
  required String body,
  required tz.TZDateTime scheduledTime,
}) async {
  const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
  'timer_channel',
  'Focus Timer',
  channelDescription: 'Focus timer notifications',
  importance: Importance.max,
  priority: Priority.high,
  playSound: true,
  enableVibration: true,
);

  const NotificationDetails details = NotificationDetails(
    android: androidDetails,
  );

  await _notifications.zonedSchedule(
    id,
    title,
    body,
    scheduledTime,
    details,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  );
}

static Future<void> showNotification({
  required int id,
  required String title,
  required String body,
}) async {
  const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
    'general_channel',
    'General Notifications',
    channelDescription: 'General notifications',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
  );

  const NotificationDetails details = NotificationDetails(
    android: androidDetails,
  );

  await _notifications.show(
    id,
    title,
    body,
    details,
  );
}

static Future<void> showPanicNotification({
  required String taskTitle,
  required Duration remaining,
}) async {
  const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
    'panic_channel',
    'Panic Mode',
    channelDescription: 'Emergency focus session',
    importance: Importance.max,
    priority: Priority.high,
    ongoing: true,
    onlyAlertOnce: true,
  );

  const NotificationDetails details = NotificationDetails(
    android: androidDetails,
  );

  final minutes = remaining.inMinutes;
  final seconds = remaining.inSeconds % 60;

  final time =
      "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

  await _notifications.show(
    5000,
    "Panic Mode",
    "$taskTitle\nRemaining: $time",
    details,
  );
}

static Future<void> scheduleTaskNotification(TaskModel task) async {
  final cairo = tz.getLocation('Africa/Cairo');

  final reminderTime = tz.TZDateTime(
    cairo,
    task.dueDate.year,
    task.dueDate.month,
    task.dueDate.day,
    task.reminder.hour,
    task.reminder.minute,
  );

  final tenMinutesBefore = reminderTime.subtract(
    const Duration(minutes: 10),
  );

  final now = tz.TZDateTime.now(cairo);

  // إشعار قبل الموعد بـ 10 دقائق
  if (tenMinutesBefore.isAfter(now)) {
    await scheduleNotification(
      id: task.id.hashCode + 1,
      title: "Task Reminder",
      body: "${task.title} starts in 10 minutes.",
      scheduledTime: tenMinutesBefore,
    );
  }

  // إشعار وقت الموعد
  if (reminderTime.isAfter(now)) {
    await scheduleNotification(
      id: task.id.hashCode,
      title: "Task Reminder",
      body: "It's time to start: ${task.title}",
      scheduledTime: reminderTime,
    );
  }
}

static Future<void> showTimerFinishedNotification() async {
  await showNotification(
    id: 999,
    title: "Focus Session Complete!",
    body: "Great job! Time for a short break.",
  );
}
  static Future<void> cancelNotification(int id) async {
  await _notifications.cancel(id);
  await _notifications.cancel(id + 1);
}
static Future<void> cancelPanicNotification() async {
  await _notifications.cancel(5000);
}
}

import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class FocusForegroundService {
  static void init() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'focus_channel',
        channelName: 'Focus Mode',
        channelDescription: 'DopaMind Focus Timer',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        showWhen: false,
      ),

      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),

      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(1000),
        autoRunOnBoot: false,
      ),
    );
  }

  static Future<void> start(int seconds) async {

  await FlutterForegroundTask.startService(
    notificationTitle: 'Focus Running',
    notificationText: 'Remaining $seconds seconds',

    notificationButtons: [
      const NotificationButton(
        id: 'pause',
        text: 'Pause',
      ),
      const NotificationButton(
        id: 'stop',
        text: 'Stop',
      ),
    ],

    callback: startCallback,
  );
}

  static Future<void> updateNotification(String text) async {
    await FlutterForegroundTask.updateService(notificationText: text);
  }

  static Future<void> stop() async {
    await FlutterForegroundTask.stopService();
  }
}

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(FocusTaskHandler());
}

class FocusTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {}

  @override
void onNotificationButtonPressed(String id) {
  if (id == 'pause') {
    FlutterForegroundTask.sendDataToMain({
      'action': 'pause',
    });
  }

  if (id == 'stop') {
    FlutterForegroundTask.sendDataToMain({
      'action': 'stop',
    });
  }
}

  @override
  void onNotificationPressed() {}
}

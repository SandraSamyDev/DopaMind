import 'package:shared_preferences/shared_preferences.dart';
import 'package:zo_app_blocker/zo_app_blocker.dart';

class BlockerService {
  static final BlockerService _instance = BlockerService._internal();
  factory BlockerService() => _instance;
  BlockerService._internal();

  List<String> _selectedPackages = [];
  bool _isLockdownActive = false;

  List<String> get selectedPackages => _selectedPackages;
  bool get isLockdownActive => _isLockdownActive;
  int get blockedAppsCount => _selectedPackages.length;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedPackages = prefs.getStringList('blocked_packages') ?? [];
  }

  Future<void> updateSelectedPackages(List<String> packages) async {
    _selectedPackages = packages;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('blocked_packages', packages);
  }

  bool isPackageSelected(String package) => _selectedPackages.contains(package);

  Future<void> startLockdown() async {
    if (_selectedPackages.isNotEmpty) {
      await ZoAppBlocker.instance.blockApps(_selectedPackages);
      _isLockdownActive = true;
    }
  }

  Future<void> stopLockdown() async {
    await ZoAppBlocker.instance.unblockAll();
    _isLockdownActive = false;
  }

  Future<void> saveFocusSessionData(String taskTitle, int minutesSpent) async {
    final prefs = await SharedPreferences.getInstance();

    int totalSavedMinutes = prefs.getInt('total_focus_minutes') ?? 0;
    totalSavedMinutes += minutesSpent;
    await prefs.setInt('total_focus_minutes', totalSavedMinutes);

    List<String> history = prefs.getStringList('focus_history') ?? [];
    history.add("${DateTime.now().toIso8601String()}|$taskTitle|$minutesSpent");
    await prefs.setStringList('focus_history', history);
  }

  Future<int> getTotalFocusMinutes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('total_focus_minutes') ?? 0;
  }

  Future<void> addToBlacklist(String packageName) async {
    if (!_selectedPackages.contains(packageName)) {
      _selectedPackages.add(packageName);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('blocked_packages', _selectedPackages);
    }
  }

  Future<void> removeFromBlacklist(String packageName) async {
    _selectedPackages.remove(packageName);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('blocked_packages', _selectedPackages);
  }


  Future<bool> _ensureAndroidPermissionsReady() async {

  if (await ZoAppBlocker.instance.checkNotificationPermission() != 'granted') {
    await ZoAppBlocker.instance.requestNotificationPermission();
    return false; // Stop here so they can accept notifications first
  }


  if (await ZoAppBlocker.instance.checkUsageStatsPermission() == 'denied') {
    await ZoAppBlocker.instance.requestUsageStatsPermission();
    return false; // Stop here so they can turn on Usage access
  }


  if (await ZoAppBlocker.instance.checkOverlayPermission() == 'denied') {
    await ZoAppBlocker.instance.requestOverlayPermission();
    return false;
  }


  final finalNotify = await ZoAppBlocker.instance.checkNotificationPermission();
  final finalUsage = await ZoAppBlocker.instance.checkUsageStatsPermission();
  final finalOverlay = await ZoAppBlocker.instance.checkOverlayPermission();

  return finalNotify == 'granted' && finalUsage != 'denied' && finalOverlay != 'denied';
}

  Future<void> handleNotificationPermission() async {
    final status = await ZoAppBlocker.instance.checkNotificationPermission();

    if (status != 'granted') {
      await ZoAppBlocker.instance.requestNotificationPermission();
    }
  }

  Future<void> handleUsageStatsandOverlay() async {
    final usage = await ZoAppBlocker.instance.checkUsageStatsPermission();

    if (usage == 'denied') {
      await ZoAppBlocker.instance.requestUsageStatsPermission();
    }

    final overlay = await ZoAppBlocker.instance.checkOverlayPermission();

    if (overlay == 'denied') {
      await ZoAppBlocker.instance.requestOverlayPermission();
    }
  }

  Future<void> configureBackgroundNotification() async {
    await ZoAppBlocker.instance.setNotificationConfig(
      notificationBannerTitle: 'Panic Mode Active',
      notificationBannerDescription: 'Emergency focus session is running',
    );
  }
}

import 'package:dopamind/services/block_service.dart';
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'panic_focus_screen.dart';

class PanicSetupScreen extends StatefulWidget {
  final String taskTitle;
  final List<String> blockedAppsFromTask;

  const PanicSetupScreen({
    super.key,
    required this.taskTitle,
    required this.blockedAppsFromTask,
  });

  @override
  State<PanicSetupScreen> createState() => _PanicSetupScreenState();
}

class _PanicSetupScreenState extends State<PanicSetupScreen> {
  String selectedTime = "30 min";
  List<dynamic> installedApps = [];
  List<String> selectedApps =
      []; // This holds the user's choices live on this screen
  bool isLoadingApps = false;
  final BlockerService _blockerService = BlockerService();
  final TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    taskController.text = widget.taskTitle;

    // 1. Pre-populate your screen's selected list with the apps coming from the task
    selectedApps = List.from(widget.blockedAppsFromTask);

    // _loadDeviceApps();
  }

  // Future<void> _loadDeviceApps() async {
  //   setState(() => isLoadingApps = true);
  //   try {
  //     final apps = await _blockerService.showAppsList();
  //     setState(() {
  //       installedApps = apps;
  //       isLoadingApps = false;
  //     });
  //   } catch (e) {
  //     setState(() => isLoadingApps = false);
  //     print("Error loading apps: $e");
  //   }
  // }

  // void _showAppSelectionSheet() {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  //     ),
  //     builder: (context) {
  //       if (isLoadingApps) {
  //         return const SizedBox(
  //           height: 300,
  //           child: Center(child: CircularProgressIndicator()),
  //         );
  //       }

  //       return AppSelectionBottomSheet(
  //         installedApps: installedApps,
  //         initialSelectedApps: selectedApps,
  //         onAppSelected: (pkgName) {
  //           setState(() {
  //             if (!selectedApps.contains(pkgName)) {
  //               selectedApps.add(pkgName);
  //             }
  //             _blockerService.addToBlacklist(pkgName);
  //           });
  //         },
  //         onAppUnselected: (pkgName) {
  //           setState(() {
  //             selectedApps.remove(pkgName);
  //             _blockerService.removeFromBlacklist(pkgName);
  //           });
  //         },
  //       );
  //     },
  //   );
  // }

  int get durationMinutes {
    switch (selectedTime) {
      case "15 min":
        return 15;
      case "30 min":
        return 30;
      case "1 hour":
        return 60;
      case "2 hours":
        return 120;
      default:
        return 30;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Emergency Focus",
          style: TextStyle(color: AppColors.dark, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header Block
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 85,
                    height: 85,
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      size: 46,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    "Panic Mode",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Forget everything else.\nFocus on this task until it's done.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.flash_on_rounded, color: Colors.orange),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Only this task matters now.",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              "How much time is left?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                timeChip("15 min"),
                timeChip("30 min"),
                timeChip("1 hour"),
                timeChip("2 hours"),
              ],
            ),

            const SizedBox(height: 30),
            const Text(
              "Apps to Block",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),

            // App Selector Tray Button
            InkWell(
              // onTap: _showAppSelectionSheet,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedApps.isEmpty
                          ? "Select apps to restrict..."
                          : "${selectedApps.length} apps selected",
                      style: TextStyle(
                        color: selectedApps.isEmpty
                            ? Colors.grey
                            : AppColors.dark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: AppColors.grey,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              "What must be done?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: taskController,
              readOnly: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Start Session Controller
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  if (taskController.text.isEmpty) return;

                  // 1. Sequentially prompt native system permission checks
                  // await _blockerService.handleNotificationPermission();
                  // await _blockerService.handleUsageStatsandOverlay();
                  // await _blockerService.configureBackgroundNotification();

                  // 2. Ensure service lists sync precisely with what was tapped on this screen
                  await _blockerService.stopLockdown(); // clear tracking states
                  for (var app in selectedApps) {
                    _blockerService.addToBlacklist(app);
                  }

                  // 3. Move forward to active monitor execution
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PanicFocusScreen(
                          taskTitle: taskController.text,
                          totalMinutes: durationMinutes,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow_rounded, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Start Emergency Session",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget timeChip(String value) {
    final selected = selectedTime == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTime = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.dark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

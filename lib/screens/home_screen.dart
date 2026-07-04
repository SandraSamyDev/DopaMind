import 'package:dopamind/services/block_service.dart';
import 'package:dopamind/core/app_colors.dart';
import 'package:dopamind/models/task_model.dart';
import 'package:dopamind/screens/tasks_screens/task_editor_screen.dart';
import 'package:dopamind/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zo_app_blocker/zo_app_blocker.dart';
import '../providers/task_provider.dart';

// Import local sub-widgets
import '../widgets/home_widgets/home_header.dart';
import '../widgets/home_widgets/home_sos_card.dart';
import '../widgets/home_widgets/home_task_list.dart';
import '../widgets/progress_card.dart';

// Import other main screens
import 'analytics_screen.dart';
import 'focus_screen.dart';
import 'auth_screens/profile_screen.dart';
import 'tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  TaskModel? _activeFocusTask;
List<String> _selectedPackagesToBlock = [];
bool _isLockdownCurrentlyActive = false;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<TaskProvider>().listenToTasks();
    });
  }

 void _showAppSelectionBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return FutureBuilder<List<Map<String, dynamic>>>(
        future: ZoAppBlocker.instance.getApps(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 300,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const SizedBox(
              height: 200,
              child: Center(child: Text("Could not retrieve installed applications.")),
            );
          }

          final installedApps = snapshot.data!
            ..sort((a, b) => (a["appName"] ?? "").toString().compareTo((b["appName"] ?? "").toString()));

          return StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                padding: const EdgeInsets.all(16),
                height: MediaQuery.of(context).size.height * 0.75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          // 🧠 Update counter directly from your array length
                          "Select Apps to Block (${_selectedPackagesToBlock.length})",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Done"),
                        ),
                      ],
                    ),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: installedApps.length,
                        itemBuilder: (context, index) {
                          final app = installedApps[index];
                          final String packageName = app["packageName"] ?? "";
                          final String appName = app["appName"] ?? "Unknown App";

                          // Check selection locally against our standard tracking list
                          final isChecked = _selectedPackagesToBlock.contains(packageName);

                          return CheckboxListTile(
                            title: Text(appName),
                            subtitle: Text(
                              packageName,
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                            ),
                            value: isChecked,
                            activeColor: AppColors.primary,
                            onChanged: (bool? checked) async {
                              setModalState(() {
                                if (checked == true) {
                                  _selectedPackagesToBlock.add(packageName);
                                } else {
                                  _selectedPackagesToBlock.remove(packageName);
                                }
                              });
                              
                              // Force update your primary main home screen metrics layout
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}

  // A simple dialog or sheet to let users pick their global distractions
  void showGlobalAppPicker(BuildContext context) async {
    // Fetch installed device applications
    // List apps = await blocker.getInstalledApps();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Scaffold(
              appBar: AppBar(title: const Text("Select Blocked Apps")),
              body: ListView(
                children: [
                  // Loop through your fetched apps here with CheckboxListTile widgets
                  CheckboxListTile(
                    title: const Text("Instagram"),
                    value: true, // check if package is in blocker list
                    onChanged: (bool? checked) {
                      // add or remove from temporary list, then updates blocker
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void startFocusSession(TaskModel targetTask) {
    setState(() {
      _activeFocusTask = targetTask;
      _currentIndex = 1; // Switches to Focus Tab view index
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final myTasks = taskProvider.tasks;
    final int doneTasksCount = myTasks.where((t) => t.isCompleted).length;

    // Fallback: If no task is selected, default to an empty custom session
    // This defaults durationMinutes to 25 as requested if no task modifies it
    final TaskModel fallbackTask = myTasks.firstWhere(
      (t) => !t.isCompleted,
      orElse: () => TaskModel(
        id: "default",
        title: "General Focus Session",
        description: "Stay clear of phone distractions",
        priority: "Medium",
        focusMode: "Deep Work",
        dueDate: DateTime.now(),
        reminder: TimeOfDay.now(),
        subtasks: [],
        durationMinutes: 25, // Standard requirement
        isCompleted: false,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async => await FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeContent(myTasks, doneTasksCount, fallbackTask),

          // Focus screen receives the task context but depends on global blocker states now
          FocusScreen(task: _activeFocusTask ?? fallbackTask),

          const TasksScreen(),
          const AnalyticsScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFECF0F3),
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.secondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.center_focus_strong),
            label: "Focus",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: "Tasks"),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: "Analytics",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildHomeContent(List tasks, int doneCount, TaskModel fallbackTask) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              const SizedBox(height: 20),
              ProgressCard(done: doneCount, total: tasks.length),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "Add Task",
                      icon: Icons.add,
                      backgroundColor: AppColors.primary,
                      textColor: Colors.white,
                      onPressed: () async {
                        final newTask = TaskModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: "",
                          description: "",
                          priority: "High",
                          focusMode: "Deep Work",
                          dueDate: DateTime.now(),
                          reminder: TimeOfDay.now(),
                          subtasks: [],
                          durationMinutes: 30,
                          isCompleted: false,
                        );

                        // await Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => TaskEditorScreen(task: newTask),
                        //   ),
                        // );
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.95,
                              child: TaskEditorScreen(task: newTask),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
  child: CustomButton(
    text: "Block Settings (${_selectedPackagesToBlock.length})",
    icon: Icons.app_blocking,
    backgroundColor: _isLockdownCurrentlyActive
        ? Colors.grey.shade200
        : Colors.grey.shade300,
    textColor: _isLockdownCurrentlyActive
        ? Colors.grey.shade400
        : AppColors.primary,
    onPressed: _isLockdownCurrentlyActive
        ? () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Cannot modify blocked apps while a session is running!"),
              ),
            );
          }
        : () => _showAppSelectionBottomSheet(context),
  ),
),
                ],
              ),
              const HomeSosCard(),
              const SizedBox(height: 20),
              const Text(
                "Your Flow",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              // Pass down callback context switch tracking if HomeTaskList widget supports selection closures
              HomeTaskList(tasks: tasks),
            ],
          ),
        ),
      ),
    );
  }
}

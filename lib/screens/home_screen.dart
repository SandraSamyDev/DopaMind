import 'package:dopamind/core/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../widgets/task_card.dart';
import '../widgets/progress_card.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'task_editor_screen.dart';
import '../screens/task_details_screen.dart';
import 'analytics_screen.dart';
import 'tasks_screen.dart';
import 'focus_screen.dart';
import 'profile_screen.dart';
import 'sos_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<TaskProvider>().listenToTasks();
    });
  }

  String getTodayDate() {
    final now = DateTime.now();
    final formattedDate = DateFormat('MMMM d').format(now);
    return 'Today, $formattedDate';
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeContent(),
          FocusScreen(),
          TasksScreen(), // ليستة التاسكات
          AnalyticsScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFECF0F3),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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

  Widget _buildHomeContent() {
    final taskProvider = context.watch<TaskProvider>();
    final myTasks = taskProvider.tasks;
    // FIX: Using 'isCompleted' to match your model structure parameters
    int done = myTasks.where((t) => t.isCompleted).length;

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header Row
              Row(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 23,
                        backgroundImage: AssetImage(
                          'lib/assets/images/logo2.jpeg',
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "DopaMind",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.notifications_none),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(getTodayDate(), style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),

              ProgressCard(done: done, total: myTasks.length),
              const SizedBox(height: 16),

              /// Action Buttons Row
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
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
                          blockedAppsPackages: [],
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
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        "Add Task",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        // Switch direct index focus tab channel context
                        setState(() => _currentIndex = 1);
                      },
                      icon: const Icon(
                        Icons.play_arrow,
                        color: AppColors.primary,
                      ),
                      label: const Text(
                        "Start Focus",
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 15),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 22,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_outline,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(width: 14),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Feeling overwhelmed?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Take a moment. We'll guide you.",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SosScreen()),
                        );
                      },
                      child: const Text("Help"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Your Flow",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),

              /// Tasks Dynamic Display List
              ListView.builder(
                itemCount: myTasks.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return TaskCard(
                    task: myTasks[index],
                    onTap: () async {
                      final task = myTasks[index];

                      task.isCompleted = !task.isCompleted;

                      if (task.isCompleted) {
                        task.completedAt = DateTime.now();
                      } else {
                        task.completedAt = null;
                      }

                      await context.read<TaskProvider>().updateTask(task);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
} // Properly closing the entire _HomeScreenState scope structure cleanly here!

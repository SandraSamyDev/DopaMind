import 'package:dopamind/screens/tasks_screen.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/analytics_screen.dart';
import '../core/app_colors.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    // FocusScreen(),
    TasksScreen(),
    AnalyticsScreen(),
    // ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.center_focus_strong),
            label: "Focus",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: "Tasks",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: "Insights",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
// import 'package:dopamind/core/app_colors.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../models/task_model.dart';
// import '../widgets/task_card.dart';
// import '../widgets/progress_card.dart';


// List<TaskModel> tasks = []; 

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late List<TaskModel> myTasks;
//   int _currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     myTasks = List.from(tasks); 
//   }

//   String getTodayDate() {
//     final now = DateTime.now();
//     final formattedDate = DateFormat('MMMM d').format(now);
//     return 'Today, $formattedDate';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         actions: [IconButton(onPressed: ()async{
//           await FirebaseAuth.instance.signOut();

//         }, icon: Icon(Icons.exit_to_app)),],
//       ),
//       body: IndexedStack(
//         index: _currentIndex,
//         children: [
//           _buildHomeContent(),
//           const Center(child: Text("Focus Screen")),
//           const Center(child: Text("Tasks Screen")),
//           const Center(child: Text("Profile Screen")),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: const Color(0xFFECF0F3),
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: AppColors.primary,
//         unselectedItemColor: AppColors.secondary,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.center_focus_strong),
//             label: "Focus",
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.checklist), label: "Tasks"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//     );
//   }

//   Widget _buildHomeContent() {
//     // FIX: Using 'isCompleted' to match your model structure parameters
//     int done = myTasks.where((t) => t.isCompleted).length;

//     return SafeArea(
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// Header Row
//               Row(
//                 children: [
//                   Row(
//                     children: [
//                       const CircleAvatar(
//                         radius: 23,
//                         backgroundImage: AssetImage(
//                           'lib/assets/images/logo2.jpeg',
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       const Text(
//                         "DopaMind",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 22,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Spacer(),
//                   const Icon(Icons.notifications_none),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 "Welcome",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               Text(getTodayDate(), style: const TextStyle(color: Colors.grey)),
//               const SizedBox(height: 20),
              
//               ProgressCard(done: done, total: myTasks.length),
//               const SizedBox(height: 16),

//               /// Action Buttons Row
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primary,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                       ),
//                       onPressed: () {
//                       },
//                       icon: const Icon(Icons.add, color: Colors.white),
//                       label: const Text(
//                         "Add Task",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.grey.shade300,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                       ),
//                       onPressed: () {
//                         // Switch direct index focus tab channel context
//                         setState(() => _currentIndex = 1);
//                       },
//                       icon: const Icon(
//                         Icons.play_arrow,
//                         color: AppColors.primary,
//                       ),
//                       label: const Text(
//                         "Start Focus",
//                         style: TextStyle(color: AppColors.primary),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 "Your Flow",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               const SizedBox(height: 8),

//               /// Tasks Dynamic Display List
//               ListView.builder(
//                 itemCount: myTasks.length,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   return TaskCard(
//                     task: myTasks[index],
//                     onTap: () {
//                       setState(() {
//                         // Clean toggle option modification pattern on instances 
//                         myTasks[index].isCompleted = !myTasks[index].isCompleted;
//                       });
//                     },
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// } // Properly closing the entire _HomeScreenState scope structure cleanly here!
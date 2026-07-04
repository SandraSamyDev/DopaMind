import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  String _getTodayDate() {
    final formattedDate = DateFormat('MMMM d').format(DateTime.now());
    return 'Today, $formattedDate';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 23,
              backgroundImage: AssetImage('lib/assets/images/logo2.jpeg'),
            ),
            const SizedBox(width: 8),
            const Text(
              "DopaMind",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Welcome",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(_getTodayDate(), style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
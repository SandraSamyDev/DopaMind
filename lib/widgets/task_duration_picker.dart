import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskDurationPicker extends StatelessWidget {
  final Duration initialDuration;
  final ValueChanged<Duration> onDurationChanged;

  const TaskDurationPicker({
    super.key,
    required this.initialDuration,
    required this.onDurationChanged,
  });

  @override
  Widget build(BuildContext context) {
    Duration selectedDuration = initialDuration;

    return Container(
      height: 300,
      color: Colors.white,
      child: Column(
        children: [
          // Header Bar with Done Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Select Task Duration",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    onDurationChanged(selectedDuration);
                    Navigator.pop(context);
                  },
                  child: const Text("Done", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          // Scrollable Picker Wheels
          Expanded(
            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.hm, // Hours and Minutes
              initialTimerDuration: initialDuration,
              onTimerDurationChanged: (Duration duration) {
                selectedDuration = duration;
              },
            ),
          ),
        ],
      ),
    );
  }
}
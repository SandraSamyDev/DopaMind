import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class TaskButton extends StatefulWidget {
  final bool isCompleted;
  final VoidCallback onTap;
  const TaskButton({super.key, required this.isCompleted, required this.onTap});

  @override
  State<TaskButton> createState() => _TaskButtonState();
}

class _TaskButtonState extends State<TaskButton> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.isCompleted
              ? [Colors.green, Colors.greenAccent]
              : [AppColors.primary, AppColors.progressValue],
        ),
        boxShadow: [
          BoxShadow(
            color: (widget.isCompleted ? Colors.green : AppColors.primary)
                .withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isPressed ? Colors.white : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: widget.onTap,
          onHighlightChanged: (value) {
            setState(() {
              isPressed = value;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check, size: 18, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  widget.isCompleted ? "Task Completed" : "Mark as Completed",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

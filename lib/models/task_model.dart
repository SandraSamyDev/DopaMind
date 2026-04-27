class Task {
  final String title;
  final int totalSteps;
  final int completedSteps;
  final String priority;
  final bool isDone;
  final String? time;

  Task({
    required this.title,
    required this.totalSteps,
    required this.completedSteps,
    required this.priority,
    this.isDone = false,
    this.time,
  });

  double get progress => totalSteps == 0 ? 0 : completedSteps / totalSteps;
}

final List<Task> tasks = [
  Task(
    title: "Study Flutter",
    totalSteps: 4,
    completedSteps: 2,
    priority: "HIGH",
  ),
  Task(
    title: "UI Design Polish",
    totalSteps: 1,
    completedSteps: 0,
    priority: "MEDIUM",
  ),
  Task(
    title: "Mindfulness Session",
    totalSteps: 1,
    completedSteps: 1,
    priority: "LOW",
    isDone: true,
    time: "08:30 AM",
  ),
];

class TaskGenerator {
  static List<Map<String, dynamic>> generate({
    required String title,
    required String energy,
    required String detail,
    required int durationMinutes,
  }) {
    final task = title.toLowerCase();

    List<String> generatedSteps = [];

    // =========================
    // Flutter / Programming
    // =========================
    if (task.contains("flutter") ||
        task.contains("app") ||
        task.contains("coding") ||
        task.contains("project") ||
        task.contains("dart") ||
        task.contains("bug") ||
        task.contains("feature")) {
      generatedSteps = [
        "Understand requirements",
        "Review existing code",
        "Plan implementation",
        "Create widgets",
        "Write business logic",
        "Connect backend",
        "Handle edge cases",
        "Test functionality",
        "Fix bugs",
        "Refactor code",
        "Optimize performance",
        "Commit changes",
      ];
    }
    // =========================
    // Study / Exams
    // =========================
    else if (task.contains("study") ||
        task.contains("exam") ||
        task.contains("lecture") ||
        task.contains("revision") ||
        task.contains("chapter") ||
        task.contains("course")) {
      generatedSteps = [
        "Prepare study materials",
        "Read chapter overview",
        "Study first section",
        "Take notes",
        "Highlight key concepts",
        "Study second section",
        "Solve exercises",
        "Review mistakes",
        "Create summary",
        "Memorize important points",
        "Self-test",
        "Final revision",
      ];
    }
    // =========================
    // Reading Books
    // =========================
    else if (task.contains("book") ||
        task.contains("read") ||
        task.contains("reading") ||
        task.contains("novel")) {
      generatedSteps = [
        "Prepare reading environment",
        "Read introduction",
        "Read first section",
        "Highlight interesting ideas",
        "Take quick notes",
        "Read next section",
        "Reflect on key points",
        "Summarize what was learned",
      ];
    }
    // =========================
    // AI / Machine Learning
    // =========================
    else if (task.contains("ai") ||
        task.contains("machine learning") ||
        task.contains("ml") ||
        task.contains("deep learning") ||
        task.contains("chatgpt") ||
        task.contains("llm")) {
      generatedSteps = [
        "Define learning goal",
        "Read AI concepts",
        "Study examples",
        "Watch tutorial",
        "Take notes",
        "Build small project",
        "Experiment with model",
        "Analyze results",
        "Improve implementation",
        "Document learnings",
      ];
    }
    // =========================
    // UI / UX / Figma
    // =========================
    else if (task.contains("design") ||
        task.contains("ui") ||
        task.contains("ux") ||
        task.contains("figma")) {
      generatedSteps = [
        "Research inspiration",
        "Analyze references",
        "Create wireframe",
        "Design layout",
        "Choose colors",
        "Select typography",
        "Build components",
        "Check consistency",
        "Review UX flow",
        "Finalize design",
      ];
    }
    // =========================
    // Writing
    // =========================
    else if (task.contains("report") ||
        task.contains("article") ||
        task.contains("essay") ||
        task.contains("write") ||
        task.contains("blog")) {
      generatedSteps = [
        "Research topic",
        "Collect references",
        "Create outline",
        "Write introduction",
        "Write main content",
        "Add supporting examples",
        "Write conclusion",
        "Proofread",
        "Improve wording",
        "Finalize draft",
      ];
    }
    // =========================
    // Presentation
    // =========================
    else if (task.contains("presentation") ||
        task.contains("ppt") ||
        task.contains("slides")) {
      generatedSteps = [
        "Define presentation goal",
        "Collect content",
        "Create outline",
        "Design slides",
        "Add visuals",
        "Review structure",
        "Practice presentation",
        "Finalize slides",
      ];
    }
    // =========================
    // Gym / Fitness
    // =========================
    else if (task.contains("gym") ||
        task.contains("workout") ||
        task.contains("exercise") ||
        task.contains("fitness")) {
      generatedSteps = [
        "Warm up",
        "Prepare workout plan",
        "Complete first exercise",
        "Complete strength exercises",
        "Complete cardio session",
        "Stretch muscles",
        "Track progress",
      ];
    }
    // =========================
    // Generic Tasks
    // =========================
    else {
      generatedSteps = [
        "Understand the task",
        "Gather resources",
        "Create plan",
        "Start first step",
        "Continue progress",
        "Review results",
        "Fix issues",
        "Finalize work",
      ];
    }

    // =========================
    // Energy Filter
    // =========================

    if (energy == "Low") {
      if (generatedSteps.length > 3) {
        generatedSteps = generatedSteps.take(3).toList();
      }
    } else if (energy == "Medium") {
      if (generatedSteps.length > 6) {
        generatedSteps = generatedSteps.take(6).toList();
      }
    }

    // =========================
    // Time Filter
    // =========================

    int maxSteps;

    if (durationMinutes <= 15) {
      maxSteps = 2;
    } else if (durationMinutes <= 30) {
      maxSteps = 4;
    } else if (durationMinutes <= 60) {
      maxSteps = 6;
    } else if (durationMinutes <= 120) {
      maxSteps = 8;
    } else {
      maxSteps = generatedSteps.length;
    }

    generatedSteps = generatedSteps.take(maxSteps).toList();

    // =========================
    // Detail Filter
    // =========================
    if (detail == "Simple") {
      generatedSteps = generatedSteps
          .take((generatedSteps.length / 2).ceil())
          .toList();
    }
    if (detail == "Detailed") {
      generatedSteps.addAll([
        "Quality Check",
        "Review Progress",
        "Optimization",
      ]);
    }

    return generatedSteps
        .map((step) => {"title": step, "done": false})
        .toList();
  }
}

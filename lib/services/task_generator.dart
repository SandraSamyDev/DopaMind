import 'dart:convert';
import 'package:firebase_ai/firebase_ai.dart';

class TaskGenerator {
  static Future<List<Map<String, dynamic>>> generate({
    required String title,
    required String energy,
    required String detail,
    required int durationMinutes,
  }) async {
    try {
      // 1. Initialize through Firebase instead of an explicit API key string!
      final model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-3.5-flash', 
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json', // Forces Gemini to output pure json syntax
        ),
      );

      // 2. Keep your highly structured operational prompt
      final prompt = '''
You are an expert executive functioning assistant. Break down this task into ultra-actionable subtasks.
Task: "$title"
User Energy Level: $energy (Tailor complexity to match this energy)
Detail Level Required: $detail
Target Total Duration: $durationMinutes minutes

Return exactly a JSON array containing maps with a single key "title".

Example structure:
[{"title": "First actionable step"}, {"title": "Second actionable step"}]
''';

      // 3. Dispatch the call directly through Firebase's endpoint routes
      final response = await model.generateContent([Content.text(prompt)]);
      final cleanText = response.text?.trim() ?? "[]";

      // 4. Decode the result safely
      final List<dynamic> decoded = jsonDecode(cleanText);
      
      return decoded.map((item) => {
        "title": item["title"]?.toString() ?? "Untitled Step",
        "done": false,
      }).toList();

    } catch (e, stackTrace) {
      // Logging remains safe since there are no secure keys to output here!
      print(" Firebase AI Task Generation Failed: $e");
      print(" Stacktrace: $stackTrace");
      
      return [
        {"title": "Break down target objective manually", "done": false},
        {"title": "Review initial parameters", "done": false},
      ];
    }
  }
}
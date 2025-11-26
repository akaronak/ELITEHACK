import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_pregnancy.dart';
import '../models/daily_log.dart';
import '../models/checklist_status.dart';

class ApiService {
  // Android emulator uses 10.0.2.2 to access host machine's localhost
  // This works consistently without needing to change IP addresses
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  // User Pregnancy Profile
  Future<UserPregnancy?> getPregnancyProfile(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/$userId/pregnancy'),
      );

      if (response.statusCode == 200) {
        return UserPregnancy.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Error fetching pregnancy profile: $e');
      return null;
    }
  }

  Future<bool> createOrUpdatePregnancyProfile(UserPregnancy profile) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/${profile.userId}/pregnancy'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(profile.toJson()),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error creating/updating pregnancy profile: $e');
      return false;
    }
  }

  // Weekly Progress
  Future<Map<String, dynamic>?> getWeekProgress(String userId, int week) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/progress/$userId/week/$week'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching week progress: $e');
      return null;
    }
  }

  // Daily Logs
  Future<bool> addDailyLog(DailyLog log) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logs/${log.userId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(log.toJson()),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error adding daily log: $e');
      return false;
    }
  }

  Future<List<DailyLog>> getDailyLogs(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/logs/$userId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => DailyLog.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching daily logs: $e');
      return [];
    }
  }

  // AI Symptom Analysis
  Future<Map<String, dynamic>?> analyzeSymptoms({
    required String userId,
    required List<String> symptoms,
    required int week,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ai/symptom-analysis'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'symptoms': symptoms,
          'week': week,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error analyzing symptoms: $e');
      return null;
    }
  }

  // Nutrition
  Future<Map<String, dynamic>?> getNutritionRecommendations(
    String userId,
    int week,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/nutrition/$userId/$week'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching nutrition recommendations: $e');
      return null;
    }
  }

  // Checklist
  Future<List<ChecklistStatus>> getChecklist(String userId, int week) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/checklist/$userId/$week'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ChecklistStatus.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching checklist: $e');
      return [];
    }
  }

  Future<bool> updateChecklistTask(ChecklistStatus status) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/checklist/${status.userId}/${status.week}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(status.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating checklist task: $e');
      return false;
    }
  }

  // AI Chat
  Future<String?> sendChatMessage({
    required String userId,
    required String message,
    Map<String, dynamic>? context,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ai/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'message': message,
          'context': context,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'];
      }
      return null;
    } catch (e) {
      print('Error sending chat message: $e');
      return null;
    }
  }

  // Menstruation Tracker
  Future<bool> addMenstruationLog(Map<String, dynamic> log) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/menstruation/${log['user_id']}/log'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(log),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error adding menstruation log: $e');
      return false;
    }
  }

  Future<List<dynamic>> getMenstruationLogs(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/menstruation/$userId/logs'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Error fetching menstruation logs: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getMenstruationPredictions(
    String userId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/menstruation/$userId/predictions'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching predictions: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getMenstruationStats(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/menstruation/$userId/stats'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching stats: $e');
      return null;
    }
  }

  // Menopause Tracker
  Future<bool> addMenopauseLog(Map<String, dynamic> log) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/menopause/${log['user_id']}/log'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(log),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error adding menopause log: $e');
      return false;
    }
  }

  Future<List<dynamic>> getMenopauseLogs(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/menopause/$userId/logs'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Error fetching menopause logs: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> generateMenopauseReport(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/menopause/$userId/generate-report'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error generating report: $e');
      return null;
    }
  }

  // Breathing Game
  Future<Map<String, dynamic>?> getBreathingGameStats(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/breathing/game/$userId'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching breathing game stats: $e');
      return null;
    }
  }

  Future<bool> updateBreathingGameSession({
    required String userId,
    required int duration,
    required bool completed,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/breathing/game/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'duration': duration,
          'completed': completed,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating breathing game session: $e');
      return false;
    }
  }

  // Menstruation AI Chat
  Future<String?> sendMenstruationChatMessage({
    required String userId,
    required String message,
    List<Map<String, dynamic>>? history,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ai/chat/menstruation'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'message': message,
          'history': history ?? [],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'];
      } else if (response.statusCode == 500) {
        final data = jsonDecode(response.body);
        return data['fallback'];
      }
      return null;
    } catch (e) {
      print('Error sending menstruation chat message: $e');
      return 'Sorry, I\'m having trouble connecting. Please check your internet connection and try again.';
    }
  }

  // Menopause AI Chat
  Future<String?> sendMenopauseChatMessage({
    required String userId,
    required String message,
    List<Map<String, dynamic>>? history,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ai/chat/menopause'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'message': message,
          'history': history ?? [],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'];
      } else if (response.statusCode == 500) {
        final data = jsonDecode(response.body);
        return data['fallback'];
      }
      return null;
    } catch (e) {
      print('Error sending menopause chat message: $e');
      return 'Sorry, I\'m having trouble connecting. Please check your internet connection and try again.';
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:event_manager/utils/session_manager.dart';

class ApiService {
  static const String _baseUrl = 'http://103.160.63.165/api';

  // Helper untuk mendapatkan header, termasuk token jika ada
  static Future<Map<String, String>> _getHeaders() async {
    String? token = await SessionManager.getToken();
    if (token != null) {
      return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
    }
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // API untuk Login
  static Future<Map<String, dynamic>> login(String studentNumber, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'student_number': studentNumber,
        'password': password,
      }),
    );
    return jsonDecode(response.body);
  }

  // API untuk Register
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String studentNumber,
    required String major,
    required int classYear,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'name': name,
        'email': email,
        'student_number': studentNumber,
        'major': major,
        'class_year': classYear,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );
    return jsonDecode(response.body);
  }

  // API untuk mendapatkan daftar event
  static Future<Map<String, dynamic>> getEvents() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/events'),
      headers: await _getHeaders(),
    );
    return jsonDecode(response.body);
  }

  // API untuk membuat event baru
  static Future<Map<String, dynamic>> createEvent({
    required String title,
    required String description,
    required String location,
    required String category,
    required String startDate,
    required String endDate,
    required int price,
    required int maxAttendees,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/events'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'title': title,
        'description': description,
        'location': location,
        'category': category,
        'start_date': startDate,
        'end_date': endDate,
        'price': price,
        'max_attendees': maxAttendees,
      }),
    );
    return jsonDecode(response.body);
  }
}
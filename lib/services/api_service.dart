import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Для iOS и Web
  static const String baseUrl = 'http://localhost:8080/api/users';

  // Проверка статуса авторизации
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user');

      if (userData != null && userData.isNotEmpty) {
        // Проверяем, что данные пользователя валидны
        final user = jsonDecode(userData);
        return user['email'] != null && user['email'].isNotEmpty;
      }
      return false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  // Получение данных пользователя
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user');

      if (userData != null && userData.isNotEmpty) {
        return jsonDecode(userData);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Регистрация
  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Регистрация успешна ✅'};
      } else {
        return {
          'success': false,
          'message': 'Ошибка регистрации ❌: ${response.body}'
        };
      }
    } catch (e) {
      print('Exception: $e');
      return {'success': false, 'message': 'Ошибка сети или сервера ❌'};
    }
  }

  // Логин
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Login status: ${response.statusCode}, body: ${response.body}');

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        // Сохраняем данные пользователя
        final userData = {
          'email': email,
          'loginTime': DateTime.now().toIso8601String(),
        };
        await prefs.setString('user', jsonEncode(userData));
        return true;
      }
      return false;
    } catch (e) {
      print('Login exception: $e');
      return false;
    }
  }

  // Логаут
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // 🚀 ЗАМЕНИТЕ НА ВАШ RAILWAY URL ПОСЛЕ ДЕПЛОЯ
  // Пример: https://smileproiz-production.up.railway.app
  static const String baseUrl =
      'smileproiz-production.up.railway.app/api/users';

  // Таймаут для запросов
  static const Duration timeout = Duration(seconds: 10);

  // Проверка статуса авторизации
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user');

      if (userData != null && userData.isNotEmpty) {
        final user = jsonDecode(userData);
        return user['email'] != null && user['email'].isNotEmpty;
      }
      return false;
    } catch (e) {
      print('❌ Error checking login status: $e');
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
      print('❌ Error getting user data: $e');
      return null;
    }
  }

  // Регистрация
  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      print('📤 Регистрация: $email');

      final response = await http
          .post(
            Uri.parse('$baseUrl/register'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(timeout);

      print('📥 Status: ${response.statusCode}');
      print('📥 Response: ${response.body}');

      if (response.statusCode == 200) {
        // Автоматически логинимся после регистрации
        await login(email, password);

        return {'success': true, 'message': 'Регистрация успешна ✅'};
      } else if (response.statusCode == 400) {
        return {
          'success': false,
          'message': 'Пользователь с таким email уже существует',
        };
      } else {
        return {
          'success': false,
          'message': 'Ошибка регистрации: ${response.statusCode}',
        };
      }
    } on http.ClientException catch (e) {
      print('❌ Network error: $e');
      return {
        'success': false,
        'message': 'Ошибка сети. Проверьте подключение к интернету',
      };
    } catch (e) {
      print('❌ Exception: $e');
      return {'success': false, 'message': 'Ошибка: ${e.toString()}'};
    }
  }

  // Логин
  Future<bool> login(String email, String password) async {
    try {
      print('📤 Логин: $email');

      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(timeout);

      print('📥 Login status: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Сохраняем данные пользователя
        final prefs = await SharedPreferences.getInstance();
        final userData = {
          'email': email,
          'loginTime': DateTime.now().toIso8601String(),
        };
        await prefs.setString('user', jsonEncode(userData));

        print('✅ Логин успешен');
        return true;
      }

      print('❌ Неверные учетные данные');
      return false;
    } on http.ClientException catch (e) {
      print('❌ Network error: $e');
      return false;
    } catch (e) {
      print('❌ Login exception: $e');
      return false;
    }
  }

  // Логаут
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
      print('✅ Логаут успешен');
    } catch (e) {
      print('❌ Logout error: $e');
    }
  }

  // Проверка доступности API
  Future<bool> checkApiHealth() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/test'))
          .timeout(timeout);

      return response.statusCode == 200;
    } catch (e) {
      print('❌ API недоступен: $e');
      return false;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static String? token;

  static const baseUrl = "http://10.0.2.2:5000";

  

  static Future<void> saveToken(String jwtToken) async {
    token = jwtToken;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", jwtToken);
  }

  static Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
  }

  static Future<void> logout() async {
    token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }

  

  static Future<Map?> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email.trim(), "password": password.trim()}),
      );

      return jsonDecode(res.body);
    } catch (e) {
      print("Login Error : $e");
      return null;
    }
  }

  

  static Future<Map?> adminLogin(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/admin/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email.trim(), "password": password.trim()}),
      );

      print("Admin Login Status = ${res.statusCode}");
      print("Admin Login Response = ${res.body}");

      return jsonDecode(res.body);
    } catch (e) {
      print("Admin Login Error : $e");
      return null;
    }
  }

  

  static Future<List> getEvents() async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/events"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  

  static Future<bool> signup(Map data) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  

  static Future<bool> addEvent(Map data) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/events"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode(data),
      );

      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      return false;
    }
  }



  static Future<bool> updateEvent(String id, Map data) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/events/$id"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode(data),
      );

      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  

  static Future<bool> deleteEvent(String id) async {
    try {
      final res = await http.delete(
        Uri.parse("$baseUrl/events/$id"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }


  static Future<bool> registerForEvent(String eventId, Map data) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/events/$eventId/register"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode(data),
      );

      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      return false;
    }
  }



 static Future<List> getMyRegisteredEvents() async {
  try {
    print("Token = $token");

    final res = await http.get(
      Uri.parse("$baseUrl/my-events"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    print("Status = ${res.statusCode}");
    print("Body = ${res.body}");

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }

    return [];
  } catch (e) {
    print("My Events Error = $e");
    return [];
  }
}
}

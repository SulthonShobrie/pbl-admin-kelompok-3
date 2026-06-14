// lib/services/api_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:hit_api/models/api_models.dart';

class ApiService {
  static String get _baseKarlearn =>
      dotenv.get('BASE_URL', fallback: 'https://be.karlearn.site');
  static String get _baseMahasiswa => dotenv.get(
    'BASE_URL_MAHASISWA',
    fallback: 'https://api-mahasiswa-4a.akufarish.my.id:8874',
  );

  String? _token;

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  void setToken(String token) => _token = token;
  void clearToken() => _token = null;
  bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // Safe JSON List Parser
  List<dynamic> _safeListFromJson(dynamic json) {
    if (json == null) return [];
    if (json is List) return json;
    if (json is Map) {
      if (json.containsKey('data') && json['data'] is List) return json['data'];
      if (json.containsKey('results') && json['results'] is List)
        return json['results'];
    }
    return [];
  }

  // =====================
  // KELOMPOK 1 - AUTH
  // =====================
  Future<LoginResponse?> loginKarlearn(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseKarlearn/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print("Login response ${res.body}");
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        // Jika response dibungkus data
        final data = json['data'] ?? json;
        final loginRes = LoginResponse.fromJson(data);
        setToken(loginRes.token);
        return loginRes;
      }
      return null;
    } catch (e) {
      debugPrint('Error Login: $e');
      return null;
    }
  }

  // =====================
  // KELOMPOK 3 - MAHASISWA
  // =====================
  Future<List<Mahasiswa>> getMahasiswa() async {
    try {
      final res = await http.get(
        Uri.parse('$_baseMahasiswa/api/mahasiswa'),
        headers: _headers,
      );
      if (res.statusCode == 200) {
        if (res.body.isEmpty) return [];
        final json = jsonDecode(res.body);
        final list = _safeListFromJson(json);
        return list.map((e) => Mahasiswa.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error Get Mahasiswa: $e');
      return [];
    }
  }
}

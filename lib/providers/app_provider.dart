// lib/providers/app_provider.dart
import 'package:flutter/foundation.dart';
import 'package:hit_api/models/api_models.dart';
import 'package:hit_api/services/api_service.dart';

class AppProvider with ChangeNotifier {
  final ApiService _api = ApiService();

  bool isLoading = false;
  String? errorMsg;

  List<Mahasiswa> mahasiswaList = [];
  List<Prodi> prodiList = []; // Tambahan penampung data Prodi

  String? loggedInNama;
  bool get isLoggedIn => _api.isLoggedIn;

  // ============ AUTH (LOGIN & LOGOUT) ============
  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMsg = null;
    notifyListeners();
    try {
      final res = await _api.loginKarlearn(email, password);
      if (res != null) {
        loggedInNama = res.nama;
        return true;
      }
      errorMsg = "Login gagal. Periksa email dan password.";
      return false;
    } catch (e) {
      errorMsg = "Terjadi kesalahan server.";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _api.clearToken();
    loggedInNama = null;
    mahasiswaList.clear();
    prodiList.clear(); // Bersihkan list prodi saat logout
    notifyListeners();
  }

  // ============ MAHASISWA ============
  Future<void> fetchMahasiswa() async {
    isLoading = true;
    notifyListeners();
    try {
      mahasiswaList = await _api.getMahasiswa();
    } catch (e) {
      debugPrint("Provider Error fetchMahasiswa: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ============ PRODI ============
  Future<void> fetchProdi() async {
    try {
      prodiList = await _api.getProdi();
      notifyListeners();
    } catch (e) {
      debugPrint("Provider Error fetchProdi: $e");
    }
  }

  // Helper untuk mendapatkan nama Prodi berdasarkan ID
  String getNamaProdi(String id) {
    if (id.isEmpty || id == '0') return '-';
    final prodi = prodiList.where((p) => p.prodiId == id).firstOrNull;
    return prodi?.namaProdi ?? '-';
  }
}

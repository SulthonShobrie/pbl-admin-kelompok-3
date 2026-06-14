// lib/models/api_models.dart

class LoginResponse {
  final String token;
  final String userId;
  final String nama;
  LoginResponse({
    required this.token,
    required this.userId,
    required this.nama,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? json['access_token'] ?? '',
      userId: json['id']?.toString() ?? json['user_id']?.toString() ?? '',
      nama: json['nama'] ?? json['name'] ?? json['username'] ?? '',
    );
  }
}

// Sub-Model untuk Biodata
class Biodata {
  final String jenisKelamin;
  final String tempatLahir;
  final String tanggalLahir;
  final String agama;
  final String noHp;
  final String emailPribadi;

  Biodata.fromJson(Map<String, dynamic> json)
    : jenisKelamin = json['jenis_kelamin']?.toString() ?? '-',
      tempatLahir = json['tempat_lahir']?.toString() ?? '-',
      tanggalLahir = json['tanggal_lahir']?.toString() ?? '-',
      agama = json['agama']?.toString() ?? '-',
      noHp = json['no_hp']?.toString() ?? '-',
      emailPribadi = json['email_pribadi']?.toString() ?? '-';
}

// Sub-Model untuk Alamat
class Alamat {
  final String alamatDomisili;
  final String rtDomisili;
  final String rwDomisili;
  final String kelurahanDomisili;
  final String kodePosDomisili;

  Alamat.fromJson(Map<String, dynamic> json)
    : alamatDomisili = json['alamat_domisili']?.toString() ?? '-',
      rtDomisili = json['rt_domisili']?.toString() ?? '-',
      rwDomisili = json['rw_domisili']?.toString() ?? '-',
      kelurahanDomisili = json['kelurahan_domisili']?.toString() ?? '-',
      kodePosDomisili = json['kode_pos_domisili']?.toString() ?? '-';
}

// Sub-Model untuk Orang Tua Wali
class OrangTuaWali {
  final String jenisPeran;
  final String namaLengkap;
  final String pekerjaan;
  final String noTelepon;

  OrangTuaWali.fromJson(Map<String, dynamic> json)
    : jenisPeran = json['jenis_peran']?.toString() ?? '-',
      namaLengkap = json['nama_lengkap']?.toString() ?? '-',
      pekerjaan = json['pekerjaan']?.toString() ?? '-',
      noTelepon = json['no_telepon']?.toString() ?? '-';
}

class Mahasiswa {
  final String id;
  final String nim;
  final String nama;
  final String prodiId;
  final String tahunAkademikId;
  final String status;

  // Objek Bersarang (Nested Objects)
  final Biodata? biodata;
  final Alamat? alamat;
  final List<OrangTuaWali> orangTuaWali;

  Mahasiswa({
    required this.id,
    required this.nim,
    required this.nama,
    required this.prodiId,
    required this.tahunAkademikId,
    required this.status,
    this.biodata,
    this.alamat,
    required this.orangTuaWali,
  });

  // HELPER MAPPING ANGKATAN (Jika API tahun akademik mengembalikan ID berupa angka)
  String get tahunAngkatan {
    if (tahunAkademikId.length >= 4) return tahunAkademikId;
    switch (tahunAkademikId) {
      case '1':
        return '2020';
      case '2':
        return '2021';
      case '3':
        return '2022';
      case '4':
        return '2023';
      case '5':
        return '2024';
      default:
        return '-';
    }
  }

  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    String rawId =
        json['id_mahasiswa']?.toString() ?? json['id']?.toString() ?? '0';

    // Parsing list orang tua wali
    List<OrangTuaWali> listOrtu = [];
    if (json['orang_tua_wali'] != null && json['orang_tua_wali'] is List) {
      listOrtu = (json['orang_tua_wali'] as List)
          .map((i) => OrangTuaWali.fromJson(i))
          .toList();
    }

    return Mahasiswa(
      id: rawId,
      nim: json['nim']?.toString() ?? '',
      nama:
          json['nama_mahasiswa']?.toString() ??
          json['nama']?.toString() ??
          'Tanpa Nama',
      prodiId: json['prodi_id']?.toString() ?? '0',
      tahunAkademikId: json['tahunakademik_id']?.toString() ?? '0',
      status: json['status']?.toString() ?? 'Aktif',
      biodata: json['biodata'] != null
          ? Biodata.fromJson(json['biodata'])
          : null,
      alamat: json['alamat'] != null ? Alamat.fromJson(json['alamat']) : null,
      orangTuaWali: listOrtu,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_mahasiswa": id,
      "nim": nim,
      "nama_mahasiswa": nama,
      "prodi_id": prodiId,
      "tahunakademik_id": tahunAkademikId,
      "status": status,
    };
  }
}

// Model Baru untuk menampung data dari endpoint /api/prodi Kelompok 4
class Prodi {
  final String prodiId;
  final String namaProdi;

  Prodi({required this.prodiId, required this.namaProdi});

  factory Prodi.fromJson(Map<String, dynamic> json) {
    return Prodi(
      prodiId: json['prodi_id']?.toString() ?? '',
      namaProdi: json['nama_prodi']?.toString() ?? '-',
    );
  }
}

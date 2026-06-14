// lib/screens/detail_mahasiswa_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hit_api/providers/app_provider.dart';
import 'package:hit_api/models/api_models.dart';

class DetailMahasiswaScreen extends StatelessWidget {
  final Mahasiswa mahasiswa;

  const DetailMahasiswaScreen({super.key, required this.mahasiswa});

  @override
  Widget build(BuildContext context) {
    // Memanggil provider untuk menerjemahkan ID Prodi menjadi Nama Prodi
    final prov = context.read<AppProvider>();
    String namaProdi = prov.getNamaProdi(mahasiswa.prodiId);

    bool isAktif = mahasiswa.status.toLowerCase() == "aktif";

    // Ambil data Biodata & Alamat (Jika null, beri nilai fallback)
    final biodata = mahasiswa.biodata;
    final alamat = mahasiswa.alamat;

    // Mencari data Ayah dan Ibu dari list Orang Tua
    final ayah = mahasiswa.orangTuaWali
        .where((o) => o.jenisPeran.toLowerCase() == 'ayah')
        .firstOrNull;
    final ibu = mahasiswa.orangTuaWali
        .where((o) => o.jenisPeran.toLowerCase() == 'ibu')
        .firstOrNull;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Detail Mahasiswa",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section (Blue Background & Profile Card)
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E3A8A),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('assets/images/logo.png'),
                          backgroundColor: Colors.transparent,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          mahasiswa.nama,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "NIM: ${mahasiswa.nim.isEmpty ? "-" : mahasiswa.nim}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "Prodi: $namaProdi", // Menggunakan nama prodi dinamis
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "Angkatan: ${mahasiswa.tahunAngkatan}", // Menambahkan angkatan
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isAktif
                                ? Colors.green.shade50
                                : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isAktif ? Colors.green : Colors.red,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            mahasiswa.status.toUpperCase(),
                            style: TextStyle(
                              color: isAktif ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Content Sections DENGAN DATA ASLI DARI API
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildSectionCard("Identitas Diri", [
                    _buildDataRow(
                      "Email Pribadi",
                      biodata?.emailPribadi ?? "-",
                    ),
                    _buildDataRow(
                      "Tempat, Tanggal Lahir",
                      "${biodata?.tempatLahir ?? '-'}, ${biodata?.tanggalLahir ?? '-'}",
                    ),
                    _buildDataRow(
                      "Jenis Kelamin",
                      biodata?.jenisKelamin ?? "-",
                    ),
                    _buildDataRow("Agama", biodata?.agama ?? "-"),
                  ]),
                  _buildSectionCard("Alamat", [
                    _buildDataRow(
                      "Jalan Domisili",
                      alamat?.alamatDomisili ?? "-",
                    ),
                    _buildDataRow(
                      "RT/RW Domisili",
                      "${alamat?.rtDomisili ?? '-'}/${alamat?.rwDomisili ?? '-'}",
                    ),
                    _buildDataRow(
                      "Kelurahan",
                      alamat?.kelurahanDomisili ?? "-",
                    ),
                    _buildDataRow("Kode Pos", alamat?.kodePosDomisili ?? "-"),
                  ]),
                  _buildSectionCard("Kontak", [
                    _buildDataRow("No. Handphone", biodata?.noHp ?? "-"),
                  ]),
                  _buildSectionCard("Orang Tua / Wali", [
                    _buildDataRow("Nama Ayah", ayah?.namaLengkap ?? "-"),
                    _buildDataRow("Pekerjaan Ayah", ayah?.pekerjaan ?? "-"),
                    _buildDataRow("No. HP Ayah", ayah?.noTelepon ?? "-"),
                    const Divider(height: 30),
                    _buildDataRow("Nama Ibu", ibu?.namaLengkap ?? "-"),
                    _buildDataRow("Pekerjaan Ibu", ibu?.pekerjaan ?? "-"),
                    _buildDataRow("No. HP Ibu", ibu?.noTelepon ?? "-"),
                  ]),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: const Color(0xFF1E3A8A),
          collapsedIconColor: Colors.grey,
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const Divider(height: 15, thickness: 0.5),
        ],
      ),
    );
  }
}

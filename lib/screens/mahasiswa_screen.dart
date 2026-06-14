// lib/screens/mahasiswa_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'detail_mahasiswa_screen.dart';

class MahasiswaScreen extends StatefulWidget {
  const MahasiswaScreen({super.key});

  @override
  State<MahasiswaScreen> createState() => _MahasiswaScreenState();
}

class _MahasiswaScreenState extends State<MahasiswaScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  String? _selectedAngkatan;
  String? _selectedProdi; // Sekarang akan menyimpan prodiId
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        // Memanggil data prodi dan mahasiswa secara bersamaan
        context.read<AppProvider>().fetchProdi();
        context.read<AppProvider>().fetchMahasiswa();
      }
    });
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterModal(BuildContext context) {
    String? tempAngkatan = _selectedAngkatan;
    String? tempProdi = _selectedProdi;
    String? tempStatus = _selectedStatus;

    // Ambil list prodi dinamis dari provider
    final prodiList = context.read<AppProvider>().prodiList;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Filter Mahasiswa",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),

                  // Filter Angkatan
                  const Text(
                    "Tahun Angkatan",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    value: tempAngkatan,
                    hint: const Text("Pilih Tahun Angkatan"),
                    items: ['2020', '2021', '2022', '2023', '2024'].map((
                      String val,
                    ) {
                      return DropdownMenuItem(value: val, child: Text(val));
                    }).toList(),
                    onChanged: (val) => setModalState(() => tempAngkatan = val),
                  ),
                  const SizedBox(height: 15),

                  // Filter Program Studi (Dinamis dari API Kelompok 4)
                  const Text(
                    "Program Studi",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    value: tempProdi,
                    hint: const Text("Pilih Program Studi"),
                    items: prodiList.map((prodi) {
                      return DropdownMenuItem(
                        value: prodi.prodiId, // Simpan ID
                        child: Text(prodi.namaProdi), // Tampilkan Nama
                      );
                    }).toList(),
                    onChanged: (val) => setModalState(() => tempProdi = val),
                  ),
                  const SizedBox(height: 15),

                  // Filter Status
                  const Text(
                    "Status",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    value: tempStatus,
                    hint: const Text("Pilih Status"),
                    items: ['Aktif', 'Non Aktif'].map((String val) {
                      return DropdownMenuItem(value: val, child: Text(val));
                    }).toList(),
                    onChanged: (val) => setModalState(() => tempStatus = val),
                  ),
                  const SizedBox(height: 25),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            side: const BorderSide(color: Color(0xFF1E3A8A)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setModalState(() {
                              tempAngkatan = null;
                              tempProdi = null;
                              tempStatus = null;
                            });
                            setState(() {
                              _selectedAngkatan = null;
                              _selectedProdi = null;
                              _selectedStatus = null;
                            });
                          },
                          child: const Text(
                            "Atur Ulang",
                            style: TextStyle(color: Color(0xFF1E3A8A)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: const Color(0xFF1E3A8A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedAngkatan = tempAngkatan;
                              _selectedProdi = tempProdi;
                              _selectedStatus = tempStatus;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Terapkan",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<AppProvider>();
    final rawData = prov.mahasiswaList;

    final filteredList = rawData.where((mhs) {
      // Filter Pencarian
      final matchesSearch =
          mhs.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          mhs.nim.toLowerCase().contains(_searchQuery.toLowerCase());

      // Filter Angkatan (Menggunakan getter dari model)
      final matchAngkatan =
          _selectedAngkatan == null || mhs.tahunAngkatan == _selectedAngkatan;

      // Filter Prodi (Mencocokkan ID Prodi)
      final matchProdi =
          _selectedProdi == null || mhs.prodiId == _selectedProdi;

      // Filter Status
      final matchStatus =
          _selectedStatus == null ||
          mhs.status.toLowerCase() == _selectedStatus!.toLowerCase();

      return matchesSearch && matchAngkatan && matchProdi && matchStatus;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        title: const Text(
          "Daftar Mahasiswa",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header Search & Filter area
          Container(
            color: const Color(0xFF1E3A8A),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Cari Nama atau NIM",
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _showFilterModal(context),
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.filter_list,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List Mahasiswa
          Expanded(
            child: prov.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF1E3A8A)),
                  )
                : filteredList.isEmpty
                ? const Center(child: Text("Data mahasiswa tidak ditemukan"))
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final mhs = filteredList[index];
                      bool isAktif = mhs.status.toLowerCase() == 'aktif';

                      // MENGAMBIL NAMA PRODI DARI PROVIDER BERDASARKAN ID
                      String namaProdi = prov.getNamaProdi(mhs.prodiId);

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailMahasiswaScreen(mahasiswa: mhs),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                radius: 25,
                                backgroundColor: Color(0xFFE2E8F0),
                                child: Icon(
                                  Icons.person,
                                  color: Color(0xFF1E3A8A),
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mhs.nama,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "NIM: ${mhs.nim.isEmpty ? '-' : mhs.nim}",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Prodi: $namaProdi", // UPDATE DISINI
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Angkatan: ${mhs.tahunAngkatan}", // UPDATE DISINI
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: isAktif
                                      ? Colors.green.shade50
                                      : Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isAktif ? Colors.green : Colors.red,
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  mhs.status.toUpperCase(),
                                  style: TextStyle(
                                    color: isAktif ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

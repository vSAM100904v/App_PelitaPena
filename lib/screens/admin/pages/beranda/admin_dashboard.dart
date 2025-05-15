import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:pa2_kelompok07/screens/client/laporan/laporan_anda_screen.dart';
import '../../widgets/sidebar.dart';
import '../Donasi/halaman_donasi.dart';
import '../event/halaman_event.dart';
import 'package:pa2_kelompok07/screens/admin/pages/kategoriKekerasan/halamanbaru_kategori.dart';
// import '../konten/konten.dart';
import '../konten/halaman_konten.dart';
import 'package:pa2_kelompok07/screens/admin/pages/Laporan/laporan.dart';
import 'package:pa2_kelompok07/config.dart';

/// Service untuk mengambil data dari API backend menggunakan konfigurasi di config.dart
class ApiService {
  // Mengambil data kontak darurat (misal: id=1)
  static Future<String> fetchEmergencyContact() async {
    final url = Uri.parse("${Config.apiUrl}${Config.emergencyContactAPI}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['phone'] as String;
    } else {
      throw Exception('Gagal mengambil data kontak darurat');
    }
  }

  // Mengambil data donasi
  static Future<List<dynamic>> fetchDonations() async {
    final url = Uri.parse("${Config.apiUrl}${Config.donationsAPI}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data as List<dynamic>;
    } else {
      throw Exception('Gagal mengambil data donasi');
    }
  }

  // Update kontak darurat
  static Future<bool> updateEmergencyContact(String newPhone) async {
    final url = Uri.parse("${Config.apiUrl}${Config.emergencyContactAPI}/1");
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone": newPhone}),
    );
    return response.statusCode == 200;
  }
}

/// Beranda tetap (kode lama tidak berubah)
class Beranda extends StatefulWidget {
  const Beranda({Key? key}) : super(key: key);

  static const Color primaryBlue = Color(0xFF7AA5D2);
  static const Color secondaryBlue = Color(0xFF2E4374);

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String emergencyContact = 'Loading...';
  int _selectedIndex = 1; // Home is selected by default
  List<dynamic> donationData = [];

  @override
  void initState() {
    super.initState();
    _loadEmergencyContact();
    _loadDonations();
  }

  Future<void> _loadEmergencyContact() async {
    try {
      final phone = await ApiService.fetchEmergencyContact();
      setState(() {
        emergencyContact = phone;
      });
    } catch (e) {
      setState(() {
        emergencyContact = 'Error';
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  Future<void> _loadDonations() async {
    try {
      final donations = await ApiService.fetchDonations();
      setState(() {
        donationData = donations;
      });
    } catch (e) {
      setState(() {
        donationData = [];
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _showEditContactDialog() {
    final TextEditingController controller = TextEditingController(
      text: emergencyContact,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Kontak Darurat'),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Nomor Telepon',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final newPhone = controller.text;
                  bool success = await ApiService.updateEmergencyContact(
                    newPhone,
                  );
                  if (success) {
                    setState(() {
                      emergencyContact = newPhone;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Kontak darurat berhasil diperbarui'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gagal memperbarui kontak darurat'),
                      ),
                    );
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
    );
  }

  void _navigateToPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation based on index
    if (index == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Membuka Chat')));
    } else if (index == 2) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Membuka Peringatan')));
    }
  }

  // Fungsi untuk menghasilkan data chart donasi berdasarkan donationData yang diambil
  List<BarChartGroupData> _getDonationChartData() {
    // Misal: chart menampilkan 7 hari terakhir
    final now = DateTime.now();
    List<BarChartGroupData> groups = [];
    for (int i = 0; i < 7; i++) {
      final day = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: 6 - i));
      // Hitung jumlah donasi untuk hari tersebut
      int donationInCount =
          donationData.where((donation) {
            try {
              final createdAt = DateTime.parse(donation['created_at']);
              return createdAt.year == day.year &&
                  createdAt.month == day.month &&
                  createdAt.day == day.day;
            } catch (e) {
              return false;
            }
          }).length;
      // Asumsikan donasi keluar selalu 0 (atau Anda bisa menyesuaikan dengan data)
      int donationOutCount = 0;

      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: donationInCount.toDouble() * 100, // skala: 100 per donasi
              color: Beranda.primaryBlue,
              width: 15,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            BarChartRodData(
              toY: donationOutCount.toDouble() * 100,
              color: Colors.redAccent,
              width: 15,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ],
          groupVertically: false,
          barsSpace: 5,
        ),
      );
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF9FAFB),
      drawer: const AppSidebar(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Beranda.secondaryBlue),
          onPressed: _openDrawer,
        ),
        title: const Text(
          'PendikaApp',
          style: TextStyle(
            color: Beranda.secondaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuka profil pengguna')),
                );
              },
              child: const CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-4BrnI3yirocxVzGB1nmUAEB8IOBarm.png',
                ),
                radius: 18,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Tetap
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Beranda.primaryBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/admin-layout');
                  },
                  child: const Text(
                    'Selamat datang',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Jangan lupa selalu semangat 100% tangani kekerasan terhadap perempuan dan anak',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.phone, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        emergencyContact,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _showEditContactDialog,
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit Kontak darurat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Body scrollable
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await _loadEmergencyContact();
                await _loadDonations();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data diperbarui')),
                );
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Menu
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: [
                        _MenuItem(
                          icon: Icons.category,
                          label: 'Kategori Kekerasan',
                          onTap:
                              () =>
                                  _navigateToPage(const HalamanbaruKategori()),
                        ),

                        _MenuItem(
                          icon: Icons.article,
                          label: 'Konten',
                          onTap: () => _navigateToPage(const HalamanKonten()),
                        ),
                        _MenuItem(
                          icon: Icons.event,
                          label: 'Event',
                          onTap: () => _navigateToPage(const HalamanEvent()),
                        ),
                        _MenuItem(
                          icon: Icons.volunteer_activism,
                          label: 'Donasi',
                          onTap: () => _navigateToPage(const HalamanDonasi()),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    // Statistik laporan dari AdminDashboard
                    _AdminDashboardSection(),
                    const SizedBox(height: 20),
                    // Donasi Chart
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Donasi',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Beranda.secondaryBlue,
                                ),
                              ),
                              TextButton.icon(
                                onPressed:
                                    () =>
                                        _navigateToPage(const HalamanDonasi()),
                                icon: const Icon(Icons.bar_chart, size: 18),
                                label: const Text('Lihat Detail'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Beranda.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: Beranda.primaryBlue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('Donasi Masuk'),
                              const SizedBox(width: 24),
                              Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('Donasi Keluar'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: _DonationChart(
                              chartData: _getDonationChartData(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // Bottom nav
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline, size: 28),
              activeIcon: Icon(Icons.chat_bubble, size: 28),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _selectedIndex == 1
                          ? Beranda.primaryBlue
                          : Colors.transparent,
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.home,
                  color:
                      _selectedIndex == 1 ? Colors.white : Beranda.primaryBlue,
                  size: 28,
                ),
              ),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.warning_amber_outlined, size: 28),
              activeIcon: Icon(Icons.warning_amber, size: 28),
              label: 'Alert',
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Icon(icon, color: Beranda.primaryBlue, size: 30),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LaporanCard extends StatelessWidget {
  final String title;
  final int count;
  final VoidCallback onPressed;
  final IconData icon;

  const _LaporanCard({
    required this.title,
    required this.count,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Beranda.primaryBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Beranda.primaryBlue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Beranda.secondaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Beranda.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Lihat Selengkapnya'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DonationChart extends StatelessWidget {
  final List<BarChartGroupData> chartData;

  const _DonationChart({Key? key, required this.chartData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value % 100 != 0) return const SizedBox();
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final days = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      days[value.toInt() % 7],
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: chartData,
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          horizontalInterval: 100,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: const Color(0xFFEEEEEE), strokeWidth: 1);
          },
          drawVerticalLine: false,
        ),
        maxY: 500,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.shade800,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String type = rodIndex == 0 ? 'Masuk' : 'Keluar';
              return BarTooltipItem(
                '${type}: ${rod.toY.toInt()}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Widget AdminDashboardSection yang mengambil data laporan dari backend dan menampilkan statistik laporan
class _AdminDashboardSection extends StatefulWidget {
  @override
  State<_AdminDashboardSection> createState() => __AdminDashboardSectionState();
}

class __AdminDashboardSectionState extends State<_AdminDashboardSection> {
  bool isLoading = true;
  List<dynamic> reports = [];

  // Statistik laporan
  int totalReports = 0;
  int newReports = 0;
  int processedReports = 0;
  int cancelledReports = 0;
  int finishedReports = 0;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    final url = Uri.parse("${Config.apiUrl}/api/admin/laporans");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          reports = data;
          totalReports = reports.length;
          newReports =
              reports
                  .where((r) => (r['status'] as String).toLowerCase() == "baru")
                  .length;
          processedReports =
              reports
                  .where(
                    (r) => (r['status'] as String).toLowerCase() == "diproses",
                  )
                  .length;
          cancelledReports =
              reports
                  .where(
                    (r) =>
                        (r['status'] as String).toLowerCase() == "dibatalkan",
                  )
                  .length;
          finishedReports =
              reports
                  .where(
                    (r) => (r['status'] as String).toLowerCase() == "selesai",
                  )
                  .length;
          isLoading = false;
        });
      } else {
        throw Exception("Gagal mengambil laporan: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  Widget _buildReportCard(
    String title,
    int count,
    VoidCallback onPressed,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF7AA5D2).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFF7AA5D2)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E4374),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7AA5D2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Lihat Selengkapnya'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Contoh fungsi navigasi ke halaman detail laporan
  void _navigateToLaporanPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LaporanScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("INI ISII DARI REPORTRS $reports");
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'Statistik Laporan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E4374),
                ),
              ),
            ),
            _buildReportCard(
              "Semua Laporan",
              totalReports,
              _navigateToLaporanPage,
              Icons.list_alt,
            ),
            _buildReportCard(
              "Laporan Baru",
              newReports,
              _navigateToLaporanPage,
              Icons.fiber_new,
            ),
            _buildReportCard(
              "Laporan Diproses",
              processedReports,
              _navigateToLaporanPage,
              Icons.sync,
            ),
            _buildReportCard(
              "Laporan Dibatalkan",
              cancelledReports,
              _navigateToLaporanPage,
              Icons.cancel,
            ),
            _buildReportCard(
              "Laporan Selesai",
              finishedReports,
              _navigateToLaporanPage,
              Icons.check_circle,
            ),
          ],
        );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Gunakan bottom navigation untuk memilih antara Beranda dan AdminDashboard
  int _selectedTab = 0;
  final List<Widget> _pages = const [Beranda()];

  void _onTabTapped(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PendikaApp',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: _pages[_selectedTab],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: _onTabTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';

import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/toasters/toast.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/atoms/placeholder_component.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/dialogs/update_emergency_contact.dart';
import 'package:pa2_kelompok07/model/report/count_report_status.dart';
import 'package:pa2_kelompok07/model/report/emergency_contact_model.dart';

import 'package:pa2_kelompok07/screens/admin/pages/chat/chat_admin_screen.dart';
import 'package:pa2_kelompok07/services/api_service.dart';
import 'package:shimmer/shimmer.dart';

class DashboardRootPage extends StatefulWidget {
  final MotionTabBarController controller;
  const DashboardRootPage({super.key, required this.controller});
  @override
  State<DashboardRootPage> createState() => _DashboardRootPageState();
}

class _DashboardRootPageState extends State<DashboardRootPage>
    with AutomaticKeepAliveClientMixin {
  late Future<CountReportStatus> _statsFuture;
  final APIService _apiService = APIService();
  late Future<String> _emergencyContactFuture;

  // Add a PageController for the chat tab
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _statsFuture = _apiService.fetchStatusStats();
    _emergencyContactFuture = APIService.instance.fetchEmergencyContact();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final responsive = context.responsive;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _headerView(responsive),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMenuSquare(
                    icon: Icons.assignment_outlined,
                    color: Color(0xFF4A9DEC),
                    label: 'Laporan',
                    onTap: () {
                      // Use the tab controller to switch to the reports tab
                      widget.controller.index = 0;
                    },
                  ),
                  _buildMenuSquare(
                    icon: Icons.chat_outlined, // Changed to chat icon
                    color: Color(0xFFF9BC7D),
                    label: 'Chat',
                    onTap: () {
                      // Use the tab controller to switch to the chat tab
                      // Assuming chat is at index 1, adjust if needed
                      widget.controller.index = 2;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder<CountReportStatus>(
              future: _statsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: List.generate(3, (index) => _buildShimmerCard()),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: PlaceHolderComponent(state: PlaceHolderState.error),
                  );
                } else if (snapshot.hasData) {
                  final stats = snapshot.data!;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildReportCard(
                        "Daftar Laporan",
                        stats.laporanMasuk +
                            stats.laporanDilihat +
                            stats.laporanDiproses +
                            stats.laporanSelesai +
                            stats.laporanDibatalkan,
                        onTap: () => widget.controller.index = 0,
                      ),
                      _buildReportCard(
                        "Laporan Diproses",
                        stats.laporanDiproses,
                        onTap: () => widget.controller.index = 0,
                      ),
                      _buildReportCard(
                        "Laporan Dibatalkan",
                        stats.laporanDibatalkan,
                        onTap: () => widget.controller.index = 0,
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: PlaceHolderComponent(
                      state: PlaceHolderState.emptyReport,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSquare({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(
    String title,
    int count, {
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(
                  Icons.description_outlined,
                  color: Colors.blue.shade300,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFF4A9DEC),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Selengkapnya",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Container _headerView(ResponsiveSizes responsive) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFF4A9DEC),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Selamat Datang Admin",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          Text(
            "Kontak darurat",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          FutureBuilder<String>(
            future: _emergencyContactFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(color: Colors.white);
              } else if (snapshot.hasError) {
                return Text(
                  "Oops ada kesalahan !",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              } else if (snapshot.hasData) {
                return Text(
                  snapshot.data!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                );
              } else {
                return const Text('No data');
              }
            },
          ),
          SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              final result = await showDialog<EmergencyContact>(
                context: context,
                builder: (context) => const UpdateEmergencyContactDialog(),
              );
              if (result != null) {
                context.toast.showSuccess(
                  "No Contak berhasil di update ${result.phone}}",
                );
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.phone, color: Colors.grey.shade700, size: 18),
                  SizedBox(width: 8),
                  Text(
                    "Edit Kontak darurat",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// This class should be added to your project to handle the chat tab
// It should be placed in the appropriate file path
class ChatTabPage extends StatefulWidget {
  const ChatTabPage({Key? key}) : super(key: key);

  @override
  State<ChatTabPage> createState() => _ChatTabPageState();
}

class _ChatTabPageState extends State<ChatTabPage> {
  @override
  Widget build(BuildContext context) {
    return AdminChatListScreen(); // Use your existing chat screen
  }
}

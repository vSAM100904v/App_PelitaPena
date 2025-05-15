// import 'package:flutter/material.dart';
// import '../../../../main.dart';
// import '../../../../styles/color.dart';

// import 'package:flutter/material.dart';
// import 'package:pa2_kelompok07/core/persentation/widgets/atoms/placeholder_component.dart';
// import 'package:pa2_kelompok07/core/persentation/widgets/cards/report_card.dart';
// import 'package:pa2_kelompok07/model/report/list_report_model.dart';
// import 'package:pa2_kelompok07/provider/report_provider.dart';
// import 'package:pa2_kelompok07/screens/admin/pages/Laporan/detail_report_screen.dart';
// import 'package:shimmer/shimmer.dart';

// class LaporanScreen extends StatefulWidget {
//   const LaporanScreen({super.key});

//   @override
//   State<LaporanScreen> createState() => _LaporanScreenState();
// }

// class _LaporanScreenState extends State<LaporanScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final ReportProvider _reportProvider = ReportProvider();
//   bool _isInitialLoad = true;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _loadInitialData();
//   }

//   Future<void> _loadInitialData() async {
//     await _reportProvider.fetchAllReports();
//     setState(() => _isInitialLoad = false);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Laporan",
//           style: TextStyle(
//             fontSize: 16,
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         backgroundColor: AppColor.primaryColor,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorSize: TabBarIndicatorSize.tab,
//           tabs: const [
//             Tab(text: 'Laporan Masuk'),
//             Tab(text: 'Dalam Proses'),
//             Tab(text: 'Selesai'),
//           ],
//           indicatorColor: Colors.lightGreenAccent,
//           unselectedLabelColor: Colors.grey,
//           labelColor: Colors.white,
//         ),
//       ),
//       body:
//           _isInitialLoad
//               ? _buildLoadingState()
//               : TabBarView(
//                 controller: _tabController,
//                 children: [
//                   _buildReportList(_reportProvider.reportsMasuk),
//                   _buildReportList(_reportProvider.reportsProses),
//                   _buildReportList(_reportProvider.reportsSelesai),
//                 ],
//               ),
//     );
//   }

//   Widget _buildLoadingState() {
//     return ListView.builder(
//       itemCount: 3,
//       itemBuilder:
//           (context, index) => Shimmer.fromColors(
//             baseColor: Colors.grey[300]!,
//             highlightColor: Colors.grey[100]!,
//             child: Container(
//               margin: const EdgeInsets.all(16),
//               height: 150,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//     );
//   }

//   Widget _buildReportList(List<ListLaporanModel> reports) {
//     if (reports.isEmpty) {
//       return const PlaceHolderComponent(state: PlaceHolderState.emptyReport);
//     }

//     return RefreshIndicator(
//       onRefresh: () => _reportProvider.fetchAllReports(),
//       child: ListView.builder(
//         padding: const EdgeInsets.all(8),
//         itemCount: reports.length,
//         itemBuilder: (context, index) {
//           final report = reports[index];
//           return ReportCard(
//             report: report,
//             onTap:
//                 () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder:
//                         (context) => DetailReportScreen(
//                           noRegistrasi: report.noRegistrasi,
//                         ),
//                   ),
//                 ),
//           );
//         },
//       ),
//     );
//   }
// }

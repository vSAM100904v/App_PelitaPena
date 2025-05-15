// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../../../../provider/user_provider.dart';
// import '../../../../../provider/report_provider.dart';
// import '../../../../../model/report/list_report_model.dart';
// import '../../../../../styles/color.dart';
// import '../detail_report_screen.dart';
// import 'package:timeago/timeago.dart' as timeago;

// class ReportListEnter extends StatefulWidget {
//   const ReportListEnter({super.key});

//   @override
//   State<ReportListEnter> createState() => _ReportListEnterState();
// }

// class _ReportListEnterState extends State<ReportListEnter> {
//   @override
//   void initState() {
//     super.initState();
//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       Provider.of<ReportProvider>(
//         context,
//         listen: false,
//       ).fetchReportsByLaporanMasuk();
//     });
//   }

//   Widget buildReportSkeleton(BuildContext context) {
//     return ListView.builder(
//       itemCount: 5,
//       itemBuilder: (context, index) {
//         return Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Padding(
//             padding: const EdgeInsets.all(10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   margin: const EdgeInsets.all(15),
//                   height: 30,
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: Colors.black),
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       margin: const EdgeInsets.all(15),
//                       height: 100,
//                       width: 100,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: Colors.black),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 15, right: 15),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               height: 20,
//                               width: MediaQuery.of(context).size.width,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(5),
//                                 border: Border.all(color: Colors.black),
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             Container(
//                               height: 20,
//                               width: MediaQuery.of(context).size.width,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(5),
//                                 border: Border.all(color: Colors.black),
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             Container(
//                               height: 30,
//                               width: MediaQuery.of(context).size.width,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(5),
//                                 border: Border.all(color: Colors.black),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Spacer(),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 15, right: 15),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Container(
//                             height: 40,
//                             width: 150,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(5),
//                               border: Border.all(color: Colors.black),
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           Container(
//                             height: 20,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(5),
//                               border: Border.all(color: Colors.black),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);
//     return Scaffold(
//       body: Consumer<ReportProvider>(
//         builder: (context, reportProvider, child) {
//           if (reportProvider.isLoading) {
//             return buildReportSkeleton(context);
//           } else if (reportProvider.reports == null) {
//             return const Center(child: Text('Gagal memuat laporan'));
//           } else if (reportProvider.reports!.data.isEmpty) {
//             return const Center(child: Text('Tidak ada laporan'));
//           } else {
//             return ListView.builder(
//               itemCount: reportProvider.reports!.data.length,
//               itemBuilder: (context, index) {
//                 ListLaporanModel report = reportProvider.reports!.data[index];
//                 final timeAgo = timeago.format(report.updatedAt, locale: 'id');
//                 return Container(
//                   margin: const EdgeInsets.all(10),
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: Colors.grey),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "No Registrasi: ${report.noRegistrasi}",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Image.network(
//                             report.violenceCategoryDetail.image!,
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               return const Icon(Icons.error, color: Colors.red);
//                             },
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Pelapor: ${userProvider.user?.full_name ?? 'Guest'}",
//                                   textAlign: TextAlign.end,
//                                 ),
//                                 const SizedBox(height: 10),
//                                 Text(
//                                   report.violenceCategoryDetail.categoryName!,
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 5),
//                                 Text(
//                                   report.kronologisKasus,
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Spacer(),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               ElevatedButton(
//                                 style: ButtonStyle(
//                                   foregroundColor:
//                                       MaterialStateProperty.all<Color>(
//                                         Colors.white,
//                                       ),
//                                   backgroundColor:
//                                       MaterialStateProperty.all<Color>(
//                                         AppColor.primaryColor,
//                                       ),
//                                   shape: MaterialStateProperty.all<
//                                     RoundedRectangleBorder
//                                   >(
//                                     RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(5),
//                                       side: BorderSide(
//                                         color: AppColor.primaryColor,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder:
//                                           (context) => DetailReportScreen(
//                                             noRegistrasi: report.noRegistrasi,
//                                           ),
//                                     ),
//                                   );
//                                 },
//                                 child: Text(
//                                   "Lihat Rincian".toUpperCase(),
//                                   style: const TextStyle(fontSize: 14),
//                                 ),
//                               ),
//                               Text(
//                                 timeAgo,
//                                 textAlign: TextAlign.end,
//                                 style: TextStyle(color: Colors.grey[600]),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:pa2_kelompok07/core/persentation/widgets/atoms/placeholder_component.dart';
// import 'package:pa2_kelompok07/core/persentation/widgets/cards/report_card.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../../provider/user_provider.dart';
// import '../../../provider/report_provider.dart';
// import '../../../model/report/list_report_model.dart';
// import '../../../styles/color.dart';
// import '../detail_report_screen.dart';
// import 'package:timeago/timeago.dart' as timeago;

// class ReportListProcess extends StatefulWidget {
//   const ReportListProcess({super.key});

//   @override
//   State<ReportListProcess> createState() => _ReportListProcessState();
// }

// class _ReportListProcessState extends State<ReportListProcess> {
//   @override
//   void initState() {
//     super.initState();
//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       Provider.of<ReportProvider>(
//         context,
//         listen: false,
//       ).fetchReportsByLaporanProses();
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
//             return const PlaceHolderComponent(state: PlaceHolderState.error);
//           } else if (reportProvider.reports!.data.isEmpty) {
//             return const PlaceHolderComponent(
//               state: PlaceHolderState.emptyReport,
//             );
//           } else {
//             return ListView.builder(
//               itemCount: reportProvider.reports!.data.length,
//               itemBuilder: (context, index) {
//                 ListLaporanModel report = reportProvider.reports!.data[index];

//                 return ReportCard(
//                   report: report,
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder:
//                             (context) => DetailReportScreen(
//                               noRegistrasi: report.noRegistrasi,
//                             ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

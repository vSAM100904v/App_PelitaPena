import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/atoms/placeholder_component.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/cards/report_card.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pa2_kelompok07/model/report/report_request_model.dart';
import 'package:pa2_kelompok07/screens/client/dpmdppa/form_report.dart';
import 'package:flutter/scheduler.dart';

import '../../../model/report/list_report_model.dart';
import '../../../provider/report_provider.dart';
import '../../../provider/user_provider.dart';
import '../../../styles/color.dart';
import '../../../model/report/report_category_model.dart';
import '../../../services/api_service.dart';
import 'package:collection/collection.dart';

import '../laporan/detail_report_screen.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<ViolenceCategory> categories = [];
  bool isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    // timeago.setLocaleMessages('id', timeago.IdMessages());
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(context, listen: false).fetchReports();
    });
  }

  Future<void> fetchCategories() async {
    final apiService = APIService();
    try {
      final fetchedCategories = await apiService.fetchCategories();
      setState(() {
        categories = fetchedCategories;
        isLoadingCategories = false;
      });
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        isLoadingCategories = false;
      });
    }
  }

  Widget buildReportSkeleton(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 20,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 20,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 35,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15, right: 15),
                      child: Container(
                        height: 30,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ViolenceCategory? findCategoryById(int id) {
    return categories.firstWhereOrNull((category) => category.id == id);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Laporan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColor.primaryColor,
          ),
        ),
      ),
      body: Consumer<ReportProvider>(
        builder: (context, reportProvider, child) {
          if (reportProvider.isLoading) {
            return buildReportSkeleton(context);
          } else if (reportProvider.reports == null) {
            return const PlaceHolderComponent(state: PlaceHolderState.error);
          } else if (reportProvider.reports!.data.isEmpty) {
            return const PlaceHolderComponent(
              state: PlaceHolderState.emptyReport,
            );
          } else {
            return ListView.builder(
              itemCount: reportProvider.reports!.data.length,
              itemBuilder: (context, index) {
                ListLaporanModel report = reportProvider.reports!.data[index];

                return ReportCard(
                  report: report,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => DetailClientReportScreen(
                              noRegistrasi: report.noRegistrasi,
                            ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primaryColor,
        onPressed: () {
          if (userProvider.isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FormReportDPMADPPA(),
              ),
            );
          } else {
            Navigator.of(
              context,
            ).pushNamed('/login', arguments: {'redirectTo': '/add-laporan'});
          }
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_style.dart';
import 'package:pa2_kelompok07/core/helpers/logger/logger.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/atoms/placeholder_component.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/cards/report_card.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/dialogs/donwloaded_pdf_dialog.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/dialogs/filter_reports_dialog.dart';
import 'package:pa2_kelompok07/main.dart';
import 'package:pa2_kelompok07/provider/admin_provider.dart';
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
  final bool isAdminView;
  const ReportScreen({super.key, this.isAdminView = false});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

// RouteAware
class _ReportScreenState extends State<ReportScreen>
    with SingleTickerProviderStateMixin {
  List<ViolenceCategory> categories = [];
  final Logger _logger = Logger('ReportScreen');
  bool isLoadingCategories = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late ReportProvider reportProvider;
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    reportProvider = Provider.of<ReportProvider>(context, listen: false);

    // Tunda eksekusi setelah frame pertama selesai
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        reportProvider.fetchReports();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    // routeObserver.unsubscribe(this);
    super.dispose();
  }

  // @override
  // void didPopNext() {
  //   Provider.of<ReportProvider>(context, listen: false).fetchReports();
  // }

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
    final responsive = context.responsive;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Laporan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color:
                widget.isAdminView
                    ? AppColor.primaryAdminBackground
                    : AppColor.primaryColor,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(
            60,
          ), // Atur tinggi sesuai kebutuhan
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: _taglineHeader(context, responsive, reportProvider),
          ),
        ),
      ),

      body: Column(
        children: [
          SizedBox(height: responsive.space(SizeScale.sm)),

          Expanded(
            child: ChangeNotifierProvider.value(
              value: reportProvider,

              child: Consumer<ReportProvider>(
                builder: (context, reportProvider, child) {
                  if (reportProvider.isLoading) {
                    return buildReportSkeleton(context);
                  } else if (reportProvider.reports == null) {
                    return const PlaceHolderComponent(
                      state: PlaceHolderState.error,
                    );
                  } else if (reportProvider.reports.isEmpty) {
                    return const PlaceHolderComponent(
                      state: PlaceHolderState.emptyReport,
                    );
                  } else {
                    return ListView.builder(
                      itemCount: reportProvider.reports!.length,
                      itemBuilder: (context, index) {
                        ListLaporanModel report =
                            reportProvider.reports![index];

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
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor:
            widget.isAdminView
                ? AppColor.primaryAdminBackground
                : AppColor.primaryColor,
        onPressed: () {
          if (userProvider.isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FormReportDPMADPPA()),
            ).then((shouldRefresh) {
              if (shouldRefresh == true) {
                _logger.log("Should Refresh Called");
                reportProvider.fetchReports();
              }
            });
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

  Row _taglineHeader(
    BuildContext context,
    ResponsiveSizes responsive,
    ReportProvider adminProvider,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Filter", style: context.textStyle.onestBold(size: SizeScale.md)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 6,
          children: [
            ReportFilterDropdown(
              adminProvider: reportProvider,
              onFilterApplied: () {
                _animationController.reset();
                _animationController.forward();
              },
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pa2_kelompok07/config.dart';
import 'package:pa2_kelompok07/core/constant/constant.dart';

import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_hook.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_style.dart';
import 'package:pa2_kelompok07/core/helpers/logger/text_logger.dart';
import 'package:pa2_kelompok07/core/helpers/toasters/toast.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/atoms/admin_header.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/atoms/placeholder_component.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/cards/report_admin_card.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/dialogs/action_dialog.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/dialogs/donwloaded_pdf_dialog.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/dialogs/filter_reports_dialog.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/modals/report_detail_modal.dart';
import 'package:pa2_kelompok07/core/services/pdf_service.dart';
import 'package:pa2_kelompok07/main.dart';

import 'package:pa2_kelompok07/model/report/list_report_model.dart';
import 'package:pa2_kelompok07/model/report/report_category_model.dart';
import 'package:pa2_kelompok07/model/report/report_request_model.dart';
import 'package:pa2_kelompok07/provider/admin_provider.dart';
import 'package:pa2_kelompok07/provider/user_provider.dart';
import 'package:pa2_kelompok07/services/api_service.dart';
import 'package:pa2_kelompok07/utils/loading_dialog.dart';
import 'package:provider/provider.dart';

class DashboardViewReportPage extends StatefulWidget {
  const DashboardViewReportPage({super.key});

  @override
  State<DashboardViewReportPage> createState() =>
      _DashboardViewReportPageState();
}

class _DashboardViewReportPageState extends State<DashboardViewReportPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final UserProvider _userProvider;
  late AdminProvider _reportsNotifier;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();
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

    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _reportsNotifier = AdminProvider(_userProvider);
    _reportsNotifier.fetchReports(1); // Fetch halaman pertama
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
    _reportsNotifier.searchReports(query);
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final responsive = context.responsive;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(context.responsive.space(SizeScale.md)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _headerView(responsive),

              SizedBox(height: responsive.space(SizeScale.md)),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height:
                          context.responsive.space(SizeScale.xxxl) +
                          context.responsive.space(SizeScale.xl),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(0),
                          prefixIcon: const Icon(Icons.search_outlined),
                          hintText: "Type Something",
                          fillColor: Color(0xFFF7F7F7),
                          filled: true,
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade800),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        onChanged: updateSearchQuery,
                      ),
                    ),
                  ),
                ],
              ),

              _searchBar(responsive),

              // Table Title
              _taglineHeader(context, responsive, _reportsNotifier),
              SizedBox(height: responsive.space(SizeScale.sm)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [],
              ),
              _columnListTitle(context),
              SizedBox(
                height: 400,
                child: ChangeNotifierProvider.value(
                  value: _reportsNotifier,
                  child: Consumer<AdminProvider>(
                    builder: (context, notifier, child) {
                      if (notifier.isLoading && notifier.reports.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (notifier.error != null && notifier.reports.isEmpty) {
                        return const Center(
                          child: PlaceHolderComponent(
                            state: PlaceHolderState.emptyReport,
                          ),
                        );
                      }

                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            // Tabel
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: notifier.reports.length,
                                itemBuilder: (context, index) {
                                  final report = notifier.reports[index];
                                  return ReportCardAdminView(
                                    reportDate: report.tanggalPelaporan,
                                    status: report.status,
                                    title: report.noRegistrasi,
                                    isSelected: notifier.selectedReports
                                        .contains(report),
                                    message: report.noRegistrasi,
                                    onSelectionChanged: () {
                                      notifier.toggleReportSelection(report);
                                    },
                                    onTap: () {
                                      showLaporanDetailBottomSheet(
                                        context,
                                        report,
                                        index,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed:
                                      notifier.currentPage > 1
                                          ? () {
                                            _animationController.reset();
                                            _animationController.forward();
                                            notifier.goToPage(
                                              notifier.currentPage - 1,
                                            );
                                          }
                                          : null,
                                  icon: const Icon(Icons.arrow_back),
                                ),
                                Text(
                                  "Page ${notifier.currentPage} of ${notifier.totalPages}",
                                  style: TextStyle(
                                    fontSize: responsive.fontSize(SizeScale.sm),
                                  ),
                                ),
                                IconButton(
                                  onPressed:
                                      notifier.currentPage < notifier.totalPages
                                          ? () {
                                            _animationController.reset();
                                            _animationController.forward();
                                            notifier.goToPage(
                                              notifier.currentPage + 1,
                                            );
                                          }
                                          : null,
                                  icon: const Icon(Icons.arrow_forward),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _taglineHeader(
    BuildContext context,
    ResponsiveSizes responsive,
    AdminProvider adminProvider,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Laporan", style: context.textStyle.onestBold(size: SizeScale.md)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 6,
          children: [
            ReportFilterDropdown(
              adminProvider: _reportsNotifier,
              onFilterApplied: () {
                _animationController.reset();
                _animationController.forward();
              },
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return DonwloadedPdfDialog(adminProvider: adminProvider);
                  },
                );
              },

              child: Container(
                padding: EdgeInsets.all(responsive.space(SizeScale.sm)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    responsive.borderRadius(SizeScale.md),
                  ),
                  border: Border.all(color: Colors.grey[200]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.print,
                      size: responsive.fontSize(SizeScale.md),
                      color: Color(0xFF79B2E1),
                    ),
                    SizedBox(width: responsive.space(SizeScale.xs)),
                    Text(
                      'Export',
                      style: context.textStyle.jakartaSansMedium(
                        size: SizeScale.sm,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row _columnListTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Nomor Registrasi".truncate(maxChars: 8),
          style: context.textStyle.onestBold(size: SizeScale.md),
        ),
        // Tanggal Pelaporan
        Text(
          "Tanggal Pelaporan".truncate(maxChars: 8),
          style: context.textStyle.onestBold(size: SizeScale.md),
        ),

        Text("Status", style: context.textStyle.onestBold(size: SizeScale.md)),
      ],
    );
  }

  SizedBox _searchBar(ResponsiveSizes responsive) =>
      SizedBox(height: responsive.space(SizeScale.md));

  FadeTransition _headerView(ResponsiveSizes responsive) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.infinity,

        // margin: EdgeInsets.symmetric(
        //   horizontal: responsive.space(SizeScale.md),
        //   vertical: responsive.space(SizeScale.sm),
        // ),
        padding: EdgeInsets.all(responsive.space(SizeScale.lg)),
        decoration: BoxDecoration(
          color: Color(0xFF79B2E1),
          borderRadius: BorderRadius.circular(
            responsive.borderRadius(SizeScale.sm),
          ),
          image: DecorationImage(
            image: AssetImage("assets/man.png"),
            fit: BoxFit.contain,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Pelaporan DPMDPPA",
                    style: context.textStyle.onestBold(
                      size: SizeScale.xl,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: responsive.space(SizeScale.sm)),
                  Text(
                    "Jangan lupa selalu semangat 100% tangani kekerasan terhadap perempuan dan anak",
                    style: context.textStyle.dmSansRegular(
                      size: SizeScale.md,
                      color: Colors.white,
                    ),
                  ),
                  // Text(
                  //   "Jangan lupa selalu semangat 100% tangani kekerasan terhadap perempuan dan anak",
                  //   style: context.textStyle.dmSansRegular(
                  //     size: SizeScale.md,
                  //     color: Colors.white,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                ],
              ),
            ),
            SizedBox(width: responsive.space(SizeScale.md)),
          ],
        ),
      ),
    );
  }

  void showLaporanDetailBottomSheet(
    BuildContext context,
    ListLaporanModel laporan,
    int index, {
    bool isRefreshing = false,
  }) async {
    if (laporan.useridMelihat == null) {
      showLoadingAnimated(context);
      try {
        await APIService.instance.updateStatusReportAsReadAdminService(
          accessToken: _userProvider.userToken,
          noRegistrasi: laporan.noRegistrasi,
        );

        final updatedLaporan = laporan.copyWith(
          useridMelihat: _userProvider.userId,
          waktuDilihat: DateTime.now().toIso8601String(),
        );

        _reportsNotifier.updateReportByIndex(
          index,
          status: updatedLaporan.status,
          useridMelihat: updatedLaporan.useridMelihat,
          waktuDilihat: updatedLaporan.waktuDilihat,
        );

        closeLoadingDialog(context);
        // Buka modal dengan data yang diperbarui
        showLaporanDetailBottomSheet(context, updatedLaporan, index);
      } catch (e) {
        closeLoadingDialog(context);
        context.toast.showError(
          "Gagal menandai laporan sebagai dilihat: ${e.toString()}",
        );
        print("Error: $e");
      }
    } else {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return ReportDetailModal(
            laporan: laporan,
            isMe: _userProvider.userId == laporan.useridMelihat,
            onUpdate:
                () => showLaporanDetailBottomSheet(
                  context,
                  laporan,
                  index,
                  isRefreshing: true,
                ),
            onOpenDialog: (innerContext) {
              showDialog(
                context: innerContext,
                builder: (dialogContext) {
                  return ActionDialog(
                    laporan: laporan,
                    onStatusUpdated: (newStatus) async {
                      try {
                        print("INIII NILAI STATUSSSSSSSSSSSSSSS $newStatus");

                        if (newStatus == "Diproses") {
                          await APIService.instance
                              .updateStatusReportAsDoneAdminService(
                                accessToken: _userProvider.userToken,
                                noRegistrasi: laporan.noRegistrasi,
                                innerContext: innerContext,
                              );
                          _reportsNotifier.updateReportByIndex(
                            index,
                            status: newStatus,
                          );
                          // Perbarui status lokal di modal
                        } else if (newStatus == "Selesai") {
                          await APIService.instance
                              .updateStatusReportAsProcessAdminService(
                                accessToken: _userProvider.userToken,
                                noRegistrasi: laporan.noRegistrasi,
                                innerContext: innerContext,
                              );
                          _reportsNotifier.updateReportByIndex(
                            index,
                            status: newStatus,
                          );
                        }

                        Navigator.of(innerContext).pop();
                      } catch (e) {
                        innerContext.toast.showSuccess(
                          "Status berhasil diubah ke $newStatus",
                        );
                      }
                    },
                  );
                },
              );
            },
          );
        },
      );
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_hook.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_style.dart';
import 'package:pa2_kelompok07/core/models/reported_chat_model.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/atoms/placeholder_component.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/cards/report_admin_card.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/modals/chat_reported_detail_modal.dart';
import 'package:pa2_kelompok07/provider/report_provider.dart';
import 'package:pa2_kelompok07/provider/reported_chat_provider.dart';
import 'package:provider/provider.dart';

class ReportedChatPage extends StatefulWidget {
  final String userToken;

  const ReportedChatPage({Key? key, required this.userToken}) : super(key: key);

  @override
  _ReportedChatPageState createState() => _ReportedChatPageState();
}

class _ReportedChatPageState extends State<ReportedChatPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late ReportedChatProvider _reportsNotifier;

  @override
  void initState() {
    super.initState();
    _reportsNotifier = ReportedChatProvider(userToken: widget.userToken);
    _reportsNotifier.fetchReports(1);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Client Reports')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ChangeNotifierProvider.value(
          value: _reportsNotifier,
          child: Consumer<ReportedChatProvider>(
            builder: (context, notifier, child) {
              print("_reportsNotifier ${notifier.reports.length}");
              if (notifier.isLoading && notifier.reports.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (notifier.error != null && notifier.reports.isEmpty) {
                return const Center(
                  child: PlaceHolderComponent(
                    state: PlaceHolderState.noReportedChats,
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
                            reportDate: report.createdAt,
                            message: report.messageContent.truncate(
                              maxChars: 12,
                            ),
                            status: "reported",
                            title: report.reportedUserUsername,
                            isSelected: notifier.selectedReports.contains(
                              report,
                            ),

                            onTap: () {
                              showLaporanDetailBottomSheet(context, report);
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
                                    notifier.goToPage(notifier.currentPage - 1);
                                  }
                                  : null,
                          icon: const Icon(Icons.arrow_back),
                        ),
                        Text(
                          "Page ${notifier.currentPage} of ${notifier.totalPages}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          onPressed:
                              notifier.currentPage < notifier.totalPages
                                  ? () {
                                    _animationController.reset();
                                    _animationController.forward();
                                    notifier.goToPage(notifier.currentPage + 1);
                                  }
                                  : null,
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void showLaporanDetailBottomSheet(
    BuildContext context,
    ReportedChat chat,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ReportedChatDetailModal(
          chatReport: chat,
          onOpenDialog: (context) {
            // Logika tambahan saat dialog dibuka
          },
          isMe: false,
        );
      },
    );
  }
}

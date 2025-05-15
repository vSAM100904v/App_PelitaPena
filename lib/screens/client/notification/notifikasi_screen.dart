import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:pa2_kelompok07/core/helpers/hooks/screen_navigator.dart';
import 'package:pa2_kelompok07/core/helpers/logger/text_logger.dart';
import 'package:pa2_kelompok07/core/helpers/toasters/toast.dart';
import 'package:pa2_kelompok07/core/models/notification_channel_model.dart';
import 'package:pa2_kelompok07/core/models/notification_response_model.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/atoms/placeholder_component.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/modals/notification_detail_modal.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/notification_card.dart';
import 'package:pa2_kelompok07/provider/notification_query_provider.dart';
import 'package:pa2_kelompok07/provider/user_provider.dart';
import 'package:pa2_kelompok07/screens/client/chat/rooms_client_screen.dart';
import 'package:pa2_kelompok07/screens/client/laporan/component/tracking_detail_page.dart';
import 'package:pa2_kelompok07/services/api_service.dart';
import 'package:pa2_kelompok07/styles/color.dart';
import 'package:provider/provider.dart';
import '../laporan/detail_report_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with TextLogger {
  static const _pageSize = 10;
  late final String _accessToken;
  late final Future<void> Function(int) _onNotificationRead;
  late final PagingController<int, NotificationPayload> _pagingController;
  late final NotificationQueryProvider _notificationProvider;
  late final UserProvider userProvider;
  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    _notificationProvider = Provider.of<NotificationQueryProvider>(
      context,
      listen: false,
    );
    _accessToken = userProvider.userToken;
    _onNotificationRead = userProvider.markNotificationAsRead;
    _pagingController = PagingController<int, NotificationPayload>(
      getNextPageKey: (state) {
        final keys = state.keys;
        final pages = state.pages;
        if (keys == null) return 1;
        if (pages != null && pages.last.length < _pageSize) {
          return null;
        }
        return keys.last + 1;
      },
      fetchPage: (pageKey) async {
        if (pageKey == 1 && _notificationProvider.cachedNotifications != null) {
          debugLog("Menggunakan cache notifikasi");
          return _notificationProvider.cachedNotifications!;
        }

        try {
          final result = await APIService().fetchNotifications(
            _accessToken,
            pageKey,
            _pageSize,
          );

          final notifications =
              result['notifications'] as List<NotificationPayload>;

          if (pageKey == 1) {
            _notificationProvider.setCachedNotifications(notifications);
          }

          return notifications;
        } catch (e) {
          debugLog('Error fetching page $pageKey: $e');
          rethrow;
        }
      },
    );

    _pagingController.addListener(_showError);
  }

  Future<void> _showError() async {
    if (_pagingController.value.status == PagingStatus.subsequentPageError) {
      context.toast.showError("Gagal memuat notifikasi tambahan");
    }
  }

  Future<void> _refreshNotifications() async {
    _notificationProvider.clearCache();
    _pagingController.refresh();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshNotifications(),
            color: Colors.white,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refreshNotifications(),
        child: PagingListener(
          controller: _pagingController,
          builder:
              (
                context,
                state,
                fetchNextPage,
              ) => PagedListView<int, NotificationPayload>.separated(
                state: state,
                fetchNextPage: fetchNextPage,
                builderDelegate: PagedChildBuilderDelegate<NotificationPayload>(
                  animateTransitions: true,
                  itemBuilder:
                      (context, notification, index) => NotificationCard(
                        title: notification.title,
                        type: notification.type,
                        time: notification.createdAt,
                        isRead: notification.isRead,
                        onTap: () => _handleNotificationTap(notification),
                      ),
                  firstPageProgressIndicatorBuilder:
                      (_) => const Center(child: CircularProgressIndicator()),
                  newPageProgressIndicatorBuilder:
                      (_) => const Center(child: CircularProgressIndicator()),
                  firstPageErrorIndicatorBuilder:
                      (context) => PlaceHolderComponent(
                        state: PlaceHolderState.customError,
                      ),
                  newPageErrorIndicatorBuilder:
                      (context) => PlaceHolderComponent(
                        state: PlaceHolderState.customError,
                      ),
                  noItemsFoundIndicatorBuilder:
                      (context) => PlaceHolderComponent(
                        state: PlaceHolderState.noNotifications,
                      ),
                ),
                separatorBuilder: (context, index) => const Divider(height: 1),
              ),
        ),
      ),
    );
  }

  void _handleNotificationTap(NotificationPayload notification) async {
    debugLog('Notification tapped: ${notification.data}');

    if (!notification.isRead) {
      await markNotificationAsRead(notification.id);
    }

    if (!mounted) return;
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (alertDialogContext) {
        return NotificationDetail(
          notification: notification,
          onPressed: () {
            switch (notification.type) {
              case NotificationType.chat_message:
                ScreenNavigator(cx: context).navigate(
                  ClientChatPageSelf(
                    userId: userProvider.user?.id.toString() ?? "admin",
                    userRole: "client",
                    currentUserName: userProvider.user?.full_name ?? "Client",
                    userToken: userProvider.userToken,
                  ),
                  NavigatorTweens.rightToLeft(),
                );
                // Navigator.push(...);
                break;
              case NotificationType.appointment:
                // Navigator.push(...);

                break;
              case NotificationType.reportStatus:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => DetailClientReportScreen(
                          noRegistrasi: notification.data.reportId.toString(),
                        ),
                  ),
                );
                break;
              case NotificationType.trackingUpdate:
                ScreenNavigator(cx: context).navigate(
                  TrackingPage(
                    noRegistrasi: notification.data.reportId.toString(),
                  ),
                  NavigatorTweens.bottomToTop(),
                );
                break;
              case NotificationType.admin_notification:
                break;
              default:
                return context.toast.showError(
                  "Ada massalah, hubungi petugas ya",
                );
            }
          },
        );
      },
    );
  }

  Future<void> markNotificationAsRead(int notificationId) async =>
      await _onNotificationRead(notificationId);
}

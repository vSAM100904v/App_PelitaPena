import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/constant/constant.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/screen_navigator.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_style.dart';
import 'package:pa2_kelompok07/provider/user_provider.dart';
import 'package:pa2_kelompok07/screens/admin/reported_chat/reported_chat_page.dart';
import 'package:pa2_kelompok07/screens/client/chat/chat_client_screen.dart';
import 'package:pa2_kelompok07/screens/client/chat/rooms_client_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ChatAlert extends StatelessWidget {
  final VoidCallback? onReportTap; // onTap menjadi opsional
  final String title; // Judul dengan nilai default
  final String description; // Deskripsi dengan nilai default

  // Constructor dengan parameter opsional
  const ChatAlert({
    Key? key,
    this.onReportTap,
    this.title = "Chat yang tersedia", // Nilai default untuk title
    this.description =
        "Setiap percakapan Anda direkam. Harap diingat bahwa jika Anda mengirimkan pesan yang tidak pantas, tindakan akan diambil.", // Nilai default untuk description
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final textStyle = context.textStyle;

    return Container(
      padding: EdgeInsets.all(responsive.space(SizeScale.sm)),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(
          responsive.borderRadius(SizeScale.sm),
        ),
        border: Border.all(color: Colors.blue.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, // Menggunakan title dari parameter
                  style: textStyle.onestBold(
                    size: SizeScale.lg,
                    color: Colors.blue.shade800,
                  ),
                ),
                SizedBox(height: responsive.space(SizeScale.xs)),
                Text(
                  description, // Menggunakan description dari parameter
                  style: textStyle.dmSansRegular(
                    size: SizeScale.xs,
                    color: Colors.blue.shade700,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
          SizedBox(width: responsive.space(SizeScale.sm)),
          if (onReportTap !=
              null) // Menampilkan ikon hanya jika onReportTap tidak null
            GestureDetector(
              onTap: onReportTap,
              child: Container(
                padding: EdgeInsets.all(responsive.space(SizeScale.xs)),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.report,
                  color: Colors.blue.shade800,
                  size: responsive.space(SizeScale.lg),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AdminChatListScreen extends StatelessWidget {
  const AdminChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userAdmin = Provider.of<UserProvider>(context, listen: false);
    final textStyle = context.textStyle;
    final responsive = context.responsive;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.all(context.responsive.space(SizeScale.md)),
        child: Column(
          spacing: responsive.space(SizeScale.sm),
          children: [
            // In your widget build method:
            ChatAlert(
              onReportTap: () {
                ScreenNavigator(cx: context).navigate(
                  ReportedChatPage(userToken: userAdmin.userToken),
                  NavigatorTweens.bottomToTop(),
                );
              },
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('chats')
                        .orderBy('lastMessageTimestamp', descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print('AdminChatListScreen error: ${snapshot.error}');
                    return Center(
                      child: Text(
                        'Error loading chats',
                        style: textStyle.jakartaSansMedium(size: SizeScale.md),
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    print('AdminChatListScreen: No data yet');
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurple,
                        strokeWidth: 2,
                      ),
                    );
                  }

                  final chats = snapshot.data!.docs;
                  print('AdminChatListScreen: Received ${chats.length} chats');

                  return ListView.separated(
                    itemCount: chats.length,
                    separatorBuilder:
                        (context, index) =>
                            SizedBox(height: responsive.space(SizeScale.xs)),
                    itemBuilder: (context, index) {
                      final chat = chats[index].data() as Map<String, dynamic>;

                      final hasUnread = chat['unreadByAdmin'] == true;

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            responsive.borderRadius(SizeScale.xs),
                          ),
                          side: BorderSide(
                            color: Colors.grey.withOpacity(
                              0.5,
                            ), // Ganti dengan warna yang diinginkan
                            width: 1.0, // Ketebalan border
                          ),
                        ),
                        color: Colors.white,
                        shadowColor: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                            responsive.borderRadius(SizeScale.xs),
                          ),
                          onTap: () {
                            ScreenNavigator(cx: context).navigate(
                              ClientChatPageSelf(
                                userId:
                                    userAdmin.user?.id.toString() ?? "admin",
                                userRole: "admin",
                                adminSelectedChatId: chat['clientId'],
                                userToken: userAdmin.userToken,
                                currentUserName:
                                    userAdmin.user?.full_name ?? "Admin",
                              ),
                              // ReportedChatPage(userToken: userAdmin.userToken),
                              NavigatorTweens.rightToLeft(),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(
                              responsive.space(SizeScale.sm),
                            ),
                            child: Row(
                              children: [
                                // Avatar
                                Container(
                                  width: responsive.space(SizeScale.xxl),
                                  height: responsive.space(SizeScale.xxl),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade600.withOpacity(
                                      0.2,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      chat['clientName']?.isNotEmpty == true
                                          ? chat['clientName'][0].toUpperCase()
                                          : '?',
                                      style: textStyle.onestBold(
                                        size: SizeScale.lg,
                                        color: Colors.blue.shade600,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(width: responsive.space(SizeScale.sm)),

                                // Chat info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            chat['clientName'] ??
                                                'Unknown Client',
                                            style: textStyle.jakartaSansMedium(
                                              size: SizeScale.md,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (hasUnread)
                                            Container(
                                              padding: EdgeInsets.all(
                                                responsive.space(SizeScale.xs) /
                                                    2,
                                              ),
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            responsive.space(SizeScale.xs) / 2,
                                      ),
                                      Text(
                                        chat['lastMessage'] ??
                                            'No messages yet',
                                        style: textStyle.dmSansRegular(
                                          size: SizeScale.sm,
                                          color: Colors.grey.shade600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(width: responsive.space(SizeScale.sm)),

                                // Timestamp or arrow
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey.shade400,
                                  size: responsive.space(SizeScale.lg),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

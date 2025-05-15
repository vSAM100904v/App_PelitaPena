import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as img;
import 'package:intl/intl.dart';
import 'package:pa2_kelompok07/core/controller/firebase_chat_controller.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/message.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/messangger.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/screen_navigator.dart';
import 'package:pa2_kelompok07/core/helpers/toasters/toast.dart';
import 'package:pa2_kelompok07/core/models/message_model.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/atoms/placeholder_component.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/modals/chat_menu_modal.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/modals/chat_reported_modal.dart';

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:dash_chat_2/dash_chat_2.dart' as dash;
import 'package:pa2_kelompok07/core/persentation/widgets/modals/image_modal.dart';
import 'package:pa2_kelompok07/utils/loading_dialog.dart';

class ClientChatPageSelf extends StatefulWidget {
  final String userId;
  final String userRole;
  final String? adminSelectedChatId;
  final String userToken;
  final String currentUserName;

  const ClientChatPageSelf({
    Key? key,
    required this.userId,
    required this.userRole,
    this.adminSelectedChatId,
    required this.userToken,
    required this.currentUserName,
  }) : super(key: key);

  @override
  ClientChatPageSelfState createState() => ClientChatPageSelfState();
}

class ClientChatPageSelfState extends State<ClientChatPageSelf> {
  late final FirestoreChatController _firestoreChatController;
  String? _errorMessage;
  bool _isLoading = true;
  List<ChatUserDash> _participants = [];
  final ScrollController _scrollController = ScrollController();
  late dash.ChatUser _currentDashUser;
  final TextEditingController _textController = TextEditingController();
  final img.ImagePicker _picker = img.ImagePicker();
  Timer? _typingTimer;
  bool _isUploadingImage = false;
  @override
  void initState() {
    super.initState();
    print(
      'Initializing ClientChatPageSelf with userId: ${widget.userId}, userRole: ${widget.userRole}, adminSelectedChatId: ${widget.adminSelectedChatId}, username: ${widget.currentUserName}',
    );
    _firestoreChatController = FirestoreChatController(
      currentUserId: widget.userId,
      currentUserRole: widget.userRole,
      adminSelectedChatId: widget.adminSelectedChatId,
      currentUserName: widget.currentUserName,
      userToken: widget.userToken,
    );
    _currentDashUser = dash.ChatUser(
      id: widget.userId,
      firstName: widget.currentUserName,
      profileImage:
          widget.userRole == 'admin'
              ? 'https://firebasestorage.googleapis.com/v0/b/molteo-40978.appspot.com/o/female_profile.jpg'
              : 'https://firebasestorage.googleapis.com/v0/b/molteo-40978.appspot.com/o/male_profile.jpg',
    );
    _textController.addListener(_handleTyping);
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final chatId =
          widget.userRole == "client"
              ? widget.userId
              : widget.adminSelectedChatId ?? widget.userId;
      final participants = await _firestoreChatController.getParticipants(
        chatId,
      );
      print('Participants fetched: ${participants.map((p) => p.id).toList()}');
      await _firestoreChatController.markMessagesAsRead();
      setState(() {
        _participants = participants;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      print('Error initializing: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to initialize chat: $e';
      });
    }
  }

  void _handleTyping() {
    if (_textController.text.isNotEmpty) {
      _firestoreChatController.updateTypingStatus(true);
      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 3), () {
        _firestoreChatController.updateTypingStatus(false);
      });
    } else {
      _firestoreChatController.updateTypingStatus(false);
      _typingTimer?.cancel();
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: img.ImageSource.gallery,
      );
      if (image != null) {
        showLoadingAnimated(context);
        await _firestoreChatController.insertImageMessage(image, (success) {
          if (success) {
            // _scrollController.animateTo(
            //   0,
            //   duration: const Duration(milliseconds: 300),
            //   curve: Curves.easeOut,
            // );
            context.toast.showSuccess('Image uploaded successfully');
          } else {
            context.toast.showError('Failed to upload image');
          }
        });
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      print('Error picking/uploading image: $e');
      CustomMessenger.show(context: context, message: 'Failed to upload image');
    } finally {
      closeLoadingDialog(context);
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_handleTyping);
    _textController.dispose();
    _typingTimer?.cancel();
    _scrollController.dispose();
    _firestoreChatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        widget.userRole == "admin"
            ? const Color(0xFF1E88E5)
            : const Color(0xFF57CC99);
    final backgroundColor = primaryColor.withOpacity(0.1);
    final textFieldBackgroundColor = primaryColor.withOpacity(0.3);
    final replyPopupColor = primaryColor.withOpacity(0.4);
    final replyPopupTopBorderColor = primaryColor.withOpacity(0.7);
    final textColor = Colors.white;
    final incomingBubbleColor = primaryColor.withOpacity(0.6);

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: PlaceHolderComponent(
            state: PlaceHolderState.errorFetchingMessages,
          ),
        ),
      );
    }

    return Theme(
      data: ThemeData(
        appBarTheme: AppBarTheme(
          color: primaryColor,
          titleTextStyle: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: textColor),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _participants.any((p) => p.id != widget.userId)
                ? _participants.firstWhere((p) => p.id != widget.userId).name
                : 'Chat',
          ),
        ),
        body: Container(
          color: backgroundColor,
          child: StreamBuilder<List<Message>>(
            stream: _firestoreChatController.messagesStream,
            builder: (context, messageSnapshot) {
              if (messageSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (messageSnapshot.hasError) {
                print('Stream error: ${messageSnapshot.error}');
                return Center(child: Text('Error: ${messageSnapshot.error}'));
              }
              final messages = messageSnapshot.data ?? [];
              print('Rendering ${messages.length} messages');

              return StreamBuilder<List<String>>(
                stream: _firestoreChatController.typingUsersStream,
                builder: (context, typingSnapshot) {
                  if (typingSnapshot.hasError) {
                    print('Typing stream error: ${typingSnapshot.error}');
                  }
                  final typingUserIds = typingSnapshot.data ?? [];
                  final typingUsers =
                      _participants
                          .where(
                            (p) =>
                                typingUserIds.contains(p.id) &&
                                p.id != widget.userId,
                          )
                          .map((p) => p.toDashChatUser())
                          .toList();

                  final dashMessages =
                      messages.map((m) {
                        final user = _participants.firstWhere(
                          (p) => p.id == m.sentBy,
                          orElse:
                              () => ChatUserDash(
                                id: m.sentBy,
                                name: 'Unknown User',
                                profilePhoto: '',
                              ),
                        );
                        return m.toDashChatMessage(user.toDashChatUser());
                      }).toList();

                  return dash.DashChat(
                    currentUser: _currentDashUser,
                    onSend: (dash.ChatMessage m) async {
                      await _firestoreChatController.insertMessage(m.text);
                      _textController.clear();
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                    messages: dashMessages,
                    typingUsers: typingUsers,

                    inputOptions: dash.InputOptions(
                      textController: _textController,
                      inputTextStyle: TextStyle(color: primaryColor),
                      inputDecoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: textFieldBackgroundColor,
                        hintText: 'Type a message...',
                        contentPadding: const EdgeInsets.only(
                          left: 18,
                          top: 10,
                          bottom: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                      sendOnEnter: true,
                      sendButtonBuilder:
                          (send) => IconButton(
                            icon: Icon(Icons.send, color: primaryColor),
                            onPressed: send,
                          ),
                      leading: [
                        IconButton(
                          icon: Icon(Icons.image, color: primaryColor),
                          onPressed: _pickAndUploadImage,
                        ),
                      ],
                      onMentionTriggers: ['@', '#'],
                    ),
                    messageOptions: dash.MessageOptions(
                      showTime: true,
                      timeFormat: DateFormat('HH:mm'),
                      currentUserContainerColor: primaryColor,
                      containerColor: incomingBubbleColor,
                      currentUserTextColor: textColor,
                      textColor: textColor,
                      timeTextColor: textColor,
                      messagePadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                      // repliedMessageColor: primaryColor,
                      // repliedTitleColor: textColor,
                      timePadding: const EdgeInsets.only(top: 2),
                      timeFontSize: 8,
                      onTapMedia: (media) async {
                        ScreenNavigator(cx: context).navigate(
                          FlutterFlowExpandedImageView(
                            image: CachedNetworkImage(
                              imageUrl: media.url,

                              fit: BoxFit.contain,
                            ),
                            allowRotation: false,
                            tag: media.url,
                            useHeroAnimation: true,
                          ),
                          NavigatorTweens.rightToLeft(),
                        );
                      },

                      onLongPressMessage: (dash.ChatMessage m) {
                        showModalBottomSheet(
                          context: context,
                          builder:
                              (_) => BottomSheetMenu(
                                currentRole: widget.userRole,
                                isSelfMessage: m.user.id == widget.userId,
                                isImage:
                                    m.customProperties?["messageType"] ==
                                            "image"
                                        ? true
                                        : false,
                                onAction: (action) {
                                  switch (action) {
                                    case ClickedAction.copy:
                                      Clipboard.setData(
                                        ClipboardData(
                                          text:
                                              m.medias != null &&
                                                      m.medias?.first.type ==
                                                          dash.MediaType.image
                                                  ? m.medias!.first.url
                                                  : m.text,
                                        ),
                                      );
                                      CustomMessenger.show(
                                        context: context,
                                        message: "Clipboard Copied!",
                                      );
                                      break;
                                    case ClickedAction.report:
                                      ReportBottomSheet.show(
                                        context: context,
                                        currentRole: widget.userRole,
                                        sourceId: m.user.id,
                                        messageContent: m.text,
                                        chatMessageId:
                                            m.customProperties?["messageID"],
                                        authToken: widget.userToken,
                                      );
                                    case ClickedAction.deleted:
                                      _firestoreChatController.deleteMessage(
                                        m.customProperties?["messageID"],
                                      );
                                      break;
                                  }
                                },
                              ),
                        );
                      },
                    ),
                    quickReplyOptions: dash.QuickReplyOptions(
                      onTapQuickReply: (dash.QuickReply r) async {
                        final dash.ChatMessage m = dash.ChatMessage(
                          user: _currentDashUser,
                          text: r.value ?? r.title,
                          createdAt: DateTime.now(),
                          // messageId: const Uuid().v4(),
                        );
                        await _firestoreChatController.insertMessage(m.text);
                        _scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      },
                      quickReplyStyle: BoxDecoration(
                        color: replyPopupColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: replyPopupTopBorderColor),
                      ),
                      quickReplyTextStyle: TextStyle(color: primaryColor),
                    ),
                    messageListOptions: dash.MessageListOptions(
                      scrollController: _scrollController,
                      showDateSeparator: true,
                      dateSeparatorFormat: DateFormat('dd MMM yyyy'),
                      dateSeparatorBuilder:
                          (date) => dash.DefaultDateSeparator(
                            date: date,
                            textStyle: TextStyle(
                              color: replyPopupColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      onLoadEarlier: () async {
                        await Future.delayed(const Duration(seconds: 1));
                        print('Loading earlier messages...');
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

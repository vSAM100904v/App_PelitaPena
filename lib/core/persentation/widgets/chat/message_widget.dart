import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/config.dart';
import 'package:pa2_kelompok07/core/models/message_model.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/chat/reply_message_widget.dart';
import 'package:pa2_kelompok07/screens/client/chat/rooms_client_screen.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageWidget({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);
    final width = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!isMe)
          CircleAvatar(
            radius: 16,
            backgroundImage: CachedNetworkImageProvider(
              Config.maleFallbackImage,
            ),
          ),
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: width * 3 / 4),
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[100] : Colors.green[100],
            borderRadius:
                isMe
                    ? borderRadius.subtract(
                      BorderRadius.only(bottomRight: radius),
                    )
                    : borderRadius.subtract(
                      BorderRadius.only(bottomLeft: radius),
                    ),
          ),
          child: buildMessage(),
        ),
      ],
    );
  }

  Widget buildMessage() {
    final messageWidget = Text(message.message);

    if (message.replyMessage == null) {
      return messageWidget;
    } else {
      return Column(
        crossAxisAlignment:
            isMe && message.replyMessage == null
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
        children: <Widget>[buildReplyMessage(), messageWidget],
      );
    }
  }

  Widget buildReplyMessage() {
    final replyMessage = message.replyMessage;
    final isReplying = replyMessage != null;

    if (!isReplying) {
      return Container();
    } else {
      return Container(
        margin: EdgeInsets.only(bottom: 8),
        child: ReplyMessageWidget(message: message, onCancelReply: () {}),
      );
    }
  }
}

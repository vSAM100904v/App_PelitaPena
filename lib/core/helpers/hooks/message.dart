import 'package:dash_chat_2/dash_chat_2.dart' as dash;
import 'package:pa2_kelompok07/config.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/time_ago.dart';
import 'package:pa2_kelompok07/core/models/message_model.dart';

extension MessageToDashChatMessage on Message {
  dash.ChatMessage toDashChatMessage(dash.ChatUser user) {
    return dash.ChatMessage(
      text:
          messageType == MessageType.image
              ? message.contains("Thx")
                  ? message
                  : TimeAgo.format(createdAt)
              : message,
      user: user,
      createdAt: createdAt,

      status:
          status == MessageStatus.read
              ? dash.MessageStatus.read
              : status == MessageStatus.delivered
              ? dash.MessageStatus.received
              : dash.MessageStatus.pending,
      medias:
          messageType == MessageType.image && imageUrl != null
              ? [
                dash.ChatMedia(
                  url: imageUrl!,
                  fileName: 'image_${id}.jpg',
                  type: dash.MediaType.image,
                ),
              ]
              : null,

      replyTo:
          replyMessage.messageId.isNotEmpty
              ? dash.ChatMessage(
                text: replyMessage.message,
                user: dash.ChatUser(id: replyMessage.replyBy),
                createdAt: DateTime.now(),
              )
              : null,
      customProperties: {
        'reactions': reaction?.reactions ?? [],
        'reactedUserIds': reaction?.reactedUserIds ?? [],
        "messageID": id,
        "userID": user.id,
        "messageType": messageType == MessageType.image ? 'image' : 'text',
      },
      quickReplies:
          status == MessageStatus.delivered
              ? [
                dash.QuickReply(title: 'Great!'),
                dash.QuickReply(title: 'Awesome'),
                dash.QuickReply(title: 'Thanks!'),
              ]
              : null,
    );
  }
}

// Konversi ChatUser ke dash.ChatUser
extension ChatUserToDashChatUser on ChatUserDash {
  dash.ChatUser toDashChatUser() {
    return dash.ChatUser(
      id: id,
      firstName: name,
      profileImage:
          profilePhoto.isNotEmpty ? profilePhoto : Config.maleFallbackImage,
    );
  }
}

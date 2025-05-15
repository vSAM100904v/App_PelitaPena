// // Model data
// import 'package:cloud_firestore/cloud_firestore.dart';

// enum MessageType { text, image }

// enum MessageStatus { undelivered, delivered, read }

// class ReplyMessage {
//   final String messageId;
//   final String message;
//   final String replyBy;
//   final String replyTo;
//   final MessageType messageType;

//   const ReplyMessage({
//     this.messageId = '',
//     this.message = '',
//     this.replyBy = '',
//     this.replyTo = '',
//     this.messageType = MessageType.text,
//   });

//   Map<String, dynamic> toJson() => {
//     'messageId': messageId,
//     'text': message,
//     'replyBy': replyBy,
//     'replyTo': replyTo,
//     'messageType': messageType == MessageType.image ? 'image' : 'text',
//   };

//   factory ReplyMessage.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return const ReplyMessage();
//     return ReplyMessage(
//       messageId: json['messageId'] as String? ?? '',
//       message: json['text'] as String? ?? '',
//       replyBy: json['replyBy'] as String? ?? '',
//       replyTo: json['replyTo'] as String? ?? '',
//       messageType:
//           json['messageType'] == 'image' ? MessageType.image : MessageType.text,
//     );
//   }
// }

// class Reaction {
//   final List<String> reactions;
//   final List<String> reactedUserIds;

//   const Reaction({required this.reactions, required this.reactedUserIds});

//   factory Reaction.fromJson(Map<String, dynamic>? json) {
//     return Reaction(
//       reactions: json != null ? List<String>.from(json['reactions'] ?? []) : [],
//       reactedUserIds:
//           json != null ? List<String>.from(json['reactedUserIds'] ?? []) : [],
//     );
//   }
// }

// class Message {
//   final String id;
//   final String message;
//   final DateTime createdAt;
//   final String sentBy;
//   final MessageStatus status;
//   final MessageType messageType;
//   final ReplyMessage replyMessage;
//   final Reaction? reaction;

//   Message({
//     required this.id,
//     required this.message,
//     required this.createdAt,
//     required this.sentBy,
//     required this.status,
//     this.messageType = MessageType.text,
//     this.replyMessage = const ReplyMessage(),
//     this.reaction,
//   });

//   factory Message.fromJson(Map<String, dynamic> data) {
//     return Message(
//       id: data['messageId'] as String,
//       message: data['text'] as String,
//       createdAt: (data['createdAt'] as Timestamp).toDate(),
//       sentBy: data['authorId'] as String,
//       status: _mapFirestoreStatus(data),
//       messageType:
//           data['messageType'] == 'image' ? MessageType.image : MessageType.text,
//       replyMessage: ReplyMessage.fromJson(
//         data['replyMessage'] as Map<String, dynamic>?,
//       ),
//       reaction: Reaction.fromJson(data['reaction'] as Map<String, dynamic>?),
//     );
//   }

//   static MessageStatus _mapFirestoreStatus(Map<String, dynamic> data) {
//     if (data['isReadByAdmin'] == true && data['authorRole'] == 'admin') {
//       return MessageStatus.read;
//     } else if (data['isReadByClient'] == true &&
//         data['authorRole'] == 'client') {
//       return MessageStatus.read;
//     } else if (data['isReadByAdmin'] == false ||
//         data['isReadByClient'] == false) {
//       return MessageStatus.delivered;
//     }
//     return MessageStatus.undelivered;
//   }
// }

// class ChatUserDash {
//   final String id;
//   final String name;
//   final String profilePhoto;

//   ChatUserDash({
//     required this.id,
//     required this.name,
//     required this.profilePhoto,
//   });
// }

import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { text, image }

enum MessageStatus { undelivered, delivered, read }

class ReplyMessage {
  final String messageId;
  final String message;
  final String replyBy;
  final String replyTo;
  final MessageType messageType;

  const ReplyMessage({
    this.messageId = '',
    this.message = '',
    this.replyBy = '',
    this.replyTo = '',
    this.messageType = MessageType.text,
  });

  Map<String, dynamic> toJson() => {
    'messageId': messageId,
    'text': message,
    'replyBy': replyBy,
    'replyTo': replyTo,
    'messageType': messageType == MessageType.image ? 'image' : 'text',
  };

  factory ReplyMessage.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ReplyMessage();
    return ReplyMessage(
      messageId: json['messageId'] as String? ?? '',
      message: json['text'] as String? ?? '',
      replyBy: json['replyBy'] as String? ?? '',
      replyTo: json['replyTo'] as String? ?? '',
      messageType:
          json['messageType'] == 'image' ? MessageType.image : MessageType.text,
    );
  }
}

class Reaction {
  final List<String> reactions;
  final List<String> reactedUserIds;

  const Reaction({required this.reactions, required this.reactedUserIds});

  factory Reaction.fromJson(Map<String, dynamic>? json) {
    return Reaction(
      reactions: json != null ? List<String>.from(json['reactions'] ?? []) : [],
      reactedUserIds:
          json != null ? List<String>.from(json['reactedUserIds'] ?? []) : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'reactions': reactions,
    'reactedUserIds': reactedUserIds,
  };
}

class Message {
  final String id;
  final String message;
  final DateTime createdAt;
  final String sentBy;
  final String authorRole; // Tambahkan untuk menentukan role pengirim
  final MessageStatus status;
  final MessageType messageType;
  final ReplyMessage replyMessage;
  final Reaction? reaction;
  final String? imageUrl;
  Message({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.sentBy,
    required this.authorRole,
    required this.status,
    this.messageType = MessageType.text,
    this.replyMessage = const ReplyMessage(),
    this.reaction,
    this.imageUrl,
  });

  factory Message.fromJson(Map<String, dynamic> data) {
    return Message(
      id: data['messageId'] as String? ?? '',
      message: data['text'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      sentBy: data['authorId'] as String? ?? '',
      authorRole: data['authorRole'] as String? ?? 'client',
      status: _mapFirestoreStatus(data),
      messageType:
          data['messageType'] == 'image' ? MessageType.image : MessageType.text,
      replyMessage: ReplyMessage.fromJson(
        data['replyMessage'] as Map<String, dynamic>?,
      ),
      reaction: Reaction.fromJson(data['reaction'] as Map<String, dynamic>?),
      imageUrl: data['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'messageId': id,
    'text': message,
    'createdAt': Timestamp.fromDate(createdAt),
    'authorId': sentBy,
    'authorRole': authorRole,
    'messageType': messageType == MessageType.image ? 'image' : 'text',
    'replyMessage': replyMessage.toJson(),
    'reaction': reaction?.toJson(),
    'isReadByAdmin': status == MessageStatus.read && authorRole == 'admin',
    'isReadByClient': status == MessageStatus.read && authorRole == 'client',
    'imageUrl': imageUrl,
  };

  static MessageStatus _mapFirestoreStatus(Map<String, dynamic> data) {
    if (data['isReadByAdmin'] == true && data['authorRole'] == 'admin') {
      return MessageStatus.read;
    } else if (data['isReadByClient'] == true &&
        data['authorRole'] == 'client') {
      return MessageStatus.read;
    } else if (data['isReadByAdmin'] == false ||
        data['isReadByClient'] == false) {
      return MessageStatus.delivered;
    }
    return MessageStatus.undelivered;
  }
}

class ChatUserDash {
  final String id;
  final String name;
  final String profilePhoto;

  ChatUserDash({
    required this.id,
    required this.name,
    required this.profilePhoto,
  });
}

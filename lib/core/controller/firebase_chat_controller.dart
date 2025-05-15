import 'dart:convert';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:crypto/crypto.dart';
import 'package:pa2_kelompok07/config.dart';
import 'package:pa2_kelompok07/core/helpers/logger/logger.dart';
import 'package:pa2_kelompok07/services/api_service.dart';

// TODO: BAATAS
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:pa2_kelompok07/core/models/message_model.dart';
import 'package:http/http.dart' as http;
import 'package:cloudinary_url_gen/cloudinary.dart';

class FirestoreChatController {
  final String currentUserId;
  final String currentUserRole;
  final String? adminSelectedChatId;
  final String currentUserName;
  final String userToken;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final APIService _apiService = APIService.instance;
  final Logger _logger = Logger("FirebaseChatController");

  static const String _cloudName = 'dgnexszl2';
  static const String _apiKey = '228927731812515';
  static const String _uploadPreset = 'chat_app';
  static const String _apiSecret = "y1js3wYIec7qP8E-sBhkNF7n7Xs";

  FirestoreChatController({
    required this.currentUserId,
    required this.currentUserRole,
    this.adminSelectedChatId,
    required this.currentUserName,
    required this.userToken,
  }) {
    if (currentUserRole == "admin" && adminSelectedChatId == null) {
      _logger.log('Warning: adminSelectedChatId is null for admin role');
    }
  }

  // Stream untuk messages
  Stream<List<Message>> get messagesStream {
    final chatId =
        currentUserRole == "client"
            ? currentUserId
            : adminSelectedChatId ?? currentUserId;
    print('Fetching messages for chatId: $chatId');
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) {
          _logger.log(
            'Received snapshot with ${snapshot.docChanges.length} changes',
          );
          return snapshot.docs.map((doc) {
            final data = doc.data();
            _logger.log(
              'Processing message: ID=${data['messageId']}, authorId=${data['authorId']}, text=${data['text']}',
            );
            return Message.fromJson(data);
          }).toList();
        })
        .handleError((e) {
          _logger.log('Error streaming messages: $e');
          throw Exception('Failed to stream messages: $e');
        });
  }

  // Stream untuk typingUsers
  Stream<List<String>> get typingUsersStream {
    final chatId =
        currentUserRole == "client"
            ? currentUserId
            : adminSelectedChatId ?? currentUserId;
    _logger.log('Fetching typing users for chatId: $chatId');
    return _firestore
        .collection('chats')
        .doc(chatId)
        .snapshots()
        .map((snapshot) {
          final data = snapshot.data();
          final typingUsers = List<String>.from(data?['typingUsers'] ?? []);
          _logger.log('Typing users: $typingUsers');
          return typingUsers;
        })
        .handleError((e) {
          _logger.log('Error streaming typing users: $e');
          return [];
        });
  }

  // Fungsi untuk memperbarui status typing
  Future<void> updateTypingStatus(bool isTyping) async {
    try {
      final chatId =
          currentUserRole == "client"
              ? currentUserId
              : adminSelectedChatId ?? currentUserId;
      _logger.log('Updating typing status for user $currentUserId: $isTyping');
      await _firestore.collection('chats').doc(chatId).set({
        'typingUsers':
            isTyping
                ? FieldValue.arrayUnion([currentUserId])
                : FieldValue.arrayRemove([currentUserId]),
      }, SetOptions(merge: true));
    } catch (e) {
      _logger.log('Error updating typing status: $e');
    }
  }

  // Fungsi untuk menyisipkan pesan teks
  Future<void> insertMessage(String text) async {
    try {
      final chatId =
          currentUserRole == "client"
              ? currentUserId
              : adminSelectedChatId ?? currentUserId;
      final messageId = const Uuid().v4();
      _logger.log('Inserting message with ID: $messageId for chatId: $chatId');

      // Tambahkan "Thx, <nama depan>" untuk admin
      String finalText = text;
      if (currentUserRole == "admin") {
        final firstName =
            currentUserName.isNotEmpty
                ? currentUserName.split(' ').first
                : 'Admin';
        finalText = '$text\nThx 😊, $firstName';
      }

      final messageData = {
        'messageId': messageId,
        'authorId': currentUserId,
        'authorRole': currentUserRole,
        'text': finalText,
        'createdAt': Timestamp.now(),
        'isReadByAdmin': currentUserRole == "admin",
        'isReadByClient': currentUserRole == "client",
        'messageType': 'text',
        'reaction': {'reactions': [], 'reactedUserIds': []},
      };

      final chatRef = _firestore.collection('chats').doc(chatId);
      final batch = _firestore.batch();

      batch.set(chatRef.collection('messages').doc(messageId), messageData);
      batch.set(chatRef, {
        'clientId': chatId,
        'clientName':
            currentUserRole == "client"
                ? currentUserName
                : (await chatRef.get()).data()?['clientName'] ??
                    'Unknown Client',
        'lastMessage': finalText,
        'lastMessageTimestamp': Timestamp.now(),
        'unreadByAdmin': currentUserRole == "client",
        'unreadByClient': currentUserRole == "admin",
        'participants': FieldValue.arrayUnion([
          {
            'userId': currentUserId,
            'role': currentUserRole,
            'username': currentUserName,
          },
        ]),
        'typingUsers': FieldValue.arrayRemove([currentUserId]),
      }, SetOptions(merge: true));

      await batch.commit();

      if (currentUserRole == "admin") {
        final clientIdInt = int.tryParse(chatId) ?? 0;
        if (clientIdInt > 0) {
          await _apiService.sendPushNotification(
            accessToken: userToken,
            clientId: clientIdInt,
            title: "New Message from Admin",
            body:
                finalText.length > 50
                    ? '${finalText.substring(0, 47)}...'
                    : finalText,
            type: "chat_message",
            data: {
              "chatId": chatId,
              "messageId": messageId,
              "sender": currentUserName,
            },
          );
          _logger.log(
            'Notification sent for message $messageId to client $clientIdInt',
          );
        } else {
          _logger.log('Invalid clientId for notification: $chatId');
        }
      }
    } catch (e) {
      _logger.log('Error inserting message or sending notification: $e');
      throw Exception('Failed to insert message: $e');
    }
  }

  // Fungsi untuk mengunggah dan menyisipkan pesan gambar
  Future<void> insertImageMessage(
    XFile imageFile,
    Function(bool) callback,
  ) async {
    try {
      final chatId =
          currentUserRole == "client"
              ? currentUserId
              : adminSelectedChatId ?? currentUserId;
      final messageId = const Uuid().v4();
      _logger.log(
        'Inserting image message with ID: $messageId for chatId: $chatId',
      );

      // Unggah gambar ke Cloudinary menggunakan http
      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
      );
      final request =
          http.MultipartRequest('POST', uri)
            ..fields['upload_preset'] = _uploadPreset
            ..fields['api_key'] = _apiKey
            ..files.add(
              await http.MultipartFile.fromPath('file', imageFile.path),
            );

      final response = await request.send();
      final responseBody = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseBody);
      final responseData = jsonDecode(responseString);

      if (response.statusCode != 200) {
        _logger.log('Cloudinary upload failed: $responseBody');
        callback(false);
        throw Exception(
          'Failed to upload image to Cloudinary: ${responseData['error']['message']}',
        );
      }
      _logger.log(
        'Image uploaded to Cloudinary and their response is: $responseData',
      );
      final imageUrl = responseData['url'] as String;
      _logger.log('Image uploaded to Cloudinary: $imageUrl');

      // Tambahkan "Thx, <nama depan>" untuk admin
      String caption = '';
      if (currentUserRole == "admin") {
        final firstName =
            currentUserName.isNotEmpty
                ? currentUserName.split(' ').first
                : 'Admin';
        caption = 'Thx 😊, $firstName';
      }

      final messageData = {
        'messageId': messageId,
        'authorId': currentUserId,
        'authorRole': currentUserRole,
        "imageUrl": imageUrl,
        'text':
            currentUserRole == "admin"
                ? caption
                : "", // Simpan URL gambar di field text
        'createdAt': Timestamp.now(),
        'isReadByAdmin': currentUserRole == "admin",
        'isReadByClient': currentUserRole == "client",
        'messageType': 'image',
        'reaction': {'reactions': [], 'reactedUserIds': []},
        'caption': caption, // Simpan caption untuk admin
      };

      final chatRef = _firestore.collection('chats').doc(chatId);
      final batch = _firestore.batch();

      batch.set(chatRef.collection('messages').doc(messageId), messageData);
      batch.set(chatRef, {
        'clientId': chatId,
        'clientName':
            currentUserRole == "client"
                ? currentUserName
                : (await chatRef.get()).data()?['clientName'] ??
                    'Unknown Client',
        'lastMessage': 'Image${caption.isNotEmpty ? '\n$caption' : ''}',
        'lastMessageTimestamp': Timestamp.now(),
        'unreadByAdmin': currentUserRole == "client",
        'unreadByClient': currentUserRole == "admin",
        'participants': FieldValue.arrayUnion([
          {
            'userId': currentUserId,
            'role': currentUserRole,
            'username': currentUserName,
          },
        ]),
        'typingUsers': FieldValue.arrayRemove([currentUserId]),
      }, SetOptions(merge: true));

      await batch.commit();

      // Kirim notifikasi jika pengirim adalah admin
      if (currentUserRole == "admin") {
        final clientIdInt = int.tryParse(chatId) ?? 0;
        if (clientIdInt > 0) {
          await _apiService.sendPushNotification(
            accessToken: userToken,
            clientId: clientIdInt,
            title: "New Image from Admin",
            body: caption.isNotEmpty ? caption : 'New image received',
            type: "chat_image",
            data: {
              "chatId": chatId,
              "messageId": messageId,
              "sender": currentUserName,
              "imageUrl": imageUrl,
            },
          );
          print(
            'Notification sent for image message $messageId to client $clientIdInt',
          );
        } else {
          callback(false);

          print('Invalid clientId for notification: $chatId');
        }
      }
      callback(true);
    } catch (e) {
      callback(false);

      print('Error inserting image message: $e');
      throw Exception('Failed to insert image message: $e');
    }
  }

  Future<void> markMessagesAsRead() async {
    try {
      final chatId =
          currentUserRole == "client"
              ? currentUserId
              : adminSelectedChatId ?? currentUserId;
      print('Marking messages as read for chatId: $chatId');
      final batch = _firestore.batch();
      final messages =
          await _firestore
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .where(
                currentUserRole == "admin" ? 'isReadByAdmin' : 'isReadByClient',
                isEqualTo: false,
              )
              .get();
      for (var doc in messages.docs) {
        batch.update(doc.reference, {
          currentUserRole == "admin" ? 'isReadByAdmin' : 'isReadByClient': true,
        });
      }
      batch.update(_firestore.collection('chats').doc(chatId), {
        currentUserRole == "admin" ? 'unreadByAdmin' : 'unreadByClient': false,
      });
      await batch.commit();
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  Future<List<ChatUserDash>> getParticipants(String chatId) async {
    print('Fetching participants for chatId: $chatId');
    try {
      final chatDoc = await _firestore.collection('chats').doc(chatId).get();
      final participantsData = List<Map<String, dynamic>>.from(
        chatDoc.data()?['participants'] ?? [],
      );
      print('Raw participants data: $participantsData');

      return participantsData.map((data) {
        return ChatUserDash(
          id: data['userId'] as String,
          name:
              data['username'] as String? ??
              (data['role'] == 'admin' ? 'Admin ${data['userId']}' : 'Client'),
          profilePhoto: '',
        );
      }).toList();
    } catch (e) {
      print('Error fetching participants: $e');
      return [];
    }
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      final chatId =
          currentUserRole == "client"
              ? currentUserId
              : adminSelectedChatId ?? currentUserId;
      print('Deleting message with ID: $messageId for chatId: $chatId');

      // Ambil dokumen pesan untuk validasi
      final messageRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId);
      final messageSnapshot = await messageRef.get();

      if (!messageSnapshot.exists) {
        print('Message $messageId not found');
        throw Exception('Message not found');
      }

      final messageData = messageSnapshot.data()!;
      final authorId = messageData['authorId'] as String;

      // Validasi: Hanya pengirim atau admin yang bisa menghapus
      if (authorId != currentUserId && currentUserRole != "admin") {
        print(
          'User $currentUserId is not authorized to delete message $messageId',
        );
        throw Exception('You are not authorized to delete this message');
      }
      // TODO:Handle Deleted Cloudinar
      // if (messageData['messageType'] == 'image') {
      //   final imageUrl = messageData['imageUrl'] as String;
      //   final timestamp =
      //       (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      //   final signatureString =
      //       'public_id="bms70letqe8ieblrirhl"&timestamp=$timestamp$_apiSecret';
      //   final signature = sha1.convert(utf8.encode(signatureString)).toString();

      //   final deleteUri = Uri.parse(
      //     'https://api.cloudinary.com/v1_1/$_cloudName/image/destroy',
      //   );
      //   final response = await http.post(
      //     deleteUri,
      //     headers: {'Content-Type': 'application/json'},
      //     body: jsonEncode({
      //       'public_id': "chats/eglxp2sqkh0r6w5qy9yg",
      //       'api_key': _apiKey,
      //       'timestamp': timestamp,
      //       'signature': signature,
      //     }),
      //   );
      //   _logger.log("Response from Deleting Message $response");
      //   // final response = await cloudinary.destroy(
      //   //   "chats/eglxp2sqkh0r6w5qy9yg",
      //   //   resourceType: CloudinaryResourceType.image,
      //   // );
      //   // // cloudinary.uploader().destroy(DestroyParams(publicId: publicId));
      //   // if (response.isSuccessful) {
      //   //   //Do something else
      //   //   _logger.log('Succesing to delete image: ${response.error!}');
      //   // } else {
      //   //   _logger.log('Failed to delete image: ${response.error!}');
      //   //   throw Exception('Failed to delete image: ${response.error!}');
      //   // }
      // }
      // Ambil pesan terakhir untuk memeriksa apakah pesan yang dihapus adalah pesan terakhir
      final messagesQuery =
          await _firestore
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .orderBy('createdAt', descending: true)
              .limit(2)
              .get();

      final batch = _firestore.batch();
      batch.delete(messageRef);

      // Perbarui lastMessage jika pesan yang dihapus adalah pesan terakhir
      final chatRef = _firestore.collection('chats').doc(chatId);
      if (messagesQuery.docs.isNotEmpty &&
          messagesQuery.docs.first.id == messageId) {
        String newLastMessage = '';
        Timestamp? newLastTimestamp;

        // Ambil pesan berikutnya (jika ada)
        if (messagesQuery.docs.length > 1) {
          final nextMessage = messagesQuery.docs[1].data();
          newLastMessage =
              nextMessage['messageType'] == 'image'
                  ? 'Image${nextMessage['caption']?.isNotEmpty ?? false ? '\n${nextMessage['caption']}' : ''}'
                  : nextMessage['text'] as String;
          newLastTimestamp = nextMessage['createdAt'] as Timestamp;
        }

        batch.set(chatRef, {
          'lastMessage': newLastMessage,
          'lastMessageTimestamp': newLastTimestamp ?? FieldValue.delete(),
        }, SetOptions(merge: true));
      }

      await batch.commit();
    } catch (e) {
      print('Error deleting message: $e');
      throw Exception('Failed to delete message: $e');
    }
  }

  void dispose() {
    print('Disposing FirestoreChatController');
  }
}

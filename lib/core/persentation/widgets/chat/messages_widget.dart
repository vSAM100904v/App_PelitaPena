// import 'package:flutter/material.dart';
// import 'package:pa2_kelompok07/screens/client/chat/rooms_client_screen.dart';

// import 'message_widget.dart';

// class MessagesWidget extends StatelessWidget {
//   final String idUser;
//   final ValueChanged<Message> onSwipedMessage;

//   const MessagesWidget({
//     required this.idUser,
//     required this.onSwipedMessage,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) => StreamBuilder<List<Message>>(
//     stream: FirebaseApi.getMessages(idUser),
//     builder: (context, snapshot) {
//       switch (snapshot.connectionState) {
//         case ConnectionState.waiting:
//           return Center(child: CircularProgressIndicator());
//         default:
//           if (snapshot.hasError) {
//             return buildText('Something Went Wrong Try later');
//           } else {
//             final messages = snapshot.data;

//             return messages.isEmpty
//                 ? buildText('Say Hi..')
//                 : ListView.builder(
//                   physics: BouncingScrollPhysics(),
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final message = messages[index];

//                     return SwipeTo(
//                       onRightSwipe: () => onSwipedMessage(message),
//                       child: MessageWidget(
//                         message: message,
//                         isMe: message.idUser == myId,
//                       ),
//                     );
//                   },
//                 );
//           }
//       }
//     },
//   );

//   Widget buildText(String text) =>
//       Center(child: Text(text, style: TextStyle(fontSize: 24)));
// }

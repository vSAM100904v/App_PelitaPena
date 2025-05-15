import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/models/message_model.dart';
import 'package:pa2_kelompok07/screens/client/chat/rooms_client_screen.dart';

class ReplyMessageWidget extends StatelessWidget {
  final Message message;
  final VoidCallback onCancelReply;

  const ReplyMessageWidget({
    required this.message,
    required this.onCancelReply,
    super.key,
  });

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      children: [
        Container(color: Colors.green, width: 4),
        const SizedBox(width: 8),
        Expanded(child: buildReplyMessage()),
      ],
    ),
  );

  Widget buildReplyMessage() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              '${message.sentBy}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          if (onCancelReply != null)
            GestureDetector(
              child: Icon(Icons.close, size: 16),
              onTap: onCancelReply,
            ),
        ],
      ),
      const SizedBox(height: 8),
      Text(message.message, style: TextStyle(color: Colors.black54)),
    ],
  );
}

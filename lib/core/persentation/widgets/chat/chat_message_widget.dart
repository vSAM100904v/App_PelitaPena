import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pa2_kelompok07/core/models/message_model.dart';
import 'package:pa2_kelompok07/screens/client/chat/rooms_client_screen.dart';

class ChatMessageWidget extends StatelessWidget {
  final Message message;
  final bool isCurrentUser;
  final VoidCallback? onReact;
  final VoidCallback? onLongPress;

  const ChatMessageWidget({
    Key? key,
    required this.message,
    required this.isCurrentUser,
    this.onReact,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final timeFormat = DateFormat('h:mm a');

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment:
              isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                child: Column(
                  crossAxisAlignment:
                      isCurrentUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                  children: [
                    // Message bubble with animations
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isCurrentUser
                                ? theme.primaryColor.withOpacity(0.9)
                                : isDarkMode
                                ? Colors.grey[800]
                                : Colors.grey[200],
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isCurrentUser ? 16 : 4),
                          bottomRight: Radius.circular(isCurrentUser ? 4 : 16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.message,
                            style: TextStyle(
                              fontSize: 16,
                              color: isCurrentUser ? Colors.white : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Timestamp and status
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                timeFormat.format(message.createdAt),
                                style: TextStyle(
                                  fontSize: 11,
                                  color:
                                      isCurrentUser
                                          ? Colors.white.withOpacity(0.8)
                                          : Colors.grey[600],
                                ),
                              ),
                              if (isCurrentUser) ...[
                                const SizedBox(width: 4),
                                Icon(
                                  message.status == MessageStatus.read
                                      ? Icons.done_all
                                      : Icons.done,
                                  size: 14,
                                  color:
                                      message.status == MessageStatus.read
                                          ? Colors.blue[200]
                                          : Colors.white.withOpacity(0.6),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Reactions
                    if (message.reaction != null &&
                        message.reaction!.reactions.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isDarkMode
                                    ? Colors.grey[700]
                                    : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Wrap(
                            spacing: 4,
                            children:
                                message.reaction!.reactions
                                    .map(
                                      (emoji) => Text(
                                        emoji,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

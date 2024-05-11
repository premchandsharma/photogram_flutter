import 'package:flutter/material.dart';
import 'package:photogram_flutter/models/message.dart';
import 'package:photogram_flutter/providers/user_provider.dart';
import 'package:photogram_flutter/widgets/message_bubble.dart';
import 'package:provider/provider.dart';

class ChatMessages extends StatelessWidget {
  ChatMessages({super.key, required this.receiverId});

  final String receiverId;

  // Test messages end
  @override
  Widget build(BuildContext context) => Consumer<UserProvider>(
        builder: (context, value, child) => value.messages.isEmpty
            ? Expanded(
                child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.waving_hand), Text('Say, hello!')],
                ),
              ))
            : Expanded(
                child: ListView.builder(
                  controller: Provider.of<UserProvider>(context, listen: false)
                      .scrollController,
                  itemCount: value.messages.length,
                  itemBuilder: (context, index) {
                    final isTextMessage =
                        value.messages[index].messageType == MessageType.text;

                    final isMe = receiverId != value.messages[index].senderId;
                    return isTextMessage
                        ? MessageBubble(
                            isMe: isMe,
                            message: value.messages[index],
                            isImage: false,
                            photoUrl: value.chatuser!.photoUrl,
                          )
                        : MessageBubble(
                            isMe: isMe,
                            message: value.messages[index],
                            isImage: true,
                            photoUrl: value.chatuser!.photoUrl,
                          );
                  },
                ),
              ),
      );
}

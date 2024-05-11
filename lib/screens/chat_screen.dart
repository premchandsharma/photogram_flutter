import 'package:flutter/material.dart';
import 'package:photogram_flutter/providers/user_provider.dart';
import 'package:photogram_flutter/utils/colors.dart';
import 'package:photogram_flutter/widgets/chat_messages.dart';
import 'package:photogram_flutter/widgets/chat_text_field.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.userId});

  final String userId;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false)
      ..getUserById(widget.userId)
      ..getMessages(widget.userId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            ChatMessages(receiverId: widget.userId),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: ChatTextField(receiverId: widget.userId),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
        // elevation: 0,
        backgroundColor: mobileBackgroundColor,
        title: Consumer<UserProvider>(
          builder: (context, value, child) => value.chatuser != null
              ? Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(value.chatuser!.photoUrl),
                      radius: 16,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        Text(
                          value.chatuser!.username,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  ],
                )
              : Center(child: const Text('Error in Chat Screen')),
        ),
      );
}

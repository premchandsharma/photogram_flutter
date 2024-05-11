import 'package:flutter/material.dart';
import 'package:photogram_flutter/models/message.dart';
import 'package:photogram_flutter/utils/colors.dart';

// import 'package:timeago/timeago.dart' as timeago;

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.isImage,
    required this.photoUrl,
  });

  final bool isMe;
  final bool isImage;
  final Message message;
  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      // child: Container(
      //   padding: EdgeInsets.symmetric(
      //     vertical: 8,
      //     horizontal: 12,
      //   ),
      //   margin: EdgeInsets.only(top: 2, right: 4, left: 4),
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(24),
      //     color: isMe ? blueColor : mobileSearchColor,
      //   ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          isImage
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isMe)
                      Container(
                        padding: EdgeInsets.only(right: 10, left: 6),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(photoUrl),
                          radius: 16,
                        ),
                      ),
                    Container(
                      margin: EdgeInsets.only(top: 3, right: 4),
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        image: DecorationImage(
                          image: NetworkImage(message.content),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isMe)
                      Container(
                        padding: EdgeInsets.only(right: 10, left: 6),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(photoUrl),
                          radius: 16,
                        ),
                      ),
                    Container(
                      margin: EdgeInsets.only(top: 3, right: 4),
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      constraints: BoxConstraints(maxWidth: 200),
                      child: Text(
                        message.content,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: isMe ? blueColor : mobileSearchColor,
                      ),
                    ),
                  ],
                ),
          // SizedBox(
          //   height: 5,
          // ),
          // Text(
          //   timeago.format(message.sentTime),
          //   style: TextStyle(
          //     color: Colors.white,
          //     fontSize: 10,
          //   ),
          // ),
        ],
      ),
    );
  }
}

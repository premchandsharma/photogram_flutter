import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photogram_flutter/resources/firestore_methods.dart';
import 'package:photogram_flutter/utils/colors.dart';
import 'package:photogram_flutter/utils/utils.dart';
import 'package:photogram_flutter/widgets/custom_text_form_field.dart';
import 'dart:typed_data';

class ChatTextField extends StatefulWidget {
  const ChatTextField({
    super.key,
    required this.receiverId,
  });

  final String receiverId;

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final controller = TextEditingController();

  Uint8List? file;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        color: mobileSearchColor,
      ),
      child: Row(
        children: [
          SizedBox(width: 6),
          CircleAvatar(
            backgroundColor: Color.fromRGBO(11, 140, 242, 1),
            radius: 22,
            child: IconButton(
              onPressed: () => _sendImage(),
              icon: Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: CustomTextFormField(
              controller: controller,
              hintText: 'Message...',
            ),
          ),
          // SizedBox(
          //   width: 55,
          //   height: 35,
          //   child: IconButton(
          //     onPressed: () => _sendText(context),
          //     icon: Icon(
          //       Icons.send,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
          SizedBox(
            width: 55,
            height: 38,
            child: ElevatedButton(
              onPressed: () => _sendText(context),
              child: Icon(
                Icons.send,
                size: 24,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(11, 140, 242, 1),
                foregroundColor: primaryColor,
                padding: EdgeInsets.only(left: 6),
              ),
            ),
          ),
          SizedBox(width: 6),
        ],
      ),
    );
    // Row(
    //   children: [
    //     Expanded(
    // child: CustomTextFormField(
    //         controller: controller,
    //         hintText: 'Message...',
    //       ),
    //     ),
    //     const SizedBox(width: 5),
    //     CircleAvatar(
    //       backgroundColor: blueColor,
    //       radius: 20,
    //       child: IconButton(
    //         onPressed: () => _sendText(context),
    //         icon: Icon(
    //           Icons.send,
    //           color: Colors.white,
    //         ),
    //       ),
    //     ),
    //     const SizedBox(width: 5),
    //     CircleAvatar(
    //       backgroundColor: blueColor,
    //       radius: 20,
    //       child: IconButton(
    //         onPressed: () => _sendImage(),
    //         icon: Icon(
    //           Icons.camera_alt,
    //           color: Colors.white,
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }

  Future<void> _sendText(BuildContext context) async {
    if (controller.text.isNotEmpty) {
      await FirestoreMethods.addTextMessage(
        receiverId: widget.receiverId,
        content: controller.text,
      );
      controller.clear();
      FocusScope.of(context).unfocus();
    }
    FocusScope.of(context).unfocus();
  }

  Future<void> _sendImage() async {
    Uint8List pickedImage = await pickImage(ImageSource.gallery);
    setState(() => file = pickedImage);

    if (file != null) {
      await FirestoreMethods.addImageMessage(
        receiverId: widget.receiverId,
        file: file!,
      );
    }
  }
}

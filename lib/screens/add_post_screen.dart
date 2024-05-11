import 'dart:typed_data';
import 'package:photogram_flutter/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photogram_flutter/providers/user_provider.dart';
import 'package:photogram_flutter/resources/firestore_methods.dart';
import 'package:photogram_flutter/utils/colors.dart';
import 'package:photogram_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  Uint8List? _file;

  bool _isLoading = false;

  void postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text, uid, _file!, username, profImage);

      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Posted!', context);
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create a post'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(
                  ImageSource.camera,
                );
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(
                  ImageSource.gallery,
                );
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  clearImage() {
    setState(() {
      _file = null;
      _descriptionController.clear();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return
        // _file == null
        //     ? Center(
        //         child: IconButton(
        //           onPressed: () => _selectImage(context),
        //           icon: const Icon(Icons.upload),
        //         ),
        //       )
        //     :
        Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: const Icon(
        //     Icons.close,
        //     size: 28,
        //     color: primaryColor,
        //   ),
        // ),
        title: Container(
          padding: EdgeInsets.only(left: 10),
          child: const Text(
            'New post',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: primaryColor,
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: _file == null
                ? () {}
                : () => postImage(
                      user.uid,
                      user.username,
                      user.photoUrl,
                    ),
            style: ElevatedButton.styleFrom(
              backgroundColor: blueColor,
              foregroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
            ),
            child: const Text(
              'Share',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _isLoading ? const LinearProgressIndicator() : Container(),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: InkWell(
                      onTap: () => _selectImage(context),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: _file == null
                              ? const DecorationImage(
                                  image: AssetImage(
                                    'assets/logo/upload.png',
                                  ),
                                )
                              : DecorationImage(
                                  image: MemoryImage(_file!),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    width: double.infinity,
                    child: TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Write a caption...',
                        border: InputBorder.none,
                      ),
                      maxLines: 4,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

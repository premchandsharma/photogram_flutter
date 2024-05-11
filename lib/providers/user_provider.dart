import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photogram_flutter/models/message.dart';
import 'package:photogram_flutter/models/user.dart';
import 'package:photogram_flutter/resources/auth_methods.dart';
import 'package:photogram_flutter/utils/global_variables.dart';

class UserProvider with ChangeNotifier {
  ScrollController scrollController = ScrollController();

  User? _user;

  final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

  User? chatuser;
  List<Message> messages = [];

  User? getUserById(String userid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userid)
        .snapshots(includeMetadataChanges: true)
        .listen((chatuser) {
      this.chatuser = User.fromSnap(chatuser);
      notifyListeners();
    });
    return chatuser;
  }

  List<Message> getMessages(String receiverId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseCurrentUser)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .orderBy('sentTime', descending: false)
        .snapshots(includeMetadataChanges: true)
        .listen((messages) {
      this.messages =
          messages.docs.map((doc) => Message.fromJson(doc.data())).toList();
      notifyListeners();

      scrollDown();
    });
    return messages;
  }

  void scrollDown() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photogram_flutter/screens/chat_screen.dart';
import 'package:photogram_flutter/utils/colors.dart';
import 'package:photogram_flutter/utils/utils.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  var userData = {};
  bool isLoading = false;

  // Future user data
  Future? _data;

  @override
  void initState() {
    super.initState();
    getData();
    _data = FirebaseFirestore.instance
        .collection('users')
        .where(
          Filter.or(
            Filter('followers', arrayContains: uid),
            Filter('following', arrayContains: uid),
          ),
        )
        .get();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var userSnap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      userData = userSnap.data()!;

      // setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(_data);
    final border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(38, 38, 38, 1),
      ),
      borderRadius: BorderRadius.circular(10),
    );

    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                userData['username'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: mobileBackgroundColor,
            ),
            body: Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: 10),
              child: Column(
                children: [
                  Container(
                    height: 36,
                    alignment: Alignment.center,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(38, 38, 38, 1),
                        contentPadding: EdgeInsets.only(top: 0),
                        hintText: 'Search',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        border: border,
                        focusedBorder: border,
                        enabledBorder: border,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 2),
                    child: Row(
                      children: [
                        Text(
                          'Messages',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: _data,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ListView.separated(
                          separatorBuilder: (context, index) => SizedBox(
                            height: 12,
                          ),
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      userId: (snapshot.data! as dynamic)
                                          .docs[index]['uid'],
                                    ),
                                  ),
                                );
                              },
                              child: ListTile(
                                // dense: true,
                                minLeadingWidth: 52,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 4),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['photoUrl'],
                                  ),
                                  radius: 25,
                                ),
                                title: Text(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['username'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                // subtitle: Text(
                                //   'Last Active : ${timeago.format(DateTime.now())}',
                                //   maxLines: 2,
                                //   style: TextStyle(
                                //     color: secondaryColor,
                                //     fontSize: 13.5,
                                //     fontWeight: FontWeight.w500,
                                //   ),
                                // ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

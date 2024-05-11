import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photogram_flutter/screens/messages_screen.dart';
import 'package:photogram_flutter/utils/colors.dart';
import 'package:photogram_flutter/utils/global_variables.dart';
import 'package:photogram_flutter/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 2),
      child: Scaffold(
        appBar: MediaQuery.of(context).size.width > webScreenSize
            ? null
            : AppBar(
                backgroundColor: mobileBackgroundColor,
                foregroundColor: primaryColor,
                title: const Text(
                  'Photogram',
                  style: TextStyle(
                    fontFamily: 'Billabong',
                    fontSize: 34,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MessagesScreen(),
                        ),
                      );
                    },
                    icon: Image.asset(
                      'assets/logo/dm.png',
                      height: 26,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => PostCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fA;
import 'package:flutter/material.dart';
import 'package:photogram_flutter/models/user.dart';
import 'package:photogram_flutter/providers/user_provider.dart';
import 'package:photogram_flutter/resources/firestore_methods.dart';
import 'package:photogram_flutter/screens/comments_screen.dart';
import 'package:photogram_flutter/screens/profile_screen.dart';
import 'package:photogram_flutter/utils/colors.dart';
import 'package:photogram_flutter/utils/global_variables.dart';
import 'package:photogram_flutter/utils/utils.dart';
import 'package:photogram_flutter/widgets/like_animation.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    super.key,
    required this.snap,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      // Will use stream for real time update
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      commentLen = snap.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isMe =
        widget.snap['uid'] == fA.FirebaseAuth.instance.currentUser!.uid;

    final User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      decoration: MediaQuery.of(context).size.width > webScreenSize
          ? BoxDecoration(
              color: mobileBackgroundColor,
              border: Border(
                top: BorderSide(
                  color: const Color.fromARGB(255, 86, 81, 81),
                  width: 0.1,
                ),
              ),
            )
          : BoxDecoration(
              color: mobileBackgroundColor,
            ),
      // color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 12,
              bottom: 4,
            ).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    widget.snap['profImage'],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                  uid: widget.snap['uid'],
                                ),
                              ),
                            );
                          },
                          child: Text(
                            widget.snap['username'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (isMe)
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            shrinkWrap: true,
                            children: [
                              'Delete',
                            ]
                                .map(
                                  (e) => InkWell(
                                    onTap: () async {
                                      FirestoreMethods()
                                          .deletePost(widget.snap['postId']);
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 16,
                                      ),
                                      child: Text(e),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      );
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Image section
          AspectRatio(
            aspectRatio: 1,
            child: GestureDetector(
              onDoubleTap: () async {
                await FirestoreMethods().likePost(
                  widget.snap['postId'],
                  user.uid,
                  widget.snap['likes'],
                );
                setState(() {
                  isLikeAnimating = true;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    // height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: Image.network(
                      widget.snap['postUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                      isAnimating: isLikeAnimating,
                      duration: const Duration(
                        milliseconds: 400,
                      ),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: primaryColor,
                        size: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Like Comment Section
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 2,
            ),
            child: Row(
              children: [
                LikeAnimation(
                  isAnimating: widget.snap['likes'].contains(user.uid),
                  smallLike: true,
                  child: IconButton(
                    onPressed: () async {
                      await FirestoreMethods().likePost(
                        widget.snap['postId'],
                        user.uid,
                        widget.snap['likes'],
                      );
                    },
                    icon: widget.snap['likes'].contains(user.uid)
                        ? Icon(
                            Icons.favorite,
                            size: 30,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.favorite_outline,
                            size: 30,
                            color: primaryColor,
                          ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                        snap: widget.snap,
                      ),
                    ),
                  ),
                  icon: Image.asset(
                    'assets/logo/comment.png',
                    height: 24,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    'assets/logo/share.png',
                    height: 22,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.bookmark_border_sharp,
                        size: 30,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Description and comments
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            width: double.infinity,
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.snap['likes'].length} likes',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: primaryColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 6,
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: widget.snap['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' ${widget.snap['description']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                          snap: widget.snap,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                    ),
                    child: Text(
                      'View all ${commentLen} comments',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    bottom: 6,
                  ),
                  child: Text(
                    timeago.format(
                      widget.snap['datePublished'].toDate(),
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: secondaryColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

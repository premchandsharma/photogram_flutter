import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photogram_flutter/screens/add_post_screen.dart';
import 'package:photogram_flutter/screens/feed_screen.dart';
import 'package:photogram_flutter/screens/notifications_screen.dart';
import 'package:photogram_flutter/screens/profile_screen.dart';
import 'package:photogram_flutter/screens/search_screen.dart';

const webScreenSize = 600;

final firebaseCurrentUser = FirebaseAuth.instance.currentUser!.uid;

List<Widget> homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  NotificationScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];

import 'package:flutter/material.dart';
import 'package:photogram_flutter/providers/user_provider.dart';
import 'package:photogram_flutter/screens/messages_screen.dart';
import 'package:photogram_flutter/utils/colors.dart';
import 'package:photogram_flutter/utils/global_variables.dart';
import 'package:photogram_flutter/models/user.dart' as model;
import 'package:provider/provider.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({
    super.key,
  });

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: MediaQuery.of(context).size.width > 900 ? 1 : 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: const Color.fromARGB(255, 86, 81, 81),
                    width: 0.5,
                  ),
                ),
              ),
              padding: EdgeInsets.only(left: 25, right: 15, top: 35),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        'Photogram',
                        style: TextStyle(
                          fontFamily: 'Billabong',
                          fontSize: 34,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 35,
                  ),

                  // Home button start
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          navigationTapped(0);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.home_filled,
                              size: 32,
                              color: _page == 0 ? primaryColor : secondaryColor,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              'Home',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color:
                                    _page == 0 ? primaryColor : secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                    ],
                  ),
                  // Home button end

                  // Search button start
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          navigationTapped(1);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              size: 32,
                              color: _page == 1 ? primaryColor : secondaryColor,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              'Search',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color:
                                    _page == 1 ? primaryColor : secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                    ],
                  ),
                  // Search button end

                  // Add post button start
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          navigationTapped(2);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_circle,
                              size: 32,
                              color: _page == 2 ? primaryColor : secondaryColor,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              'Add post',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color:
                                    _page == 2 ? primaryColor : secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                    ],
                  ),
                  // Add post button end

                  // Notifications button start
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          navigationTapped(3);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite_rounded,
                              size: 32,
                              color: _page == 3 ? primaryColor : secondaryColor,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              'Notifications',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color:
                                    _page == 3 ? primaryColor : secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                    ],
                  ),
                  // Notifications button end

                  // Profile button start
                  Column(
                    children: [
                      SizedBox(height: 3),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              navigationTapped(4);
                            },
                            child: Row(
                              children: [
                                SizedBox(width: 2),
                                CircleAvatar(
                                  // backgroundImage: NetworkImage(user.photoUrl),
                                  backgroundImage: NetworkImage(user.photoUrl),
                                  radius: 14,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  'Profile',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: _page == 4
                                        ? primaryColor
                                        : secondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 22,
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Profile button end

                  // Messages button start
                  Column(
                    children: [
                      SizedBox(height: 4),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MessagesScreen(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                SizedBox(width: 3),
                                Image.asset(
                                  'assets/logo/dm.png',
                                  height: 26,
                                  color: secondaryColor,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  'Messages',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 22,
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Messages button end
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Spacer(flex: 1),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: const Color.fromARGB(255, 86, 81, 81),
                        width: 0.5,
                      ),
                      left: BorderSide(
                        color: const Color.fromARGB(255, 86, 81, 81),
                        width: 0.5,
                      ),
                    ),
                  ),
                  constraints: BoxConstraints(
                    maxWidth:
                        MediaQuery.of(context).size.width > 800 ? 500 : 400,
                  ),
                  // Add the screens
                  child: PageView(
                    children: homeScreenItems,
                    controller: pageController,
                    onPageChanged: onPageChanged,
                  ),
                ),
                Spacer(flex: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

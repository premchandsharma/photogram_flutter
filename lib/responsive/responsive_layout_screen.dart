import 'package:flutter/material.dart';
import 'package:photogram_flutter/providers/user_provider.dart';
import 'package:photogram_flutter/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout({
    super.key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  });
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          return widget.webScreenLayout;
        } else {
          return widget.mobileScreenLayout;
        }
      },
    );
  }
}

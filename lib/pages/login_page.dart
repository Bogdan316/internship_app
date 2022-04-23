import 'package:flutter/material.dart';
import 'package:internship_app_fis/services/user_service.dart';

import 'login_tab.dart';

class LoginPage extends StatelessWidget {
  final UserService _userService;
  const LoginPage(this._userService, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // get Theme data at the begging to avoid redundant
    // calls to build
    var themeData = Theme.of(context);

    return DefaultTabController(
      // Create a tab for every role
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: themeData.primaryColor,
          title: const Text('Internship App'),
          bottom: TabBar(
            labelColor: themeData.primaryColor,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: const BoxDecoration(
              // Change the shape of the current tab indicator
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Colors.white,
            ),
            tabs: const [
              Tab(
                child: Text(
                  'Student',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Company',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Select the user's role based on the tab
            LoginTab('Student', _userService),
            LoginTab('Company', _userService),
          ],
        ),
      ),
    );
  }
}

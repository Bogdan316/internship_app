import 'package:flutter/material.dart';
import 'package:internship_app_fis/pages/applied_internships_page.dart';
import 'package:internship_app_fis/pages/ongoing_internships_page.dart';
import 'package:internship_app_fis/pages/profile_page.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../base_widgets/theme_color.dart';
import '../pages/add_new_internship_page.dart';
import '../models/user.dart';
import '../pages/login_page.dart';

class DrawerListTile extends StatelessWidget {
  // Builds a custom ListTile with InkWell animations to be used in the
  // main drawer of the app

  final String _title;
  final String _route;
  final IconData _icon;
  final Map<String, dynamic> _pageArgs;

  const DrawerListTile(this._icon, this._title, this._route, this._pageArgs,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: themeData.primaryColorLight,
          highlightColor: themeData.primaryColorLight,
          child: ListTile(
            iconColor: themeData.primaryColorDark,
            hoverColor: themeData.primaryColorLight,
            tileColor: ColorUtil.lightenColor(themeData.primaryColor, 0.7),
            // the next two lines are used to make the ListTile smaller
            dense: true,
            visualDensity: const VisualDensity(horizontal: -1, vertical: -1),
            horizontalTitleGap: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: Icon(
              _icon,
              size: 25,
            ),
            title: Text(
              _title,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          onTap: () {
            // closes the drawer before redirecting to the next page
            Navigator.of(context).pop();
            // passes the current arguments to the next page
            if (_route == LoginPage.namedRoute) {
              Navigator.of(context)
                  .pushReplacementNamed(_route, arguments: _pageArgs);
            } else {
              Navigator.of(context).pushNamed(_route, arguments: _pageArgs);
            }
          },
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}

class MainDrawer extends StatefulWidget {
  final Map<String, dynamic> _pageArgs;
  final void Function(bool) _toggleFunction;
  final bool _isCrtOngoing;
  const MainDrawer(this._pageArgs, this._toggleFunction, this._isCrtOngoing,
      {Key? key})
      : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  late int _initialToggleLabel;

  @override
  void initState() {
    super.initState();
    _initialToggleLabel = widget._isCrtOngoing ? 0 : 1;
  }

  // items that should be showed in the drawer when the user is a company
  final _companyDrawerItems = const [
    {
      'title': 'My Profile',
      'route': ProfilePage.namedRoute,
      'icon': Icons.person
    },
    {
      'title': 'Add New Internship',
      'route': AddNewInternshipPage.namedRoute,
      'icon': Icons.add_box
    },
    {
      'title': 'Ongoing Internships',
      'route': OngoingInternshipsPage.namedRoute,
      'icon': Icons.settings
    },
    {
      'title': 'Logout',
      'route': LoginPage.namedRoute,
      'icon': Icons.logout,
    }
  ];

  // items that should be showed in the drawer when the user is a student
  final _studentDrawerItems = const [
    {
      'title': 'My Profile',
      'route': ProfilePage.namedRoute,
      'icon': Icons.person
    },
    {
      'title': 'My Applications',
      'route': AppliedInternshipsPage.namedRoute,
      'icon': Icons.check
    },
    {
      'title': 'Logout',
      'route': LoginPage.namedRoute,
      'icon': Icons.logout,
    }
  ];

  @override
  Widget build(BuildContext context) {
    // get the current user
    final crtUser = widget._pageArgs['user'] as User;
    // decides the list that will be showed in the drawer based on the user's
    // role
    final drawerItems = crtUser.runtimeType == Student
        ? _studentDrawerItems
        : _companyDrawerItems;

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      backgroundColor:
          ColorUtil.lightenColor(Theme.of(context).primaryColor, 0.85),
      child: Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...drawerItems
                  .map(
                    (item) => DrawerListTile(
                        item['icon']! as IconData,
                        item['title']! as String,
                        item['route']! as String,
                        widget._pageArgs),
                  )
                  .toList(),
              // toggles between the ongoing and past internships from the
              // main page
              ToggleSwitch(
                animate: true,
                animationDuration: 400,
                minWidth: 80,
                initialLabelIndex: _initialToggleLabel,
                totalSwitches: 2,
                labels: const ['Ongoing', 'Past'],
                onToggle: (index) {
                  if (index == 0) {
                    widget._toggleFunction(true);
                    setState(() {
                      _initialToggleLabel = 0;
                    });
                  } else {
                    widget._toggleFunction(false);
                    setState(() {
                      _initialToggleLabel = 1;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

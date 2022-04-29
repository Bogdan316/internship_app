import 'package:flutter/material.dart';

import '../base_widgets/theme_color.dart';
import '../pages/add_new_internship_page.dart';
import '../models/user.dart';

class DrawerListTile extends StatelessWidget {
  // Builds a custom ListTile with InkWell animations to be used in the
  // main drawer of the app

  final String _title;
  final String _route;
  final IconData _icon;

  const DrawerListTile(this._icon, this._title, this._route, {Key? key})
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
            Navigator.of(context).pushNamed(_route,
                arguments: ModalRoute.of(context)!.settings.arguments);
          },
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  // items that should be showed in the drawer when the user is a company
  final _companyDrawerItems = const [
    {
      'title': 'Add New Internship',
      'route': AddNewInternshipPage.namedRoute,
      'icon': Icons.add_box
    },
    {
      'title': 'Add New Internship',
      'route': AddNewInternshipPage.namedRoute,
      'icon': Icons.add_box
    },
    {
      'title': 'Add New Internship',
      'route': AddNewInternshipPage.namedRoute,
      'icon': Icons.add_box
    },
    {
      'title': 'Add New Internship',
      'route': AddNewInternshipPage.namedRoute,
      'icon': Icons.add_box
    },
    {
      'title': 'Add New Internship',
      'route': AddNewInternshipPage.namedRoute,
      'icon': Icons.add_box
    },
    {
      'title': 'Add New Internship',
      'route': AddNewInternshipPage.namedRoute,
      'icon': Icons.add_box
    },
  ];

  // items that should be showed in the drawer when the user is a student
  final _studentDrawerItems = const [
    {
      'title': 'Test',
      'route': AddNewInternshipPage.namedRoute,
      'icon': Icons.add
    },
    {
      'title': 'Test',
      'route': AddNewInternshipPage.namedRoute,
      'icon': Icons.add
    },
    {
      'title': 'Test',
      'route': AddNewInternshipPage.namedRoute,
      'icon': Icons.add
    },
    {
      'title': 'Test',
      'route': AddNewInternshipPage.namedRoute,
      'icon': Icons.add
    },
    {
      'title': 'Test',
      'route': AddNewInternshipPage.namedRoute,
      'icon': Icons.add
    },
    {
      'title': 'Test',
      'route': AddNewInternshipPage.namedRoute,
      'icon': Icons.add
    },
  ];

  @override
  Widget build(BuildContext context) {
    // get the current user
    final crtUser = ModalRoute.of(context)!.settings.arguments as User;
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
            children: drawerItems
                .map(
                  (item) => DrawerListTile(
                    item['icon']! as IconData,
                    item['title']! as String,
                    item['route']! as String,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:internship_app_fis/models/user_profile.dart';
import 'package:internship_app_fis/services/user_profile_service.dart';

import '../models/user.dart';
import '../base_widgets/main_drawer.dart';

class InternshipsMainPage extends StatefulWidget {
  static const String namedRoute = '/internships-main-page';

  final UserProfileService _userProfileService;
  final Map<String, dynamic> _pageArgs;

  const InternshipsMainPage(this._pageArgs, this._userProfileService,
      {Key? key})
      : super(key: key);

  @override
  State<InternshipsMainPage> createState() => _InternshipsMainPageState();
}

class _InternshipsMainPageState extends State<InternshipsMainPage> {
  late User crtUser;
  late Future<UserProfile?> crtProfile;

  @override
  void initState() {
    super.initState();
    crtUser = widget._pageArgs['user'] as User;
    if (widget._pageArgs.containsKey('profile')) {
      print('asd');
      crtProfile = Future.value(widget._pageArgs['profile'] as UserProfile);
    } else {
      crtProfile = widget._userProfileService.getUserProfileById(crtUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: themeData.primaryColor,
        title: const Text('Internship App'),
      ),
      drawer: MainDrawer(widget._pageArgs),
      body: FutureBuilder<UserProfile?>(
        future: crtProfile,
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            widget._pageArgs['profile'] = snapshot.data!;
            return Text(
              widget._pageArgs.toString(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

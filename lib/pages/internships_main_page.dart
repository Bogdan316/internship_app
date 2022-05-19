import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:internship_app_fis/models/user_profile.dart';
import 'package:internship_app_fis/services/user_profile_service.dart';
import 'package:provider/provider.dart';

import '../base_widgets/main_drawer.dart';
import '../models/internship.dart';
import '../services/internship_service.dart';
import '../base_widgets/theme_color.dart';
import '../models/user.dart';
import 'internship_page.dart';

class InternshipsMainPage extends StatefulWidget {
  static const String namedRoute = '/internships-main-page';

  final InternshipService _internshipService;
  final UserProfileService _profileService;
  final Map<String, dynamic> _pageArgs;

  const InternshipsMainPage(
      this._pageArgs, this._internshipService, this._profileService,
      {Key? key})
      : super(key: key);

  @override
  State<InternshipsMainPage> createState() => _InternshipsMainPageState();
}

class _InternshipsMainPageState extends State<InternshipsMainPage> {
  late Future<List<CompanyProfile>> _companyProfiles;
  late Future<List<Internship>> _ongoingInternships;
  late User _crtUser;

  FutureOr _updateOngoingInternshipsList() {
    setState(() {
      _ongoingInternships = _crtUser.runtimeType == Student
          ? widget._internshipService
              .getStudentNotAppliedInternship(_crtUser as Student)
          : widget._internshipService.getAllInternships();
      _companyProfiles = widget._profileService.getAllCompanyProfiles();
    });
  }

  @override
  void initState() {
    super.initState();
    _crtUser = widget._pageArgs['user'] as User;
    _ongoingInternships = _crtUser.runtimeType == Student
        ? widget._internshipService
            .getStudentNotAppliedInternship(_crtUser as Student)
        : widget._internshipService.getAllInternships();
    _companyProfiles = widget._profileService.getAllCompanyProfiles();
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
      body: SizedBox(
        width: double.infinity,
        child: Center(
          // used for displaying a progress indicator until the internships are
          // queried
          child: FutureBuilder<List<List<dynamic>>>(
            future: Future.wait([_ongoingInternships, _companyProfiles]),
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                final internships = snapshot.data![0] as List<Internship>;
                final profiles = snapshot.data![1] as List<CompanyProfile>;
                if (internships.isNotEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async => setState(() {
                      _updateOngoingInternshipsList();
                    }),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: internships.length,
                      itemBuilder: (ctx, idx) => Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 24,
                        ),
                        child: ListTile(
                          onTap: () async {
                            final internshipPageArgs =
                                Map<String, dynamic>.from(widget._pageArgs);
                            internshipPageArgs['internship'] = internships[idx];
                            internshipPageArgs['profile'] = profiles.firstWhere(
                                (profile) =>
                                    profile.getUserId ==
                                    internships[idx].getCompanyId);
                            var hasApplied =
                                await Navigator.of(context).pushNamed(
                              InternshipPage.namedRoute,
                              arguments: internshipPageArgs,
                            ) as bool?;
                            if (hasApplied != null) {
                              setState(() {
                                internships.removeAt(idx);
                              });
                            }
                          },
                          // the unique id from the database is used as a key
                          // to ensure that the tiles are rebuilt after one
                          // of them is deleted
                          key: Key(internships[idx].getId!.toString()),
                          iconColor: themeData.primaryColorDark,
                          tileColor: ColorUtil.lightenColor(
                              themeData.primaryColor, 0.9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          visualDensity:
                              const VisualDensity(horizontal: -1, vertical: -1),
                          leading: ClipOval(
                            child: CachedNetworkImage(
                              height: 50,
                              width: 50,
                              imageUrl: profiles
                                  .firstWhere((profile) =>
                                      profile.getUserId ==
                                      internships[idx].getCompanyId)
                                  .getImageLink!,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            internships[idx].getTitle!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          subtitle: Text(
                            internships[idx].getDescription!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          trailing: Icon(
                            internships[idx].getIsOngoing!
                                ? Icons.check
                                : Icons.wrong_location,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  // show a placeholder if there are no ongoing internships
                  return LayoutBuilder(
                    builder: (ctx, constraints) => Container(
                      margin: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'No ongoing internships to show',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                            height: constraints.maxHeight * 0.5,
                            child: Image.asset(
                              'assets/images/waiting.png',
                              fit: BoxFit.cover,
                              color: themeData.primaryColorLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

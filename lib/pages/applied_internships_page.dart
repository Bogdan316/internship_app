import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:internship_app_fis/models/user_profile.dart';
import 'package:internship_app_fis/services/user_profile_service.dart';
import 'package:mysql1/mysql1.dart';

import '../models/internship.dart';
import '../services/internship_service.dart';
import '../base_widgets/custom_snack_bar.dart';
import '../base_widgets/theme_color.dart';
import '../models/user.dart';
import 'internship_page.dart';

class AppliedInternshipsPage extends StatefulWidget {
  static const String namedRoute = '/applied-internships-page';

  final InternshipService _internshipService;
  final UserProfileService _profileService;
  final Map<String, dynamic> _pageArgs;

  const AppliedInternshipsPage(
      this._pageArgs, this._internshipService, this._profileService,
      {Key? key})
      : super(key: key);

  @override
  State<AppliedInternshipsPage> createState() => _AppliedInternshipsPageState();
}

class _AppliedInternshipsPageState extends State<AppliedInternshipsPage> {
  late Future<List<Internship>> _appliedInternships;
  late Future<List<CompanyProfile>> _companyProfiles;

  late Student _crtStudent;
  late StudentProfile _crtStudentProfile;

  FutureOr _updateAppliedInternshipsList() {
    setState(() {
      _appliedInternships =
          widget._internshipService.getStudentAppliedInternship(_crtStudent);
      _companyProfiles = widget._profileService.getAllCompanyProfiles();
    });
  }

  @override
  void initState() {
    // when the screen is loaded for the first time, fetch all the internships
    // for the current company as a future
    super.initState();
    _crtStudent = widget._pageArgs['user'] as Student;
    _crtStudentProfile = widget._pageArgs['profile'] as StudentProfile;
    _appliedInternships =
        widget._internshipService.getStudentAppliedInternship(_crtStudent);
    _companyProfiles = widget._profileService.getAllCompanyProfiles();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final appBar = AppBar(
      title: const Text('My Applications'),
    );
    return Scaffold(
      appBar: appBar,
      body: SizedBox(
        width: double.infinity,
        child: Center(
          // used for displaying a progress indicator until the internships are
          // queried
          child: FutureBuilder<List<dynamic>>(
            future: Future.wait([_appliedInternships, _companyProfiles]),
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                var internships = snapshot.data![0] as List<Internship>;
                final profiles = snapshot.data![1] as List<CompanyProfile>;
                if (snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: internships.length,
                    itemBuilder: (ctx, idx) => Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 20,
                      ),
                      child: ListTile(
                        // the unique id from the database is used as a key
                        // to ensure that the tiles are rebuilt after one
                        // of them is deleted
                        key: Key(internships[idx].getId!.toString()),
                        onTap: () async {
                          final internshipPageArgs =
                              Map<String, dynamic>.from(widget._pageArgs);
                          internshipPageArgs['internship'] = internships[idx];
                          internshipPageArgs['profile'] = profiles.firstWhere(
                            (profile) =>
                                profile.getUserId ==
                                internships[idx].getCompanyId,
                          );
                          internshipPageArgs['notAppliedInternships'] =
                              <Internship>[];
                          // update the data when coming back from the page
                          await Navigator.of(context).pushNamed(
                            InternshipPage.namedRoute,
                            arguments: internshipPageArgs,
                          );
                        },
                        iconColor: themeData.primaryColorDark,
                        tileColor:
                            ColorUtil.lightenColor(themeData.primaryColor, 0.9),
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
                          maxLines: 1,
                        ),
                        // edit and delete buttons
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (internships[idx].getIsOngoing!)
                              IconButton(
                                onPressed: () async {
                                  try {
                                    await widget._internshipService
                                        .deleteStudentAppliedInternship(
                                            _crtStudent, internships[idx]);
                                    setState(() {
                                      snapshot.data![0].removeAt(idx);
                                    });
                                  } on MySqlException {
                                    final snackBar = MessageSnackBar(
                                      'We could not delete your application from this internship, try again later.',
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                icon: const Icon(Icons.delete_outline),
                                color: themeData.errorColor,
                                splashRadius: 25,
                              ),
                          ],
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

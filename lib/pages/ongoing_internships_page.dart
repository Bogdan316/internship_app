import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:internship_app_fis/models/user_profile.dart';
import 'package:internship_app_fis/pages/internship_participants_page.dart';
import 'package:mysql1/mysql1.dart';

import '../models/internship.dart';
import '../services/internship_service.dart';
import '../base_widgets/custom_snack_bar.dart';
import '../base_widgets/theme_color.dart';
import '../models/user.dart';
import '../pages/add_new_internship_page.dart';

class OngoingInternshipsPage extends StatefulWidget {
  // Page holding the internships of the current company
  static const String namedRoute = '/ongoing-internships-page';

  final InternshipService _internshipService;
  final Map<String, dynamic> _pageArgs;
  final DefaultCacheManager _cacheManager;

  const OngoingInternshipsPage(
      this._pageArgs, this._internshipService, this._cacheManager,
      {Key? key})
      : super(key: key);

  @override
  State<OngoingInternshipsPage> createState() => _OngoingInternshipsPageState();
}

class _OngoingInternshipsPageState extends State<OngoingInternshipsPage> {
  late Future<List<Internship>> _ongoingInternships;
  late Company _crtCompany;
  late CompanyProfile _crtCompanyProfile;

  FutureOr _updateOngoingInternshipsList(dynamic value) {
    // Updates the list of internships
    setState(() {
      _ongoingInternships =
          widget._internshipService.getAllCompanyInternships(_crtCompany);
    });
  }

  @override
  void initState() {
    // when the screen is loaded for the first time, fetch all the internships
    // for the current company as a future
    super.initState();
    _crtCompany = widget._pageArgs['user'] as Company;
    _crtCompanyProfile = widget._pageArgs['profile'] as CompanyProfile;
    _ongoingInternships =
        widget._internshipService.getAllCompanyInternships(_crtCompany);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final appBar = AppBar(
      title: const Text('Ongoing Internships'),
    );
    return Scaffold(
      appBar: appBar,
      body: SizedBox(
        width: double.infinity,
        child: Center(
          // used for displaying a progress indicator until the internships are
          // queried
          child: FutureBuilder<List<Internship>>(
            future: _ongoingInternships,
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.length,
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
                        key: Key(snapshot.data![idx].getId!.toString()),
                        onTap: () {
                          final participantsArgs =
                              Map<String, dynamic>.from(widget._pageArgs);
                          participantsArgs['internship'] = snapshot.data![idx];
                          Navigator.of(context).pushNamed(
                            InternshipParticipantsPage.namedRoute,
                            arguments: participantsArgs,
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
                            cacheManager: widget._cacheManager,
                            height: 50,
                            width: 50,
                            imageUrl: _crtCompanyProfile.getImageLink!,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          snapshot.data![idx].getTitle!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          snapshot.data![idx].getDescription!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        // edit and delete buttons
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // edit button
                            IconButton(
                              onPressed: () {
                                // add the current internship to the page
                                // arguments that will be sent to the edit page
                                var editPageArgs =
                                    Map<String, dynamic>.from(widget._pageArgs);
                                editPageArgs['internship'] =
                                    snapshot.data![idx];
                                // when the user comes back from the edit
                                // page all the internships are updated again
                                Navigator.of(context)
                                    .pushNamed(
                                      AddNewInternshipPage.namedRoute,
                                      arguments: editPageArgs,
                                    )
                                    .then(_updateOngoingInternshipsList);
                              },
                              icon: const Icon(Icons.edit_outlined),
                              splashRadius: 25,
                            ),
                            // delete button
                            IconButton(
                              onPressed: () async {
                                try {
                                  await widget._internshipService
                                      .deleteInternship(snapshot.data![idx]);
                                  setState(() {
                                    snapshot.data!.removeAt(idx);
                                  });
                                } on MySqlException {
                                  final snackBar = MessageSnackBar(
                                    'We could not delete this internship, try again later.',
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

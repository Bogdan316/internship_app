import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:internship_app_fis/models/user_profile.dart';
import 'package:internship_app_fis/services/user_profile_service.dart';

import '../base_widgets/main_drawer.dart';
import '../base_widgets/tag_searchbar.dart';
import '../models/internship.dart';
import '../services/internship_service.dart';
import '../base_widgets/theme_color.dart';
import '../models/user.dart';
import 'internship_page.dart';

class InternshipsMainPage extends StatefulWidget {
  // Holds a list tile of all the internships from the database

  static const String namedRoute = '/internships-main-page';

  final InternshipService _internshipService;
  final UserProfileService _profileService;
  final Map<String, dynamic> _pageArgs;
  final DefaultCacheManager _defaultCacheManager;

  const InternshipsMainPage(this._pageArgs, this._internshipService,
      this._profileService, this._defaultCacheManager,
      {Key? key})
      : super(key: key);

  @override
  State<InternshipsMainPage> createState() => _InternshipsMainPageState();
}

class _InternshipsMainPageState extends State<InternshipsMainPage> {
  // list of companies profiles used for getting their profile images
  late Future<List<CompanyProfile>> _companyProfiles;
  // list of all internships
  late Future<List<Internship>> _allInternships;
  // list of all internships that the student has not applied for
  late Future<List<Internship>> _notAppliedInternships;
  late Future<UserProfile?> _crtProfile;
  late User _crtUser;
  // toggles between ongoing and past internships
  var _showOngoing = true;
  // used for filtering the internship list based on searched tag
  String? _searchFilter;

  FutureOr _updateOngoingInternshipsList() {
    // fetches all the data needed from the database
    setState(() {
      _notAppliedInternships = _crtUser.runtimeType == Student
          ? widget._internshipService
          .getStudentNotAppliedInternship(_crtUser as Student)
          : Future.value(<Internship>[]);
      _allInternships = widget._internshipService.getAllInternships();
      _companyProfiles = widget._profileService.getAllCompanyProfiles();
    });
  }

  @override
  void initState() {
    // first fetch of data before building the page
    super.initState();
    _crtUser = widget._pageArgs['user'] as User;
    _notAppliedInternships = _crtUser.runtimeType == Student
        ? widget._internshipService
        .getStudentNotAppliedInternship(_crtUser as Student)
        : Future.value(<Internship>[]);
    _allInternships = widget._internshipService.getAllInternships();
    _companyProfiles = widget._profileService.getAllCompanyProfiles();
    _crtProfile = widget._pageArgs.containsKey('profile')
        ? Future.value(widget._pageArgs['profile'] as UserProfile)
        : widget._profileService.getUserProfileById(_crtUser);
  }

  void _toggleOngoing(bool isOngoing) {
    setState(() {
      _showOngoing = isOngoing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: themeData.primaryColor,
        title: const Text('Internship App'),
        actions: [
          IconButton(
            splashRadius: 20,
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TagSearchDelegate(
                  (value) => setState(() {
                    _searchFilter = value;
                  }),
                ),
              );
            },
          )
        ],
      ),
      // trough the last two arguments the toggle button from the drawer
      // filters for the ongoing and past internships
      drawer: MainDrawer(widget._pageArgs, _toggleOngoing, _showOngoing),
      body: SizedBox(
        width: double.infinity,
        child: Center(
          // used for displaying a progress indicator until the internships are
          // queried
          child: FutureBuilder<List<dynamic>>(
            // wait until all the data has been fetched
            future: Future.wait([
              _allInternships,
              _companyProfiles,
              _notAppliedInternships,
              _crtProfile
            ]),
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                if (!widget._pageArgs.containsKey('profile')) {
                  widget._pageArgs['profile'] = snapshot.data![3];
                }
                // cast the snapshot data to the appropriate types
                var internships = snapshot.data![0]
                    .where(
                        (internship) => internship.getIsOngoing == _showOngoing)
                    .toList() as List<Internship>;
                final profiles = snapshot.data![1] as List<CompanyProfile>;
                final notAppliedInternships =
                snapshot.data![2] as List<Internship>;

                if (_searchFilter != null) {
                  internships = internships
                      .where((internship) =>
                  TagUtil.convertTagValueToString(internship.getTag!) ==
                      _searchFilter)
                      .toList();
                }

                if (_searchFilter != null) {
                  internships = internships
                      .where((internship) =>
                          TagUtil.convertTagValueToString(internship.getTag!) ==
                          _searchFilter)
                      .toList();
                }

                if (internships.isNotEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async => setState(() {
                      _updateOngoingInternshipsList();
                    }),
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
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
                            // arguments that will be sent to the internship
                            // page
                            final internshipPageArgs =
                            Map<String, dynamic>.from(widget._pageArgs);
                            internshipPageArgs['internship'] = internships[idx];
                            internshipPageArgs['profile'] = profiles.firstWhere(
                                  (profile) =>
                              profile.getUserId ==
                                  internships[idx].getCompanyId,
                            );
                            internshipPageArgs['notAppliedInternships'] =
                                notAppliedInternships;
                            // update the data when coming back from the page
                            await Navigator.of(context)
                                .pushNamed(
                              InternshipPage.namedRoute,
                              arguments: internshipPageArgs,
                            )
                                .whenComplete(
                                    () => _updateOngoingInternshipsList());
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
                              cacheManager: widget._defaultCacheManager,
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
                          trailing: notAppliedInternships
                              .contains(internships[idx]) &&
                              _crtUser.runtimeType == Student &&
                              internships[idx].getIsOngoing!
                              ? const Icon(Icons.check)
                              : null,
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
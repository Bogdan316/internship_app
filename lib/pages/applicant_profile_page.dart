import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internship_app_fis/base_widgets/custom_elevated_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../base_widgets/theme_color.dart';
import '../models/internship.dart';
import '../models/user.dart';
import '../services/internship_service.dart';
import '../services/user_profile_service.dart';
import './profile_widget.dart';
import '../models/user_profile.dart';
import '/base_widgets/button_widget.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flowder/flowder.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'internship_page.dart';

class ApplicantProfilePage extends StatefulWidget {
  static const String namedRoute = '/applicant-profile-page';
  final Map<String, dynamic> _pageArgs;

  final InternshipService _internshipService;
  final UserProfileService _profileService;

  const ApplicantProfilePage(
      this._pageArgs, this._internshipService, this._profileService,
      {Key? key})
      : super(key: key);

  @override
  _ApplicantProfilePageState createState() => _ApplicantProfilePageState();
}

const double coverHeight = 180;
const double profileHeight = 128;
const top = coverHeight - profileHeight / 2;
const bottom = profileHeight;

class _ApplicantProfilePageState extends State<ApplicantProfilePage> {
  UploadTask? task;
  File? file;
  late StudentProfile _studentProfile;
  late DownloaderUtils options;
  late DownloaderCore core;
  late final String path;
  late UserProfile? participantProfile;

  late Future<List<Internship>> _previousInternships;
  late Future<List<CompanyProfile>> _companyProfiles;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _studentProfile = widget._pageArgs['participantProfile'] as StudentProfile;
    _previousInternships = widget._internshipService
        .getStudentPastInternshipsById(_studentProfile.getUserId!);
    _companyProfiles = widget._profileService.getAllCompanyProfiles();
  }

  Future<void> initPlatformState() async {
    _setPath();
    if (!mounted) return;
  }

  void _setPath() async {
    Directory _path = await getApplicationDocumentsDirectory();

    String _localPath = _path.path + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    path = _localPath;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: themeData.primaryColor,
        title: Text(_studentProfile.getFullName!),
      ),
      body: ListView(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              buildCoverImage(
                themeData.primaryColorLight,
                themeData.primaryColorDark,
              ),
              Positioned(
                top: top,
                child: Container(
                  margin: const EdgeInsets.only(bottom: bottom),
                  child: ProfileWidget(
                    imagePath: _studentProfile.getImageLink,
                    onClicked: () {},
                    isEdit: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),
          buildNameAndEmail(_studentProfile),
          buildAbout(_studentProfile),
          ..._buildStudentLayout(_studentProfile),
          Center(
            child: FutureBuilder<List<dynamic>>(
              future: Future.wait(
                [
                  _previousInternships,
                  _companyProfiles,
                ],
              ),
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  final internships =
                      snapshot.data![0].toList() as List<Internship>;
                  final profiles = snapshot.data![1] as List<CompanyProfile>;

                  if (internships.isNotEmpty) {
                    return Column(
                      children: [
                        const Text(
                          'Previous internships',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          height: 400,
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
                                  // arguments that will be sent to the internship
                                  // page
                                  final internshipPageArgs =
                                      Map<String, dynamic>.from(
                                          widget._pageArgs);
                                  internshipPageArgs['internship'] =
                                      internships[idx];
                                  internshipPageArgs['profile'] =
                                      profiles.firstWhere(
                                    (profile) =>
                                        profile.getUserId ==
                                        internships[idx].getCompanyId,
                                  );
                                  internshipPageArgs['previousInternships'] =
                                      internships;
                                  internshipPageArgs['notAppliedInternships'] =
                                      <Internship>[];
                                  Navigator.of(context).pushNamed(
                                    InternshipPage.namedRoute,
                                    arguments: internshipPageArgs,
                                  );
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
                                visualDensity: const VisualDensity(
                                    horizontal: -1, vertical: -1),
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
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    return LayoutBuilder(
                      builder: (ctx, constraints) => Container(
                        margin: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              'No previous internships to show',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }

  Widget buildNameAndEmail(UserProfile user) => Column(
        children: [
          Text(
            user.getFullName!,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.getEmail!,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildRepoButton(UserProfile user) => ButtonWidget(
        text: 'Repository',
        icon: FontAwesomeIcons.github,
        onClicked: () async {
          await launchUrl(Uri.parse(user.getRepo!));
        },
      );

  Widget buildDownloadCvButton(UserProfile user) => ButtonWidget(
        icon: Icons.download,
        text: 'CV',
        onClicked: () async {
          options = DownloaderUtils(
            progressCallback: (current, total) {
              final progress = (current / total) * 100;
              print('Downloading: $progress');
            },
            file: File('$path/test'),
            progress: ProgressImplementation(),
            onDone: () {
              OpenFile.open('$path/test');
            },
          );
          core = await Flowder.download(
            user.getCvLink!,
            options,
          );
        },
      );

  Widget buildAbout(UserProfile user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              user.getAbout!,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );

  buildCoverImage(Color colorStart, Color colorEnd) => Container(
        width: double.infinity,
        height: coverHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              colorStart,
              colorEnd,
            ],
          ),
        ),
      );

  List<Widget> _buildStudentLayout(StudentProfile profile) {
    return [
      const SizedBox(height: 24),
      Center(child: buildRepoButton(profile)),
      const SizedBox(height: 24),
      Center(child: buildDownloadCvButton(profile)),
      const SizedBox(height: 24),
    ];
  }
}

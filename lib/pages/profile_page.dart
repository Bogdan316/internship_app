import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:internship_app_fis/pages/create_user_profile_page.dart';
import 'package:url_launcher/url_launcher.dart';
import './profile_widget.dart';
import '../models/user_profile.dart';
import '/base_widgets/button_widget.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flowder/flowder.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatefulWidget {
  static const String namedRoute = '/profile_page';
  final Map<String, dynamic> _pageArgs;

  const ProfilePage(this._pageArgs, {Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

const double coverHeight = 180;
const double profileHeight = 128;
const top = coverHeight - profileHeight / 2;
const bottom = profileHeight;

class _ProfilePageState extends State<ProfilePage> {
  UploadTask? task;
  File? file;
  late UserProfile crtUser;
  late DownloaderUtils options;
  late DownloaderCore core;
  late final String path;
  late UserProfile? participantProfile;

  @override
  void initState() {
    super.initState();
    crtUser = widget._pageArgs.containsKey('participantProfile')
        ? widget._pageArgs['participantProfile'] as UserProfile
        : widget._pageArgs['profile'] as UserProfile;
    initPlatformState();
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
        title: const Text('Internship App'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              buildCoverImage(),
              Positioned(
                top: top,
                child: Container(
                  margin: const EdgeInsets.only(bottom: bottom),
                  child: ProfileWidget(
                    imagePath: crtUser.getImageLink,
                    onClicked: () async {
                      /// TO DO: EditProfilePage
                      Navigator.of(context).pushReplacementNamed(
                        CreateUserProfilePage.namedRoute,
                        arguments: widget._pageArgs,
                      );
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),
          buildName(crtUser),
          if (crtUser.runtimeType == StudentProfile) ..._buildStudentLayout(),
        ],
      ),
    );
  }

  Widget buildName(UserProfile user) => Column(
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

  Widget buildUpgradeButton(UserProfile user) => ButtonWidget(
    text: 'Repository',
    onClicked: () async {
      await launchUrl(Uri.parse(crtUser.getRepo!));
    },
  );

  Widget buildDownloadButton(UserProfile user) => ButtonWidget(
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
        crtUser.getCvLink!,
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

  buildCoverImage() => Container(
    color: Colors.grey,
    child: Image.network(
      'https://image.winudf.com/v2/image1/Y29tLm1pay5ncmFkaWVudGJhY2tncm91bmRfc2NyZWVuXzBfMTYyNDI0NDQ0M18wMDM/screen-0.jpg?fakeurl=1&type=.jpg',
      width: double.infinity,
      height: coverHeight,
      fit: BoxFit.cover,
    ),
  );

  List<Widget> _buildStudentLayout() {
    return [
      const SizedBox(height: 24),
      Center(child: buildUpgradeButton(crtUser)),
      const SizedBox(height: 24),
      Center(child: buildDownloadButton(crtUser)),
      const SizedBox(height: 24),
    ];
  }
}

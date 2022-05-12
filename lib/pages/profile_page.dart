import 'package:flutter/material.dart';
//import './appbar_widget.dart';
import './profile_widget.dart';
import '../models/user_profile.dart';
import '/base_widgets/button_widget.dart';
import './edit_profile_page.dart';
//import './button_widget_upload.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '/base_widgets/button_widget_download.dart';

class ProfilePage extends StatefulWidget {
  static const String namedRoute = '/profile_page';//'/create-user-profile';

  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

const double coverHeight = 180;
const double profileHeight = 128;
const top = coverHeight - profileHeight/2;
const bottom = profileHeight  ;

class _ProfilePageState extends State<ProfilePage> {
  UploadTask? task;
  File? file;

  @override
  Widget build(BuildContext context) {
    final crtUser = ModalRoute.of(context)!.settings.arguments as UserProfile;
    //final user = UserPreferences.getUser();
    return Scaffold(
      //appBar: buildAppBar(context),
      body:
      ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          //Needs Stack(
          Stack(
            clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            buildCoverImage(),
          Positioned(
            top: top,
            child:
            Container(
              margin: const EdgeInsets.only(bottom: bottom),
            child:
            ProfileWidget(
            imagePath: '',
            onClicked: () async {
              //await Navigator.of(context).push(
                //MaterialPageRoute(builder: (context) => EditProfilePage()),
              //);
              setState((){});
            },
          ),
          ),
          ),
          ],
          ),
          const SizedBox(height: 80),
          buildName(crtUser),
          const SizedBox(height: 24),
          Center(child: buildUpgradeButton()),
          const SizedBox(height: 24),
          Center(child: buildDownloadButton()),
          /*const SizedBox(height: 24),
      Center(child: ButtonWidgetUpload(
            text: 'Select CV',
            icon: Icons.attach_file,
            onClicked: selectFile,
            ),
          ),
          const SizedBox(height: 24),
          Center(child: ButtonWidgetUpload(
            text: 'Upload CV',
            icon: Icons.attach_file,
            onClicked: selectFile,
          ),
          ),*/
          const SizedBox(height: 24),
          //NumbersWidget(),
          //buildAbout(){},
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

  Widget buildUpgradeButton() => ButtonWidget(
        text: 'Repository',
        onClicked: () {},
      );

  Widget buildDownloadButton() => ButtonWidgetDownload(
    text: 'CV',
    onClicked: () {},
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
      //'https://res.cloudinary.com/demo/image/facebook/65646572251.jpg',
      'https://www.dior.com/couture/var/dior/storage/images/folder-media/folder-videos/folder-parfums/diorparfums_sauvage_dior_gon/25659534-8-int-EN/diorparfums_sauvage_dior_gon_1440_1200.jpg',
      width: double.infinity,
        height: coverHeight,
        fit: BoxFit.cover,
    ),
  );

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple:false);
    if(result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile() async {}
}

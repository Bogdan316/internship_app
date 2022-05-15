import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internship_app_fis/base_widgets/custom_elevated_button.dart';
import 'package:internship_app_fis/pages/firebase_api.dart';
import 'package:internship_app_fis/pages/profile_widget.dart';
import '../base_widgets/button_widget_upload.dart';
import '../base_widgets/textfield_widget.dart';
import '../models/user.dart';
import '../services/user_profile_service.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;

class CreateUserProfilePage extends StatefulWidget {
  static const String namedRoute = '/create-user-user-profile';
  final UserProfileService _userProfileService;

  const CreateUserProfilePage(this._userProfileService, {Key? key})
      : super(key: key);

  @override
  State<CreateUserProfilePage> createState() => _CreateUserProfilePageState();
}

class _CreateUserProfilePageState extends State<CreateUserProfilePage> {
  final _fullNameCtr = TextEditingController();
  final _emailCtr = TextEditingController();
  final _repoLinkCtr = TextEditingController();
  final _aboutCtr = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _cvFile;
  String? _cvUrl;
  String? imagePath;
  String? _imageUrl;

  Future _selectCvFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path;

    setState(() {
      _cvFile = File(path!);
    });
  }

  Future _uploadCvFile(User crtUser) async {
    if (_cvFile == null) return;

    final destination =
        '${crtUser.runtimeType}/cv/${crtUser.runtimeType}${crtUser.getUserId}';

    final task = FirebaseApi.uploadFile(destination, _cvFile!);

    if (task == null) return;
    final snapshot = await task.whenComplete(() => null);
    final urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      _cvUrl = urlDownload;
    });
  }

  Future _selectPhoto(BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        builder: (context) => BottomSheet(
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.camera);
                  }),
              ListTile(
                  leading: const Icon(Icons.filter),
                  title: const Text('Pick a file'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.gallery);
                  }),
            ],
          ),
          onClosing: () {},
        ));
  }

  Future _pickImage(ImageSource source) async {
    final pickedFile =
    await _picker.pickImage(source: source, imageQuality: 50);

    if (pickedFile == null) {
      return;
    }

    setState(() {
      imagePath = pickedFile.path;
    });
  }

  Future _uploadImageFile(User crtUser, String path) async {
    final ref = storage.FirebaseStorage.instance
        .ref()
        .child(crtUser.runtimeType.toString())
        .child('profile-images')
        .child('${crtUser.runtimeType}${crtUser.getUserId}');

    final result = await ref.putFile(File(path));
    final fileUrl = await result.ref.getDownloadURL();

    setState(() {
      _imageUrl = fileUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    final crtUser = ModalRoute.of(context)!.settings.arguments as User;
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: themeData.primaryColor,
        title: const Text('Create Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        physics: const BouncingScrollPhysics(),
        children: [
          // UserImage(
          //   onFileChanged: (imageUrl) {},
          // ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ProfileWidget(
              onClicked: () async => _selectPhoto(context),
              imagePath: imagePath,
            ),
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            controller: _fullNameCtr,
            label: 'Full Name',
            text: '',
            onChanged: (_) {},
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            controller: _emailCtr,
            label: 'Email',
            text: '',
            onChanged: (_) {},
          ),
          const SizedBox(height: 24),
          if (crtUser.runtimeType == Student)
            Center(
              child: ButtonWidgetUpload(
                primary: themeData.primaryColorDark,
                text: 'Select CV',
                icon: Icons.attach_file,
                onClicked: _selectCvFile,
              ),
            ),
          if (_cvFile != null) ...[
            const SizedBox(height: 24),
            Text(
              basename(_cvFile!.path),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),
          TextFieldWidget(
            controller: _repoLinkCtr,
            label: 'Repository Link',
            text: '',
            onChanged: (_) {},
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            controller: _aboutCtr,
            label: 'About',
            text: '',
            maxLines: 5,
            onChanged: (_) {},
          ),
          const SizedBox(height: 24),
          CustomElevatedButton(
            label: 'Save',
            onPressed: () async {
              await _uploadCvFile(crtUser);
              if (imagePath != null) {
                await _uploadImageFile(crtUser, imagePath!);
              }
              print(_cvUrl);
              print(_imageUrl);
            },
            primary: themeData.primaryColorDark,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

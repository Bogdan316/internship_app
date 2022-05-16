import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internship_app_fis/base_widgets/custom_elevated_button.dart';
import 'package:internship_app_fis/pages/firebase_api.dart';
import 'package:internship_app_fis/pages/profile_widget.dart';
import '../base_widgets/button_widget_upload.dart';
import '../base_widgets/custom_snack_bar.dart';
import '../base_widgets/textfield_widget.dart';
import '../models/user.dart';
import '../models/user_profile.dart';
import '../services/user_profile_service.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;

class EditUserProfilePage extends StatefulWidget {
  static const String namedRoute = '/create-user-user-profile';
  final UserProfileService _userProfileService;

  const EditUserProfilePage(this._userProfileService, {Key? key})
      : super(key: key);

  @override
  State<EditUserProfilePage> createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
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
    final pageArgs =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final crtUser = pageArgs['user'] as User;
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: themeData.primaryColor,
        title: const Text('Create Profile'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 24),
            ProfileWidget(
              onClicked: () async => _selectPhoto(context),
              imagePath: imagePath,
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
            if (crtUser.runtimeType == Student) ...[
              const SizedBox(height: 24),
              TextFieldWidget(
                controller: _repoLinkCtr,
                label: 'Repository Link',
                text: '',
                onChanged: (_) {},
              ),
            ],
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
                if (_fullNameCtr.text.isEmpty ||
                    _aboutCtr.text.isEmpty ||
                    _emailCtr.text.isEmpty ||
                    ((_cvFile == null || _repoLinkCtr.text.isEmpty) &&
                        crtUser.runtimeType != Company) ||
                    imagePath == null) {
                  final snackBar = MessageSnackBar('All fields are mandatory!');
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  await _uploadCvFile(crtUser);
                  if (imagePath != null) {
                    await _uploadImageFile(crtUser, imagePath!);
                  }
                }
                var userProfile = crtUser.runtimeType == Student
                    ? StudentProfile(
                  id: null,
                  userId: crtUser.getUserId,
                  imageLink: _imageUrl,
                  fullname: _fullNameCtr.text,
                  email: _emailCtr.text,
                  cvLink: _cvUrl,
                  repo: _repoLinkCtr.text,
                  about: _aboutCtr.text,
                )
                    : CompanyProfile(
                  id: null,
                  userId: crtUser.getUserId,
                  imageLink: _imageUrl,
                  fullname: _fullNameCtr.text,
                  email: _emailCtr.text,
                  about: _aboutCtr.text,
                );
                await widget._userProfileService.addUserProfile(userProfile);
              },
              primary: themeData.primaryColorDark,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}


/*
import 'package:internship_app_fis/pages/profile_page.dart';

 import '../base_widgets/user_image.dart';
 import '../models/user.dart';
 import 'package:flutter/material.dart';
 import '../models/user_profile.dart';
 import './profile_widget.dart';
 import './textfield_widget.dart';
 import '/base_widgets/button_widget_edit.dart';
 import 'package:image_picker/image_picker.dart';
 import 'package:path/path.dart';
 import 'package:path_provider/path_provider.dart';
 import 'dart:io';
 import '/base_widgets/button_widget_upload.dart';
 import 'package:file_picker/file_picker.dart';
 import 'package:firebase_storage/firebase_storage.dart';
 import './firebase_api.dart';
 import '/services/user_profile_service.dart';
 import '/models/user_profile.dart';
 import 'package:internship_app_fis/models/user_profile.dart';
 import 'dart:developer';

 class EditProfilePage extends StatefulWidget {
   static const String namedRoute =
       '/edit_profile_page.dart'; //'/create-user-profile';
   final User? currentUser;

   final UserProfileService _userProfileService;

   const EditProfilePage(this.currentUser, this._userProfileService, {Key? key})
       : super(key: key);

   @override
   _EditProfilePageState createState() => _EditProfilePageState();
 }

 class _EditProfilePageState extends State<EditProfilePage> {
   late TextEditingController _fullnameCtr;
   late TextEditingController _emailCtr;
   late TextEditingController _repoCtr;
   late TextEditingController _aboutCtr;

   @override
   void initState() {
     super.initState();
     _fullnameCtr = TextEditingController();
     _emailCtr = TextEditingController();
     _repoCtr = TextEditingController();
     _aboutCtr = TextEditingController();
   }

  @override
   Widget build(BuildContext context) => Scaffold(
         body: GestureDetector(
           // Ensure that when the user taps the screen the TextFields will unfocus
           onTap: () {
             FocusScope.of(context).unfocus();
           },
           child: ListView(
             padding: const EdgeInsets.symmetric(horizontal: 32),
             physics: const BouncingScrollPhysics(),
             children: [
               UserImage(
                 onFileChanged: (imageUrl) {
                   setState(() {
                     this. = imageUrl;
                    print(imageUrl);
                   });
                 },
               ),
               GestureDetector(
                 onTap: () {
                   FocusScope.of(context).unfocus();
                 },
                 child: ProfileWidget(
                   imagePath: '',
                   isEdit: true,
                   onClicked: () async {
                     final image = await ImagePicker().pickImage(
                         source: ImageSource.gallery); //pick in loc de get
                     if (image == null) return;

                     final directory = await getApplicationDocumentsDirectory();
                     final name = basename(image.path);
                     final imageFile = File('${directory.path}/$name');
                     final newImage =
                         await File(image.path).copy(imageFile.path);
                   },
                 ),
               ),
               const SizedBox(height: 24),
               TextFieldWidget(
                 controller: _fullnameCtr,
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
               Center(
                 child: ButtonWidgetUpload(
                   text: 'Select CV',
                   icon: Icons.attach_file,
                   onClicked: selectFile,
                 ),
               ),
               const SizedBox(height: 24),
               Center(
                 child: ButtonWidgetUpload(
                   text: 'Upload CV',
                   icon: Icons.cloud_upload_outlined,
                   onClicked: uploadFile,
                 ),
               ),
               const SizedBox(height: 24),
              task != null ? buildUploadStatus(task!) : Container(),
               const SizedBox(height: 24),
               TextFieldWidget(
                 controller: _repoCtr,
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
               ButtonWidget(
                 text: 'Save',
                 onClicked: () async {
                   var userProfile = widget.currentUser.runtimeType == Student
                       ? StudentProfile(
                           id: null,
                           userId: widget.currentUser!.getUserId,
                           fullname: _fullnameCtr.text,
                           email: _emailCtr.text,
                           repo: _repoCtr.text,
                           about: _aboutCtr.text,
                         )
                       : CompanyProfile(
                           id: null,
                           userId: widget.currentUser!.getUserId,
                           fullname: _fullnameCtr.text,
                           email: _emailCtr.text,
                           about: _aboutCtr.text,
                         );
                   await widget._userProfileService.addUserProfile(userProfile);
                   Navigator.of(context).pushReplacementNamed(
                     ProfilePage.namedRoute,
                     arguments: userProfile,
                   );
                 },
               ),
             ],
           ),
         ),
       );

   Future selectFile() async {
     final result = await FilePicker.platform.pickFiles(allowMultiple: false);
     if (result == null) return;
     final path = result.files.single.path!;

     setState(() => file = File(path));
   }

   Future uploadFile() async {
     if (file == null) return;

     final fileName = basename(file!.path);
     final destination = 'files/$fileName';

     task = FirebaseApi.uploadFile(destination, file!);
     setState(() {});

     if (task == null) return;

     final snapshot = await task!.whenComplete(() {});
     final urlDownload = await snapshot.ref.getDownloadURL();

     print('Donwload-Link: $urlDownload');
   }

   Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
         stream: task.snapshotEvents,
         builder: (context, snapshot) {
           if (snapshot.hasData) {
             final snap = snapshot.data!;
             final progress = snap.bytesTransferred / snap.totalBytes;
             final percentage = (progress * 100).toStringAsFixed(2);
             return Text(
               '$percentage %',
               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
               textAlign: TextAlign.center,
             );
           } else {
             return Container();
           }
         },
       );
}
*/
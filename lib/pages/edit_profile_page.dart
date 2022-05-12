import 'package:internship_app_fis/pages/profile_page.dart';

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

class EditProfilePage extends StatefulWidget {
  static const String namedRoute = '/edit_profile_page.dart';//'/create-user-profile';
  User? currentUser;

  final UserProfileService _userProfileService;

  EditProfilePage(this.currentUser, this._userProfileService, {Key? key})
      : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  //User user = UserPreferences.getUser();
  late UserProfileService _userProfile; //final
  UploadTask? task;
  File? file;

  //final String _userRole;
  late UserProfileService _userService;// = UserProfileService.getUserProfileById;
  late TextEditingController _fullnameCtr;
  late TextEditingController _emailCtr;
  late TextEditingController _repoCtr;
  late TextEditingController _aboutCtr;

  @override
  void initState(){
    super.initState();
    _fullnameCtr = TextEditingController();
    _emailCtr = TextEditingController();
    _repoCtr = TextEditingController();
    _aboutCtr = TextEditingController();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: ListView(
      padding:EdgeInsets.symmetric(horizontal: 32),
      physics: BouncingScrollPhysics(),
      children: [
        ProfileWidget(
          imagePath: '',
          isEdit: true,
          onClicked: () async {
            final image = await ImagePicker()
                .getImage(source: ImageSource.gallery);
            if (image == null) return;

            final directory = await getApplicationDocumentsDirectory();
            final name = basename(image.path);
            final imageFile = File('${directory.path}/$name');
            final newImage = await File(image.path).copy(imageFile.path);
            //setState(()=>user = user.copy(imagePath: newImage.path));
          },
        ),
        const SizedBox(height: 24),
        TextFieldWidget(
          controller: _fullnameCtr,
          label: 'Full Name',
          text: '',
          onChanged: (_){},
        ),
        const SizedBox(height: 24),
        TextFieldWidget(
          controller: _emailCtr,
          label: 'Email',
          text: '',
          onChanged: (_){},
        ),
    const SizedBox(height: 24),
    Center(child: ButtonWidgetUpload(
      text: 'Select CV',
      icon: Icons.attach_file,
      onClicked: selectFile,
    ),
    ),
    const SizedBox(height: 24),
    //Text(
      //fileName,
      //style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    //),
    Center(child: ButtonWidgetUpload(
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
          onChanged: (_){},
        ),
        const SizedBox(height: 24),
        TextFieldWidget(
          controller: _aboutCtr,
          label: 'About',
          text: '',
          maxLines:5,
          onChanged: (_){},
        ),
        const SizedBox(height: 24),
        ButtonWidget(
          text: 'Save',
          onClicked: () async {
            var userProfile = widget.currentUser.runtimeType == Student ?
            StudentProfile(id: null, userId: widget.currentUser!.getUserId, fullname: _fullnameCtr.text, email: _emailCtr.text,
                repo: _repoCtr.text, about:_aboutCtr.text,)
                : CompanyProfile(id: null, userId: widget.currentUser!.getUserId, fullname: _fullnameCtr.text, email: _emailCtr.text,
                about:_aboutCtr.text,);
            await widget._userProfileService.addUserProfile(userProfile);
            Navigator.of(context).pushReplacementNamed(
                ProfilePage.namedRoute,
                arguments: userProfile,);
          },
        ),
      ],
    ),
  );

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple:false);
    if(result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  //final fileName = file !=null ? basename(file!.path) : 'No File';

  Future uploadFile() async {
    if(file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState((){});

    if(task == null) return;

    final snapshot = await task!.whenComplete((){});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Donwload-Link: $urlDownload');
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context, snapshot){
        if(snapshot.hasData){
          final snap = snapshot.data!;
          final progress = snap.bytesTransferred/snap.totalBytes;
          final percentage = (progress * 100).toStringAsFixed(2);
          return Text(
            '$percentage %',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          );
        }
        else{
          return Container();
        }
      },
  );
}
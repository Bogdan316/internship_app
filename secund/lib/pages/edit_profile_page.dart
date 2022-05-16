import 'package:internship_app_fis/pages/profile_page.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

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
  //
  String imageUrl = '';
  String cvUrl = '';

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
    body:
    ///
    GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child:
      ListView(
      padding:EdgeInsets.symmetric(horizontal: 32),
      physics: BouncingScrollPhysics(),
      children: [
        /*Expanded(
            child: Stack(children: <Widget>[
              Container(
                height: double.infinity,
                margin: const EdgeInsets.only(
                  left: 30.0, right: 30.0, top:30.0
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: _imageFile != null
                    ? Image.file(_imageFile)
                      : TextButton(
                          child: Icon(
                            Icons.add_a_photo,
                                size: 50,
                          ),
                    onPressed: pickImage,
                  ),
                  ),
            ),
              ],
            ),
        ),
        uploadImageButton(context),
        UploadImageToFireBaseStorage(),*/
        //ImageCapture(),
        UserImage(
          onFileChanged: (imageUrl){
            setState((){
                this.imageUrl = imageUrl;
                print(imageUrl);
            });
          },
        ),
        ProfileWidget(
          imagePath: '',
          isEdit: true,
          onClicked: () async {
            final image = await ImagePicker()
                .pickImage(source: ImageSource.gallery); //pick in loc de get
            if (image == null) return;

            final directory = await getApplicationDocumentsDirectory();
            final name = basename(image.path);
            final imageFile = File('${directory.path}/$name');
            final newImage = await File(image.path).copy(imageFile.path);
            //setState(()=>user = user.copy(imagePath: newImage.path));
          },
        ),
        ///
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
            StudentProfile(id: null, userId: widget.currentUser!.getUserId, imageLink: imageUrl, fullname: _fullnameCtr.text, email: _emailCtr.text, cvLink: cvUrl,
                repo: _repoCtr.text, about:_aboutCtr.text,)
                : CompanyProfile(id: null, userId: widget.currentUser!.getUserId, imageLink: imageUrl, fullname: _fullnameCtr.text, email: _emailCtr.text, /*cvLink: null,*/
                about:_aboutCtr.text,);
            await widget._userProfileService.addUserProfile(userProfile);
            Navigator.of(context).pushReplacementNamed(
                ProfilePage.namedRoute,
                arguments: userProfile,);
          },
        ),
      ],
    ),
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
    cvUrl = urlDownload;
    print(cvUrl);
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

/*
class UploadingImageToFirebaseStorage extends StatefulWidget {
  @override
  _UploadingImageToFirebaseStorageState createState() =>
      _UploadingImageToFirebaseStorageState();
}

class _UploadingImageToFirebaseStorageState
    extends State<UploadingImageToFirebaseStorage> {
  File _imageFile;

  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

}
*/
/*
Future uploadImageToFirebase(BuildContext context) async {
  String fileName = basename(_imageFile.path);
  StorageReference firebaseStorageRef =
  FirebaseStorage.instance.ref().child('uploads/$fileName');
  StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
  StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
  taskSnapshot.ref.getDownloadURL().then(
        (value) => print("Done: $value"),
  );
}
*/

/*
class ImageCapture {
  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture>{
  File _imageFile;

  Future<void> _pickImage(ImageSource source) async{
    File selected = await ImagePicker.pickImage(source: source);

    setState((){
      _imageFile = selected;
    });
  }

  void _clear(){
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ],
        )
      ),
      body: ListView(
        children: <Widget>[
            if(_imageFile != null) ...[
              Image.file(_imageFile),

              Row(
                children: <Widget>[
                  TextButton(
                    child: Icon(Icons.crop),
                    onPressed: _cropImage,
                  ),
                  TextButton(
                    child: Icon(Icons.refresh),
                    onPressed: _clear,
                  ),
                ]
              )

              Uploader(file: _imageFile)
            ]
        ],
      ),
    );
  }

  Future<void> _cropImage() async{
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      toolbarColor: Colors.blueAccent,
      toolbarWidgetColor: Colors.white,
      toolbarTitle: 'Crop it'
    );

    setState((){
      _imageFile = cropped ?? _imageFile;
    });
  }

}

class Uploader extends StatefulWidget{
  final File file;

  Uploader({Key key, this.file}):super(key:key);

  createState() => UploaderState();
}

class _UploaderState extends State<Uploader>{
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://internshipapp-cf34c.appspot.com');

  StorageUploadTask _uploadTask;

  void _startUpload(){
    String filePath = 'images/${DateTime.now()}.png';

    setState((){
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context){
    if(_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
        stream: _uploadTask.events,
        builder: (context, snapshot){
          var event = snapshot?.data?.snapshot;

          double progressPercent = event != null
            ? event.bytesTransferred / event.totalByteCount
              : 0;

          return Column(

            children: [
              if(_uploadTask.isComplete)
                Text('Complete'),
              if(_uploadTask.isPaused)
                TextButton(
                  child: Icon(Icons.play_arrow),
                  onPressed: _uploadTask.resume,
                ),
              if(_uploadTask.isInProgress)
                TextButton(
                  child: Icon(Icons.play_arrow),
                  onPressed: _uploadTask.pause,
                ),
              LinearProgressIndicator(value: progressPercent),
              Text('${(progressPercent * 100).toStringAsFixed(2)}%'),
            ],
          );
        }
      );
    }else{
      return TextButton.icon(
        label: Text('Upload to Firebase'),
        icon: Icon(Icons.cloud_upload),
        onPressed: _startUpload,
      );
    }
  }
}*/
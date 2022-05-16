import 'package:flutter/material.dart';
import '../services/internship_service.dart';
import './profile_widget.dart';


class InternshipPage extends StatefulWidget {
  static const String namedRoute = '/internship-page';
  final InternshipService _internshipService;

  const InternshipPage(this._internshipService,
      {Key? key})
      : super(key: key);

  @override
  State<InternshipPage> createState() => _InternshipPageState();
}

const double coverHeight = 180;
const double profileHeight = 128;
const top = coverHeight - profileHeight/2;
const bottom = profileHeight  ;

class _InternshipPageState extends State<InternshipPage> {

  @override
  Widget build(BuildContext context) {
    //final crtInternship = ModalRoute.of(context)!.settings.arguments as InternshipProfile;

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
              // buildCoverImage(),
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
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),
          //buildName(crtUser),
          const SizedBox(height: 24),
          //Center(child: buildUpgradeButton()),
          const SizedBox(height: 24),

          const SizedBox(height: 24),

        ],
      ),
    );
  }
}

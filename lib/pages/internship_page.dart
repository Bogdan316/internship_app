import 'package:flutter/material.dart';
import '../base_widgets/custom_elevated_button.dart';
import '../models/internship.dart';
import '../models/internship_application.dart';
import '../models/user.dart';
import '../services/internship_application_service.dart';


class InternshipPage extends StatefulWidget {
  static const String namedRoute = '/internship-page';
  final InternshipApplicationService _internshipApplicationService;
  final Map<String, dynamic> _pageArgs;

  const InternshipPage(this._pageArgs, this._internshipApplicationService, {Key? key})
      : super(key: key);

  @override
  State<InternshipPage> createState() => _InternshipPageState();
}

const double coverHeight = 180;
const double profileHeight = 128;
const top = coverHeight - profileHeight / 2;
const bottom = profileHeight;

class _InternshipPageState extends State<InternshipPage> {
  @override
  Widget build(BuildContext context) {
    final crtInternship = widget._pageArgs['internship'] as Internship;
    final crtUser = widget._pageArgs['user'] as User;
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(crtInternship.toString()),

          const SizedBox(height: 80),
          buildName(crtInternship),

          CustomElevatedButton(
            label: 'Apply',
            onPressed: () async {
              final internshipApplication = InternshipApplication(
                  internshipId: crtInternship.getId,
                  studentId: crtUser.getUserId);
                  await widget._internshipApplicationService.addInternshipApplication(internshipApplication);
                  Navigator.of(context).pop(true);
                  },

            primary: themeData.primaryColorDark,
          )
        ],
      ),

    );
  }

  Widget buildName(Internship internship) =>
      Column(
        children: [
          Text(
            internship.getTitle!,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 24),
        ],
      );
}
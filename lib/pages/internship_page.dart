import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/user_profile.dart';
import '../base_widgets/custom_elevated_button.dart';
import '../models/internship.dart';
import '../models/internship_application.dart';
import '../models/user.dart';
import '../services/internship_application_service.dart';

class InternshipPage extends StatefulWidget {
  // Displays the details of an internship

  static const String namedRoute = '/internship-page';
  final InternshipApplicationService _internshipApplicationService;
  final Map<String, dynamic> _pageArgs;

  const InternshipPage(this._pageArgs, this._internshipApplicationService,
      {Key? key})
      : super(key: key);

  @override
  State<InternshipPage> createState() => _InternshipPageState();
}

const double coverHeight = 180;

class _InternshipPageState extends State<InternshipPage> {
  @override
  Widget build(BuildContext context) {
    // convert the page arguments to the appropriate types
    final crtInternship = widget._pageArgs['internship'] as Internship;
    final crtUser = widget._pageArgs['user'] as User;
    final crtProfile = widget._pageArgs['profile'] as CompanyProfile;
    final appliedInternships =
        widget._pageArgs['notAppliedInternships'] as List<Internship>;
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: themeData.primaryColor,
        title: Text(
          crtInternship.getTitle!,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.grey,
            child: CachedNetworkImage(
              width: double.infinity,
              height: coverHeight,
              fit: BoxFit.cover,
              imageUrl: crtProfile.getImageLink!,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextContent(
                      crtInternship.getTitle!,
                      30,
                      themeData.primaryColorDark,
                    ),
                    buildTextContent(
                      crtInternship.getDescription!,
                      18,
                    ),
                    Row(
                      children: [
                        buildTextContent(
                          'Subject: ',
                          20,
                          themeData.primaryColorDark,
                        ),
                        buildTextContent(
                          TagUtil.convertTagValueToString(
                              crtInternship.getTag!),
                          18,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        buildTextContent(
                          'Starts: ',
                          20,
                          themeData.primaryColorDark,
                        ),
                        buildTextContent(
                          DateFormat('dd/MM/yyyy')
                              .format(crtInternship.getFromDate!),
                          18,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        buildTextContent(
                          'Ends: ',
                          20,
                          themeData.primaryColorDark,
                        ),
                        buildTextContent(
                          DateFormat('dd/MM/yyyy')
                              .format(crtInternship.getToDate!),
                          18,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        buildTextContent(
                          'Number of participants: ',
                          20,
                          themeData.primaryColorDark,
                        ),
                        buildTextContent(
                          crtInternship.getParticipantsNum!.toString(),
                          18,
                        )
                      ],
                    ),
                    buildTextContent(
                      'Requirements: ',
                      20,
                      themeData.primaryColorDark,
                    ),
                    buildTextContent(
                      crtInternship.getRequirements!,
                      18,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // the user can apply to an ongoing internship only if he is a student
          // and has not applied yet to that internship
          if (crtUser.runtimeType == Student &&
              crtInternship.getIsOngoing! &&
              appliedInternships.contains(crtInternship))
            Center(
              child: CustomElevatedButton(
                label: 'Apply',
                onPressed: () async {
                  final internshipApplication = InternshipApplication(
                      internshipId: crtInternship.getId,
                      studentId: crtUser.getUserId);
                  await widget._internshipApplicationService
                      .addInternshipApplication(internshipApplication);
                  Navigator.of(context).pop();
                },
                primary: themeData.primaryColorDark,
              ),
            ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget buildTextContent(String title, double? size, [Color? color]) => Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size,
              color: color,
            ),
          ),
          const SizedBox(height: 10),
        ],
      );
}

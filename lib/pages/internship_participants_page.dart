import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:internship_app_fis/models/internship.dart';
import 'package:internship_app_fis/models/user.dart';
import 'package:internship_app_fis/models/user_profile.dart';
import 'package:internship_app_fis/services/user_profile_service.dart';

import '../base_widgets/custom_elevated_button.dart';
import '../base_widgets/theme_color.dart';

class InternshipParticipantsPage extends StatefulWidget {
  static String namedRoute = '/internship-page-participants';

  final Map<String, dynamic> _pageArgs;
  final UserProfileService _profileService;

  const InternshipParticipantsPage(
    this._pageArgs,
    this._profileService, {
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InternshipParticipantsPageState();
}

class _InternshipParticipantsPageState
    extends State<InternshipParticipantsPage> {
  late Company _company;
  late Internship _internship;
  late Future<List<StudentProfile>> _studentProfiles;
  late Future<List<StudentProfile>> _acceptedParticipants;

  @override
  void initState() {
    super.initState();
    _company = widget._pageArgs['user'] as Company;
    _internship = widget._pageArgs['internship'] as Internship;
    _studentProfiles =
        widget._profileService.getStudentProfilesByInternshipId(_internship);
    _acceptedParticipants =
        widget._profileService.getAcceptedParticipantsList(_internship);
  }

  final appBar = AppBar(
    title: const Text('Participants'),
  );

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: appBar,
      body: FutureBuilder<List<List<StudentProfile>>>(
        future: Future.wait([_studentProfiles, _acceptedParticipants]),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data![0].isNotEmpty) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Text(
                        'Participants ${snapshot.data![1].length}/${_internship.getParticipantsNum}',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data![0].length,
                        itemBuilder: (ctx, idx) => Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 20,
                          ),
                          child: ListTile(
                            // the unique id from the database is used as a key
                            // to ensure that the tiles are rebuilt after one
                            // of them is deleted
                            // key: Key(snapshot.data![idx].getId!.toString()),
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
                                imageUrl: snapshot.data![0][idx].getImageLink!,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              snapshot.data![0][idx].getFullName!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            subtitle: Text(
                              snapshot.data![0][idx].getAbout!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            // add remove buttons
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                snapshot.data![1]
                                        .contains(snapshot.data![0][idx])
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            snapshot.data![1]
                                                .remove(snapshot.data![0][idx]);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.remove,
                                          color: themeData.errorColor,
                                        ),
                                        splashRadius: 20,
                                      )
                                    : IconButton(
                                        onPressed: snapshot.data![1].length <
                                                _internship.getParticipantsNum!
                                            ? () {
                                                setState(() {
                                                  snapshot.data![1].add(
                                                      snapshot.data![0][idx]);
                                                });
                                              }
                                            : null,
                                        icon: const Icon(
                                          Icons.add,
                                        ),
                                        splashRadius: 20,
                                      ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.more_vert),
                                  splashRadius: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: CustomElevatedButton(
                        label: 'Save',
                        onPressed: () async {
                          await widget._profileService
                              .addAcceptedParticipantsList(
                            _internship,
                            snapshot.data![1],
                          );
                        },
                        primary: themeData.primaryColorDark,
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              );
            } else {
              // show a placeholder if there are no ongoing internships
              return Center(
                child: LayoutBuilder(
                  builder: (ctx, constraints) => Container(
                    margin: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'No participants yet',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                          height: constraints.maxHeight * 0.5,
                          child: Image.asset(
                            'assets/images/waiting.png',
                            fit: BoxFit.cover,
                            color: themeData.primaryColorLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

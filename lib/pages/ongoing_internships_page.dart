import 'package:flutter/material.dart';
import 'package:internship_app_fis/pages/add_new_internship_page.dart';
import 'package:mysql1/mysql1.dart';

import '../models/internship.dart';
import '../services/internship_service.dart';
import '../base_widgets/custom_snack_bar.dart';
import '../base_widgets/theme_color.dart';
import '../models/user.dart';

class OngoingInternshipsPage extends StatefulWidget {
  // Page holding the internships of the current company
  static const String namedRoute = '/ongoing-internships-page';

  final InternshipService _internshipService;
  final Map<String, dynamic> _pageArgs;

  const OngoingInternshipsPage(this._pageArgs, this._internshipService,
      {Key? key})
      : super(key: key);

  @override
  State<OngoingInternshipsPage> createState() => _OngoingInternshipsPageState();
}

class _OngoingInternshipsPageState extends State<OngoingInternshipsPage> {
  late Future<List<Internship>> _ongoingInternships;
  late Company _crtCompany;

  @override
  void initState() {
    // when the screen is loaded, fetch all the internships for the
    // current company as a future
    super.initState();
    _crtCompany = widget._pageArgs['user'] as Company;
    _ongoingInternships =
        widget._internshipService.getAllCompanyInternships(_crtCompany);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final appBar = AppBar(
      title: const Text('Ongoing Internships'),
    );
    return Scaffold(
      appBar: appBar,
      body: SizedBox(
        width: double.infinity,
        child: Center(
          // used for displaying a progress indicator until the internships are
          // queried
          child: FutureBuilder<List<Internship>>(
            future: _ongoingInternships,
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
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
                        key: Key(snapshot.data![idx].getId!.toString()),
                        iconColor: themeData.primaryColorDark,
                        tileColor:
                            ColorUtil.lightenColor(themeData.primaryColor, 0.9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        visualDensity:
                            const VisualDensity(horizontal: -1, vertical: -1),
                        // TODO: replace placeholder with user profile photo
                        leading: const CircleAvatar(
                          child: Text('PlcHolder'),
                          backgroundColor: Colors.purple,
                          radius: 30,
                        ),
                        title: Text(
                          snapshot.data![idx].getTitle!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          snapshot.data![idx].getDescription!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        // edit and delete buttons
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                // add the current internship to the page
                                // arguments that will be sent to the edit page
                                var editPageArgs =
                                    Map<String, dynamic>.from(widget._pageArgs);
                                editPageArgs['internship'] =
                                    snapshot.data![idx];
                                Navigator.of(context).pushNamed(
                                  AddNewInternshipPage.namedRoute,
                                  arguments: editPageArgs,
                                );
                              },
                              icon: const Icon(Icons.edit_outlined),
                              splashRadius: 25,
                            ),
                            IconButton(
                              onPressed: () async {
                                try {
                                  await widget._internshipService
                                      .deleteInternship(snapshot.data![idx]);
                                  setState(() {
                                    snapshot.data!.removeAt(idx);
                                  });
                                } on MySqlException {
                                  final snackBar = MessageSnackBar(
                                      'We could not delete this internship, try again later.');
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                              icon: const Icon(Icons.delete_outline),
                              color: themeData.errorColor,
                              splashRadius: 25,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  // show a placeholder if there are no ongoing internships
                  return LayoutBuilder(
                    builder: (ctx, constraints) => Container(
                      margin: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'No ongoing internships to show',
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
                  );
                }
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

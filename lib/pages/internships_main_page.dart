import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

import '../base_widgets/main_drawer.dart';
import '../models/internship.dart';
import '../services/internship_service.dart';
import '../base_widgets/custom_snack_bar.dart';
import '../base_widgets/theme_color.dart';
import '../models/user.dart';
import '../pages/add_new_internship_page.dart';
import 'internship_page.dart';

class InternshipsMainPage extends StatefulWidget {
  // Page holding the internships of the current company
  static const String namedRoute = '/ongoing-internships-page';

  final InternshipService _internshipService;
  final Map<String, dynamic> _pageArgs;

  const InternshipsMainPage(this._pageArgs, this._internshipService,
      {Key? key})
      : super(key: key);

  @override
  State<InternshipsMainPage> createState() => _InternshipsMainPageState();
}

class _InternshipsMainPageState extends State<InternshipsMainPage> {
  late Future<List<Internship>> _ongoingInternships;
  late Company _crtCompany;

  FutureOr _updateOngoingInternshipsList(dynamic value) {
    setState(() {
      _ongoingInternships =
          widget._internshipService.getEveryCompanyInternship();
    });
  }

  @override
  void initState() {
    super.initState();
    _crtCompany = widget._pageArgs['user'] as Company;
    _ongoingInternships =
        widget._internshipService.getEveryCompanyInternship();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final appBar = AppBar(
      title: const Text('All Internships'),
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: themeData.primaryColor,
        title: const Text('Internship App'),
      ),
      drawer: const MainDrawer(),
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
                    itemBuilder: (ctx, idx) => GestureDetector(
                      onTap: () async {
                        //if (snapshot.data![idx] != null) {
                        Navigator.of(context).pushReplacementNamed(
                          InternshipPage.namedRoute,
                          arguments: <String, dynamic>{
                            'user': snapshot.data![idx]
                          },
                        );
                        //}
                      },
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 24,
                        ),
                        child: ListTile(
                          // the unique id from the database is used as a key
                          // to ensure that the tiles are rebuilt after one
                          // of them is deleted
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

                            trailing: Icon(snapshot.data![idx].getIsOngoing != 1 ? Icons.check
                                : Icons.wrong_location)
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



import 'package:flutter/material.dart';

import '../models/internship.dart';

class TagSearchDelegate extends SearchDelegate {
  final void Function(String?) _stateFunction;
  List<String> searchTerms = Tag.values
      .map((value) => TagUtil.convertTagValueToString(value))
      .toList();

  TagSearchDelegate(this._stateFunction);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        splashRadius: 20,
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
          _stateFunction(null);
          Navigator.of(context).pop();
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      splashRadius: 20,
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var tag in searchTerms) {
      if (tag.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(tag);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(result),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var tag in searchTerms) {
      if (tag.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(tag);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(result),
            onTap: () {
              _stateFunction(result);
              Navigator.of(context).pop();
            },
          );
        });
  }
}

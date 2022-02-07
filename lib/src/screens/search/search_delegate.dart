import 'package:flutter/material.dart';
import 'package:moviebox/src/core/repo/search_repo.dart';
import 'package:moviebox/src/screens/search/search_result.dart';

// FILES

class DataSearch extends SearchDelegate {
  String selection = '';
  final moviesProvider = new SearchRepo();

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions of our AppBar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icon at the left of AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Build the results to show
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(selection),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    return new SearchResult(id: query, title: query);
  }
}

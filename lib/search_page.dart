import 'package:flutter/material.dart';
import 'player_list.dart';

class SearchPage extends StatelessWidget {
  SearchPage(this._sounds, this._handleLikePress);

  final List<Map<String, String>> _sounds;
  final Function _handleLikePress;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('search'));
  }
}

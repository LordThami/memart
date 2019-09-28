import 'package:flutter/material.dart';
import 'package:meme_soundboard/sound_data.dart';
import 'player_list.dart';

class SearchPage extends StatefulWidget {
  SearchPage(this._sounds, this._handleLikePress);

  final List<Map<String, String>> _sounds;
  final Function _handleLikePress;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, String>> _foundSounds = [];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          TextField(
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
            autofocus: true,
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: 'Search by title',
              prefixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.all(16.0),
              fillColor: Colors.grey[900],
              filled: true,
              border: InputBorder.none,
            ),
            onChanged: (newInputValue) {
              print(newInputValue);
              setState(() {
                if (newInputValue.length > 1) {
                  var valueExp = RegExp(r'(^|\W)' + newInputValue.toString(),
                      caseSensitive: false);
                  print(valueExp);
                  _foundSounds = soundData
                      .where((sound) => valueExp.hasMatch(sound['title']))
                      .toList();
                } else {
                  _foundSounds = [];
                }
              });
            },
          ),
          _foundSounds.length > 0
              ? PlayerList(_foundSounds, widget._handleLikePress)
              : Text('No results'),
        ],
      ),
    );
  }
}

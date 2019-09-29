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
  String _inputValue = '';
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
              setState(() {
                _inputValue = newInputValue;
                if (newInputValue.length > 0) {
                  var valueExp = RegExp(r'(^|\W)' + newInputValue.toString(),
                      caseSensitive: false);
                  _foundSounds = soundData
                      .where((sound) => valueExp.hasMatch(sound['title']))
                      .toList();
                } else {
                  _foundSounds = [];
                }
              });
            },
          ),
          Expanded(
            child: _foundSounds.length > 0
                ? PlayerList(_foundSounds, widget._handleLikePress)
                : _inputValue.length > 0
                    ? Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          'No results found for "$_inputValue"',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      )
                    : Container(
                        height: 0,
                      ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
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
              hintText: 'Search by title or theme',
              prefixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.all(16.0),
              fillColor: Colors.grey[900],
              filled: true,
              border: InputBorder.none,
            ),
            onChanged: filterSounds,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                print('TAP');
              },
              onVerticalDragStart: (o) {
                print('VERTICAL');
              },
              child: _foundSounds.length > 0
                  ? PlayerList(_foundSounds, widget._handleLikePress)
                  : _inputValue.length > 0
                      ? Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            'No results found for "$_inputValue"',
                            style: TextStyle(fontSize: 16.0),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.transparent,
                        ),
            ),
          ),
        ],
      ),
    );
  }

  void filterSounds(newInputValue) {
    setState(() {
      _inputValue = newInputValue.toString();

      if (_inputValue.length > 0) {
        Set<String> resultsFileNames = Set();
        List<Map<String, String>> results = [];

        [
          {
            'searchProperty': 'title',
            'regex': r'^' + _inputValue,
          },
          {
            'searchProperty': 'title',
            'regex': r'\W' + _inputValue,
          },
          {
            'searchProperty': 'searchString',
            'regex': r'(^|\W)' + _inputValue,
          },
        ].forEach((searchRules) {
          var regex = RegExp(
            searchRules['regex'],
            caseSensitive: false,
          );

          widget._sounds.forEach((sound) {
            var searchProperty = sound[searchRules['searchProperty']] ?? '';

            if (resultsFileNames.contains(sound['soundPath']) == false &&
                regex.hasMatch(searchProperty)) {
              results.add(sound);
              resultsFileNames.add(sound['soundPath']);
            }
          });
        });

        _foundSounds = results;
      } else {
        _foundSounds = [];
      }
    });
  }
}

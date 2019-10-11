import 'package:flutter/material.dart';
import 'package:meme_soundboard/app_model.dart';
import 'package:provider/provider.dart';
import 'player_list.dart';

class SearchPage extends StatefulWidget {
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
            onChanged: (input) {
              setState(() {
                _foundSounds = Provider.of<AppModel>(context, listen: false)
                    .getSearchResults(input);
              });
            },
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
              child: (_foundSounds ?? []).length > 0
                  ? PlayerList(_foundSounds, 'search')
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
}

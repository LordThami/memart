import 'package:flutter/material.dart';
import 'package:meme_soundboard/app_model.dart';
import 'package:meme_soundboard/custom_icons_icons.dart';
import 'package:provider/provider.dart';
import 'player_list.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, String>> _foundSounds = [];
  final TextEditingController _inputController = new TextEditingController();

  @override
  void initState() {
    var searchString =
        Provider.of<AppModel>(context, listen: false).searchString;
    _inputController.text = searchString;
    _foundSounds = Provider.of<AppModel>(context, listen: false)
        .getSearchResults(searchString);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var searchString = Provider.of<AppModel>(context).searchString;
    return Center(
      child: Column(
        children: <Widget>[
          TextField(
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
            controller: _inputController,
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: 'Search by title or theme',
              prefixIcon: Icon(CustomIcons.search_empty),
              contentPadding: EdgeInsets.all(16.0),
              fillColor: Colors.white30,
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
                  : searchString.length > 0
                      ? Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            'No results found for "$searchString"',
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

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
  final FocusNode _inputFocus = new FocusNode();

  @override
  void initState() {
    var searchString =
        Provider.of<AppModel>(context, listen: false).searchString;
    _inputController.text = searchString;
    _inputController.addListener(() {
      setState(() {
        _foundSounds = Provider.of<AppModel>(context, listen: false)
            .getSearchResults(_inputController.text);
      });
    });
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
            focusNode: _inputFocus,
            controller: _inputController,
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: 'Search by title or theme',
              prefixIcon: Icon(CustomIcons.search_empty),
              suffixIcon: Opacity(
                opacity: searchString.length > 0 ? 1.0 : 0.0,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    _inputController.clear();
                    // Focus.of(context).requestFocus(_inputFocus);
                  },
                ),
              ),
              contentPadding: EdgeInsets.all(16.0),
              fillColor: Colors.white30,
              filled: true,
              border: InputBorder.none,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
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

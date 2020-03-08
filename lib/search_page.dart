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

  bool isLoading = true;

  @override
  void initState() {
    print('init');
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextField(
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
          autofocus: true,
          focusNode: _inputFocus,
          controller: _inputController,
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: 'Search by title or theme',
            prefixIcon: Icon(CustomIcons.search_empty),
            suffixIcon: Opacity(
              opacity: _inputController.text.length > 0 ? 1.0 : 0.0,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _inputController.clear();
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
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) {
              FocusScope.of(context).unfocus();
            },
            child: (_foundSounds ?? []).length > 0
                ? PlayerList(_foundSounds, 'search')
                : _inputController.text.length > 0
                    ? _buildNoResults()
                    : Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.transparent,
                      ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoResults() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: <Widget>[
          Text(
            'No results',
            style: TextStyle(fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40.0),
          Text(
            'Request to add "${_inputController.text}"?',
            style: TextStyle(fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0),
          RaisedButton(
            child: Text('Yes, please'),
            color: Colors.pink,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

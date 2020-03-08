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
          SuggestionForm(suggestion: _inputController.text),
        ],
      ),
    );
  }
}

class SuggestionForm extends StatefulWidget {
  const SuggestionForm({
    Key key,
    @required this.suggestion,
  }) : super(key: key);

  final String suggestion;

  @override
  _SuggestionFormState createState() => _SuggestionFormState();
}

enum _FormState {
  normal,
  waiting,
  success,
  fail,
}

class _SuggestionFormState extends State<SuggestionForm> {
  _FormState state = _FormState.normal;

  @override
  void didUpdateWidget(SuggestionForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    final hasSuggestion =
        Provider.of<AppModel>(context).hasSuggestion(widget.suggestion);
    final newState = hasSuggestion ? _FormState.success : _FormState.normal;
    setState(() {
      state = newState;
    });
  }

  Future<void> handleSubmit(AppModel model) async {
    setState(() {
      state = _FormState.waiting;
    });
    final isSuccess = await model.addSuggestion(widget.suggestion);
    setState(() {
      state = isSuccess ? _FormState.success : _FormState.fail;
    });
  }

  String getTitle() {
    switch (state) {
      case _FormState.normal:
        return 'Request to add "${widget.suggestion}"?';
      case _FormState.waiting:
        return 'Submitting...';
      case _FormState.success:
        return 'Submitted!';
      case _FormState.fail:
        return 'Couldn\'t submit';
      default:
        throw Exception('Unindentified suggestion form state');
    }
  }

  Widget _buildButtonOrLoader({Function callback}) {
    RaisedButton _buildButton(String text) {
      return RaisedButton(
        child: Text(text),
        color: Colors.pink,
        onPressed: callback,
      );
    }

    switch (state) {
      case _FormState.normal:
        return _buildButton('Yes, please');
      case _FormState.waiting:
        return CircularProgressIndicator();
      case _FormState.success:
        return Icon(
          Icons.check_circle_outline,
          size: 48.0,
        );
      case _FormState.fail:
        return _buildButton('Try again');
      default:
        throw Exception('Unindentified suggestion form state');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, model, child) {
        return Column(
          children: <Widget>[
            SizedBox(height: 40.0),
            Text(
              getTitle(),
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            Container(
              height: 48.0,
              child: Center(
                child: _buildButtonOrLoader(
                  callback: () => handleSubmit(model),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

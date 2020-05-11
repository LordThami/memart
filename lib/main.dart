import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:meme_soundboard/app_model.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'custom_icons_icons.dart';
import 'home_page.dart';
import 'favorites_page.dart';
import 'search_page.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
  ));
  runApp(ChangeNotifierProvider(
    builder: (context) => AppModel(),
    child: MemeSoundboardApp(),
  ));
}

class MemeSoundboardApp extends StatefulWidget {
  @override
  _MemeSoundboardAppState createState() => _MemeSoundboardAppState();
}

class _MemeSoundboardAppState extends State<MemeSoundboardApp> {
  static const int _startingPageId = 0;
  int _selectedPageId = _startingPageId;

  final _controller = PageController(
    initialPage: _startingPageId,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memart',
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        accentColor: Colors.white,
        // canvasColor: Color(0xFF3D4349),
        canvasColor: Color(0xFF1F1F1F),
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: AppBody(controller: _controller),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Color(0xFF35383C),
            border: Border(
                top: BorderSide(
              width: 1.0,
              color: Color(0xFF1F1F1F),
            )),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    _selectedPageId == 0
                        ? CustomIcons.home
                        : CustomIcons.home_empty,
                  ),
                  title: Text('Home'),
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 1.5),
                    child: Icon(
                      _selectedPageId == 1
                          ? CustomIcons.search
                          : CustomIcons.search_empty,
                    ),
                  ),
                  title: Text('Search'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    _selectedPageId == 2
                        ? CustomIcons.heart
                        : CustomIcons.heart_empty,
                  ),
                  title: Text('Favorites'),
                ),
              ],
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconSize: 28.0,
              unselectedFontSize: 11.0,
              selectedFontSize: 11.0,
              unselectedLabelStyle: TextStyle(height: 1.4),
              selectedLabelStyle: TextStyle(height: 1.4),
              currentIndex: _selectedPageId,
              onTap: (newId) => setState(() {
                _controller.jumpToPage(newId);
                _selectedPageId = newId;
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class AppBody extends StatelessWidget {
  const AppBody({
    Key key,
    @required PageController controller,
  })  : _controller = controller,
        super(key: key);

  final PageController _controller;

  //BoxShadow(blurRadius: 4.0, color: Color.fromRGBO(0, 0, 0, 0.6)

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _controller,
              children: [
                HomePage(),
                SearchPage(),
                FavoritesPage(),
              ],
            ),
          ),
          BottomPlayer(),
        ],
      ),
    );
  }
}

class BottomPlayer extends StatelessWidget {
  const BottomPlayer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (context, model, child) {
      var selectedSound = model.getSelectedSound();

      if (selectedSound == null) return Container();

      final selectedSoundTitle = selectedSound['title'];
      final selectedSoundImagePath = selectedSound['imagePath'];
      final isLiked = model.isLiked(model.selectedSoundPath);

      final _playerIcon = model.isPlaying
          ? Icons.pause_circle_filled
          : Icons.play_circle_filled;

      return Container(
        height: 72,
        decoration: BoxDecoration(
          color: Color(0xFF35383C),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            _buildPlayer(model, selectedSoundImagePath, _playerIcon),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                selectedSoundTitle,
                maxLines: 2,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
            ),
            SizedBox(width: 16),
            IconButton(
              splashColor: Colors.transparent,
              padding: const EdgeInsets.all(16.0),
              icon: Icon(
                Icons.share,
                color: Colors.white70,
                size: 24.0,
              ),
              onPressed: () => model.share(),
            ),
            LikeButton(
              isLiked: isLiked,
              onPressed: () => isLiked
                  ? model.unlike(model.selectedSoundPath)
                  : model.like(model.selectedSoundPath),
            ),
          ],
        ),
      );
    });
  }

  GestureDetector _buildPlayer(
      AppModel model, String selectedSoundImagePath, IconData _playerIcon) {
    return GestureDetector(
      onTap: () => model.isPlaying ? model.stop() : model.play(),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('assets/images/$selectedSoundImagePath'),
            color: Colors.black26,
            colorBlendMode: BlendMode.darken,
          ),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 20.0,
                  ),
                ]),
              ),
              Icon(
                _playerIcon,
                size: 40.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LikeButton extends StatelessWidget {
  const LikeButton({
    Key key,
    @required this.isLiked,
    @required this.onPressed,
  }) : super(key: key);

  final bool isLiked;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            CustomIcons.heart,
            color: isLiked ? Colors.white : Colors.transparent,
            size: 24.0,
          ),
        ),
        IconButton(
          splashColor: Colors.transparent,
          padding: const EdgeInsets.all(16.0),
          icon: Icon(
            CustomIcons.heart_empty,
            color: isLiked ? Colors.transparent : Colors.white70,
            size: 24.0,
          ),
          onPressed: onPressed,
        ),
      ],
    );
  }
}

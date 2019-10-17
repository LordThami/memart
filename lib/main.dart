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
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        accentColor: Colors.white,
        // canvasColor: Color(0xFF3D4349),
        canvasColor: Color(0xFF1F1F1F),
      ),
      home: Scaffold(
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

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      panel: Panel(),
      minHeight: 64,
      maxHeight: 144,
      parallaxEnabled: true,
      backdropEnabled: true,
      // color: Color(0xFF383A3D),
      color: Color(0xFF35383C),
      boxShadow: const <BoxShadow>[
        BoxShadow(blurRadius: 4.0, color: Color.fromRGBO(0, 0, 0, 0.6))
      ],
      borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16.0),
          topRight: const Radius.circular(16.0)),
      body: SafeArea(
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
    );
  }
}

class Panel extends StatelessWidget {
  const Panel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  height: 3,
                  width: 40,
                  decoration: ShapeDecoration(
                    color: Colors.white24,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              ),
            ),
            BottomPlayer(),
          ],
        ),
        Expanded(
          child: Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: RaisedButton(
                  color: Colors.pink,
                  child: Text('Share this sound'),
                  onPressed: () async {
                    Provider.of<AppModel>(context, listen: false).share();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
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
      var selectedSoundTitle = model.getSelectedSoundTitle();
      var isLiked = model.isLiked(model.selectedSoundPath);

      if (selectedSoundTitle == null) return Container();

      return Container(
        height: 64,
        child: Stack(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  selectedSoundTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 56.0,
                width: 56.0,
                child: FlatButton(
                  padding: EdgeInsets.all(0.0),
                  child: Container(
                    height: 32.0,
                    width: 32.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: Colors.white,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: model.isPlaying
                          ? Icon(
                              Icons.stop,
                              size: 20.0,
                            )
                          : Icon(
                              Icons.play_arrow,
                              size: 20.0,
                            ),
                    ),
                  ),
                  onPressed: () =>
                      model.isPlaying ? model.stop() : model.play(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(
                      CustomIcons.heart,
                      color: isLiked ? Colors.pink : Colors.black26,
                      size: 24.0,
                    ),
                  ),
                  IconButton(
                    splashColor: Colors.transparent,
                    padding: const EdgeInsets.all(16.0),
                    icon: Icon(
                      CustomIcons.heart_empty,
                      color: isLiked ? Colors.white : Colors.white70,
                      size: 24.0,
                    ),
                    onPressed: () => isLiked
                        ? model.unlike(model.selectedSoundPath)
                        : model.like(model.selectedSoundPath),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

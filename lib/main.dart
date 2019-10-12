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
            color: Color(0xFF202122),
            border: Border(
                top: BorderSide(
              width: 1.0,
              color: Colors.black,
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
                  icon: Icon(
                    _selectedPageId == 1 ? Icons.search : Icons.search,
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
              unselectedFontSize: 12.0,
              selectedFontSize: 12.0,
              unselectedLabelStyle: TextStyle(height: 1.3),
              selectedLabelStyle: TextStyle(height: 1.3),
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
      minHeight: 80,
      maxHeight: 200,
      parallaxEnabled: true,
      backdropEnabled: true,
      // color: Color(0xFF2A2C2E),
      color: Color(0xFF202122),
      boxShadow: const <BoxShadow>[
        BoxShadow(blurRadius: 4.0, color: Color.fromRGBO(0, 0, 0, 0.6))
      ],
      borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(32.0),
          topRight: const Radius.circular(32.0)),
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
        Padding(
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
        Container(
          height: 58.0,
          child: Center(child: Text('Title')),
        ),
      ],
    );
  }
}

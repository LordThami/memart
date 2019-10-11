import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:meme_soundboard/app_model.dart';
import 'package:provider/provider.dart';
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
      ),
      home: Scaffold(
        body: SafeArea(
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _controller,
            children: [
              HomePage(),
              Text('search'),
              // SearchPage(),
              FavoritesPage(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.black,
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
              backgroundColor: Colors.black,
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

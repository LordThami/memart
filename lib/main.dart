import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_icons_icons.dart';
import 'sound_data.dart';
import 'player_list.dart';
import 'favorites_page.dart';
import 'search_page.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
  ));
  runApp(MemeSoundboardApp());
}

class MemeSoundboardApp extends StatefulWidget {
  @override
  _MemeSoundboardAppState createState() => _MemeSoundboardAppState();
}

class _MemeSoundboardAppState extends State<MemeSoundboardApp> {
  static final _startingPageId = 0;
  int _selectedPageId = _startingPageId;
  List<String> _likedSoundPaths = [];
  SharedPreferences _prefs;

  List<Map<String, String>> getAllSounds() {
    return soundData.map((sound) {
      if (_likedSoundPaths.contains(sound['soundPath']))
        sound['liked'] = 'true';
      else
        sound['liked'] = 'false';
      return sound;
    }).toList();
  }

  List<Map<String, String>> getLikedSounds() {
    var liked = soundData
        .map((sound) {
          if (_likedSoundPaths.contains(sound['soundPath']))
            sound['liked'] = 'true';
          else
            sound['liked'] = 'false';
          return sound;
        })
        .where((sound) => _likedSoundPaths.contains(sound['soundPath']))
        .toList();
    liked.sort((a, b) =>
        _likedSoundPaths.indexOf(a['soundPath']) -
        _likedSoundPaths.indexOf(b['soundPath']));
    return liked;
  }

  Future<void> initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _likedSoundPaths = _prefs.getStringList('likedSoundPaths') ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    initPreferences();
  }

  void _handleLikePress(String soundPath) async {
    setState(() {
      if (_likedSoundPaths.contains(soundPath)) {
        _likedSoundPaths.remove(soundPath);
      } else {
        _likedSoundPaths.add(soundPath);
      }
    });
    await _prefs.setStringList('likedSoundPaths', _likedSoundPaths);
  }

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
              PlayerList(getAllSounds(), _handleLikePress, keyName: 'home'),
              SearchPage(getAllSounds(), _handleLikePress),
              FavoritesPage(getLikedSounds(), _handleLikePress,
                  keyName: 'favorites'),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
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
    );
  }
}

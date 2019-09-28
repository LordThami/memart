import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_icons_icons.dart';
import 'sound_data.dart';
import 'player_list.dart';
import 'favorites_page.dart';

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
  int _selectedPageId = 0;
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
        body: AnimatedSwitcher(
            duration: Duration(milliseconds: 100),
            child: [
              PlayerList(getAllSounds(), _handleLikePress),
              FavoritesPage(getLikedSounds(), _handleLikePress),
            ].elementAt(_selectedPageId)),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                _selectedPageId == 0
                    ? CustomIcons.home
                    : CustomIcons.home_empty,
                size: 32.0,
              ),
              title: Container(
                height: 0,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedPageId == 1
                    ? CustomIcons.heart
                    : CustomIcons.heart_empty,
                size: 32.0,
              ),
              title: Container(
                height: 0,
              ),
            ),
          ],
          currentIndex: _selectedPageId,
          onTap: (newId) => setState(() {
            _selectedPageId = newId;
          }),
        ),
      ),
    );
  }
}

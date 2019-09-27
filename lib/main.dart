import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'player_list.dart';
import 'custom_icons_icons.dart';

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
  List<Map<String, String>> _sounds = [
    {
      'title': 'Aww',
      'soundPath': 'AWW.mp3',
      'imagePath': 'aww.jpg',
    },
    {
      'title': 'Crickets',
      'soundPath': 'CRICKETS CHIRPING.mp3',
      'imagePath': 'crickets.jpg',
    },
    {
      'title': 'Dramatic chipmunk',
      'soundPath': 'Dramatic-chipmunk.mp3',
      'imagePath': 'dramatic_chipmunk.jpg',
    },
    {
      'title': 'Ka-ching!',
      'soundPath': 'KA-CHING.mp3',
      'imagePath': 'ka-ching.jpg',
    },
    {
      'title': 'Nope',
      'soundPath': 'NOPE.mp3',
      'imagePath': 'nope.jpg',
    },
    {
      'title': 'Record scratch',
      'soundPath': 'RECORD SCRATCH.mp3',
      'imagePath': 'record_scratch.jpg',
    },
    {
      'title': 'Rubber duck',
      'soundPath': 'RUBBER DUCK.mp3',
      'imagePath': 'rubber_duck.jpg',
    },
    {
      'title': 'Suddenly!',
      'soundPath': 'SUDDEN SUSPENSE.mp3',
      'imagePath': 'sudden_suspense.jpg',
    },
    {
      'title': 'Suspense',
      'soundPath': 'SUSPENSE #2.mp3',
      'imagePath': 'suspense.jpg',
    },
    {
      'title': 'To be continued...',
      'soundPath': 'TO BE CONTINUED.mp3',
      'imagePath': 'to_be_continued.jpg',
    },
    {
      'title': 'Windows Error',
      'soundPath': 'WINDOWS XP ERROR.mp3',
      'imagePath': 'windows_error.jpg',
    },
    {
      'title': 'Windows start up',
      'soundPath': 'WINDOWS XP START UP.mp3',
      'imagePath': 'windows_startup.jpg',
    },
    {
      'title': 'Ain\'t nobody got time for that',
      'soundPath': 'AINT NOBODY GOT TIME FOR THAT.mp3',
      'imagePath': 'no_time.jpg',
    },
    {
      'title': 'John Cena',
      'soundPath': 'AND HIS NAME IS JOHN CENA.mp3',
      'imagePath': 'john_cena.jpg',
    },
    {
      'title': 'Ba dum tss',
      'soundPath': 'BA DUM TSS.mp3',
      'imagePath': 'badums.jpg',
    },
    {
      'title': 'Bruh',
      'soundPath': 'BRUH.mp3',
      'imagePath': 'bruh.jpg',
    },
    {
      'title': 'Burp',
      'soundPath': 'BURP.mp3',
      'imagePath': 'burp.jpg',
    },
    {
      'title': 'Wrong',
      'soundPath': 'BUZZER OR WRONG ANSWER.mp3',
      'imagePath': 'wrong.jpg',
    },
    {
      'title': 'Cartoon laugh',
      'soundPath': 'CARTOON LAUGH.mp3',
      'imagePath': 'chip.png',
    },
    {
      'title': 'Zoidberd woop',
      'soundPath': 'DR ZOIDBERG WOOP.mp3',
      'imagePath': 'zoid.jpg',
    },
    {
      'title': 'Crowd cheering',
      'soundPath': 'CROWD CHEERING.mp3',
      'imagePath': 'crowd_cheer.jpg',
    },
    {
      'title': 'Doh',
      'soundPath': 'D\'OH.mp3',
      'imagePath': 'doh.jpg',
    },
    {
      'title': 'Denied',
      'soundPath': 'DENIED.mp3',
      'imagePath': 'denied.jpg',
    },
    {
      'title': 'Drum roll',
      'soundPath': 'DRUM ROLL.mp3',
      'imagePath': 'drum_roll.jpg',
    },
    {
      'title': 'DUN DUN DUN',
      'soundPath': 'DUN DUN DUNNN.mp3',
      'imagePath': 'dun_dun.jpg',
    },
    {
      'title': 'Fail',
      'soundPath': 'FAIL.mp3',
      'imagePath': 'fail_horn.png',
    },
    {
      'title': 'Get over here!',
      'soundPath': 'GET OVER HERE.mp3',
      'imagePath': 'get_over_here.jpg',
    },
    {
      'title': 'Ha! Gay!',
      'soundPath': 'HA GAY.mp3',
      'imagePath': 'ha_gay.jpg',
    },
    {
      'title': 'Ha! Got em',
      'soundPath': 'HA GOT EMM.mp3',
      'imagePath': 'got_em.jpg',
    },
    {
      'title': 'HA HA',
      'soundPath': 'HA HA (NELSON).mp3',
      'imagePath': 'ha_ha.jpg',
    },
    {
      'title': 'Heart beat',
      'soundPath': 'HEART BEAT.mp3',
      'imagePath': 'heart_beat.jpg',
    },
    {
      'title': 'Heavenly choir',
      'soundPath': 'HEAVENLY CHOIR.mp3',
      'imagePath': 'heaven.jpg',
    },
    {
      'title': 'Illuminati',
      'soundPath': 'ILLUMINATI.mp3',
      'imagePath': 'illuminati.jpg',
    },
    {
      'title': 'Inception horn',
      'soundPath': 'INCEPTION FOG HORN.mp3',
      'imagePath': 'inception.jpg',
    },
    {
      'title': 'Mario',
      'soundPath': 'MARIO HERE WE GO.mp3',
      'imagePath': 'mario.jpg',
    },
    {
      'title': 'MGS Alert',
      'soundPath': 'MGS ALERT.mp3',
      'imagePath': 'alert.jpg',
    },
    {
      'title': 'God please no',
      'soundPath': 'NO GOD PLEASE NO.mp3',
      'imagePath': 'no.png',
    },
    {
      'title': 'OMG, who the hell cares',
      'soundPath': 'OMG WHO THE HELL CARES.mp3',
      'imagePath': 'peter_who_cares.jpg',
    },
    {
      'title': 'Sad violin',
      'soundPath': 'SAD MUSIC #2.mp3',
      'imagePath': 'tiny_violin.jpg',
    },
    {
      'title': 'Flintstone scrambling',
      'soundPath': 'SCRAMBLING - FRED FLINTSTONE.mp3',
      'imagePath': 'flintstone.jpg',
    },
    {
      'title': 'Somebody toucha my spaghet',
      'soundPath': 'somebody-toucha-my-spaghet.mp3',
      'imagePath': 'touch_my_sphaget.png',
    },
    {
      'title': 'A few moments later',
      'soundPath': 'SPONGEBOB TIME CARDS - A FEW MOMENTS LATER.mp3',
      'imagePath': 'few_moments.jpg',
    },
    {
      'title': 'Eventually',
      'soundPath': 'SPONGEBOB TIME CARDS - EVENTUALLY.mp3',
      'imagePath': 'eventually.jpg',
    },
    {
      'title': 'Meanwhile',
      'soundPath': 'SPONGEBOB TIME CARDS - MEANWHILE.mp3',
      'imagePath': 'meanwhile.jpg',
    },
    {
      'title': 'One eternity later',
      'soundPath': 'SPONGEBOB TIME CARDS - ONE ETERNITY LATER.mp3',
      'imagePath': 'eternity_later.jpg',
    },
    {
      'title': 'Uhhh',
      'soundPath': 'SPONGEBOB TIME CARDS - UHH.mp3',
      'imagePath': 'uhhh.jpg',
    },
    {
      'title': 'Surprise',
      'soundPath': 'SURPRISE MOTHER F!!!!!.mp3',
      'imagePath': 'surprise.jpg',
    },
    {
      'title': 'They ask you how you are',
      'soundPath': 'THEY ASK YOU HOW YOU ARE.mp3',
      'imagePath': 'crying.jpg',
    },
    {
      'title': 'Titanic flute fail',
      'soundPath': 'TITANIC FLUTE FAIL.mp3',
      'imagePath': 'titanic.jpg',
    },
    {
      'title': 'Vine boom',
      'soundPath': 'VINE GUN SHOT aka BOOM.mp3',
      'imagePath': 'vine.jpg',
    },
    {
      'title': 'Y u always lying',
      'soundPath': 'Y U ALWAYS LYING.mp3',
      'imagePath': 'always_lying.jpg',
    },
    {
      'title': 'Yay!',
      'soundPath': 'YAY.mp3',
      'imagePath': 'yay.jpg',
    },
  ];

  List<Map<String, String>> getAllSounds() {
    return _sounds.map((sound) {
      if (_likedSoundPaths.contains(sound['soundPath']))
        sound['liked'] = 'true';
      else
        sound['liked'] = 'false';
      return sound;
    }).toList();
  }

  List<Map<String, String>> getLikedSounds() {
    var liked = _sounds
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
      title: 'Meme soundboard',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        accentColor: Colors.white,
      ),
      home: Scaffold(
        body: AnimatedSwitcher(
            duration: Duration(milliseconds: 400),
            child: [
              PlayerList(getAllSounds(), _handleLikePress),
              Padding(
                // temporary fix to init new state
                padding: const EdgeInsets.all(0.0),
                child: PlayerList(getLikedSounds(), _handleLikePress),
              ),
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

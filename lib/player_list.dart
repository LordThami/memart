import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'only_one_pointer_recorgnizer.dart';
import 'player.dart';

class PlayerList extends StatefulWidget {
  PlayerList(this._sounds, this._handleLikePress);

  final List<Map<String, String>> _sounds;
  final Function _handleLikePress;

  @override
  _PlayerListState createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  AudioCache _audioCache;
  AudioPlayer _player;
  int _playingSoundId;

  @override
  void initState() {
    super.initState();
    _audioCache = AudioCache(prefix: 'sounds/');
    _audioCache
        .loadAll(widget._sounds.map((sound) => sound['soundPath']).toList());
    _playingSoundId = null;
  }

  @override
  void dispose() async {
    super.dispose();
    await _player.stop();
  }

  void handlePress(int pressedSoundId) async {
    if (_playingSoundId != null) await _player.stop();
    if (_playingSoundId != pressedSoundId) {
      _player =
          await _audioCache.play(widget._sounds[pressedSoundId]['soundPath']);
      _player.onPlayerCompletion.listen((_) => setState(() {
            _playingSoundId = null;
          }));
      setState(() {
        _playingSoundId = pressedSoundId;
      });
    } else {
      setState(() {
        _playingSoundId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnlyOnePointerRecognizerWidget(
      child: ButtonTheme(
        buttonColor: Colors.transparent,
        textTheme: ButtonTextTheme.normal,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: GridView.count(
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 1.0,
          crossAxisCount: 2,
          padding: EdgeInsets.fromLTRB(16.0, 80.0, 16.0, 24.0),
          children: widget._sounds
              .asMap()
              .map((id, sound) => MapEntry(
                  id,
                  Player(
                    isPlaying: _playingSoundId == id,
                    isLiked: sound['liked'] == 'true',
                    title: sound['title'],
                    imagePath: sound['imagePath'],
                    handlePress: () {
                      handlePress(id);
                    },
                    handleLikePress: () {
                      widget._handleLikePress(sound['soundPath']);
                    },
                  )))
              .values
              .toList(),
        ),
      ),
    );
  }
}

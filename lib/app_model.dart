import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'sound_data.dart';

class AppModel extends ChangeNotifier {
  static const String LIKED_SOUND_PATH_KEY = 'likedSoundPaths';
  SharedPreferences _prefs;
  List<String> _likedSoundPaths = [];
  AudioCache _audioCache;
  AudioPlayer _player;
  String _playingSoundPath;
  List<Map<String, String>> sounds;

  AppModel() {
    _audioCache = AudioCache(prefix: 'sounds/');
    sounds = soundData;
    loadLikes();
  }

  Future<void> loadLikes() async {
    _prefs = await SharedPreferences.getInstance();
    _likedSoundPaths = _prefs.getStringList(LIKED_SOUND_PATH_KEY) ?? [];
  }

  Future<void> play(String newSoundPath) async {
    if (_playingSoundPath != null && _player != null) await _player.stop();
    _playingSoundPath = newSoundPath;
    notifyListeners();
    _player = await _audioCache.play(newSoundPath);
    _player.onPlayerCompletion.listen((_) {
      _playingSoundPath = null;
      notifyListeners();
    });
  }

  Future<int> stop() async {
    _playingSoundPath = null;
    notifyListeners();
    return _player.stop();
  }

  Future<bool> like(String soundPath) async {
    if (_likedSoundPaths.contains(soundPath)) return false;
    _likedSoundPaths.add(soundPath);
    notifyListeners();
    return _prefs.setStringList(LIKED_SOUND_PATH_KEY, _likedSoundPaths);
  }

  Future<bool> unlike(String soundPath) async {
    if (!_likedSoundPaths.contains(soundPath)) return false;
    _likedSoundPaths.remove(soundPath);
    notifyListeners();
    return _prefs.setStringList(LIKED_SOUND_PATH_KEY, _likedSoundPaths);
  }

  bool isPlaying(String soundPath) {
    return _playingSoundPath == soundPath;
  }

  bool isLiked(String soundPath) {
    return _likedSoundPaths.contains(soundPath);
  }

  List<Map<String, String>> getLikedSounds() {
    return sounds.where((sound) => isLiked(sound['soundPath'])).toList();
  }
}

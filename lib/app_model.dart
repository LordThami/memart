import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'sound_data.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppModel extends ChangeNotifier {
  static const String LIKED_SOUND_PATH_KEY = 'likedSoundPaths';
  static const String SELECTED_SOUND_PATH_KEY = 'selectedSoundPath';
  static const String SUGGESTED_SOUNDS_KEY = 'suggestedSounds';
  SharedPreferences _prefs;
  List<String> _likedSoundPaths = [];
  List<String> _suggestedSounds;
  AudioCache _audioCache;
  AudioPlayer _player;
  String selectedSoundPath;
  bool isPlaying = false;
  List<Map<String, String>> sounds;
  Map<String, Map<String, String>> _soundLookup;

  AppModel() {
    _audioCache = AudioCache(prefix: 'sounds/');
    sounds = soundData;

    // generate sound lookup map
    _soundLookup = Map();
    soundData.forEach((sound) => _soundLookup[sound['soundPath']] = sound);

    loadPrefs().then((_) {
      _likedSoundPaths = _prefs.getStringList(LIKED_SOUND_PATH_KEY) ?? [];
      selectedSoundPath =
          _prefs.getString(SELECTED_SOUND_PATH_KEY) ?? sounds[0]['soundPath'];
      _suggestedSounds = _prefs.getStringList(SUGGESTED_SOUNDS_KEY) ?? [];
      notifyListeners();
    });
  }

  Future<void> loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> play([String newSoundPath]) async {
    if (newSoundPath == null) return play(selectedSoundPath);
    if (selectedSoundPath != null && _player != null) await _player.stop();
    selectedSoundPath = newSoundPath;
    isPlaying = true;
    notifyListeners();
    _player = await _audioCache.play(newSoundPath);
    _player.onPlayerCompletion.listen((_) {
      isPlaying = false;
      notifyListeners();
    });
    return _prefs.setString(SELECTED_SOUND_PATH_KEY, selectedSoundPath);
  }

  Future<int> stop() async {
    isPlaying = false;
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

  bool isLiked(String soundPath) {
    return _likedSoundPaths.contains(soundPath);
  }

  List<Map<String, String>> getLikedSounds() {
    return _likedSoundPaths
        .map((soundPath) => _soundLookup[soundPath])
        .toList();
  }

  Map<String, String> getSelectedSound() {
    if (selectedSoundPath == null) return null;
    return sounds
        .firstWhere((sound) => sound['soundPath'] == selectedSoundPath);
  }

  List<Map<String, String>> getSearchResults(String input) {
    if (input.length == 0) return null;
    Set<String> resultsFileNames = Set();
    List<Map<String, String>> results = [];
    [
      {
        'searchProperty': 'title',
        'regex': r'^' + input,
      },
      {
        'searchProperty': 'title',
        'regex': r'\W' + input,
      },
      {
        'searchProperty': 'searchString',
        'regex': r'(^|\W)' + input,
      },
    ].forEach((searchRules) {
      var regex = RegExp(
        searchRules['regex'],
        caseSensitive: false,
      );

      sounds.forEach((sound) {
        var searchProperty = sound[searchRules['searchProperty']] ?? '';

        if (resultsFileNames.contains(sound['soundPath']) == false &&
            regex.hasMatch(searchProperty)) {
          results.add(sound);
          resultsFileNames.add(sound['soundPath']);
        }
      });
    });
    return results;
  }

  Future<void> share() async {
    final selectedSound = getSelectedSound();
    if (selectedSound == null) return;
    final title = selectedSound['title'];
    final ByteData bytes =
        await rootBundle.load('assets/sounds/$selectedSoundPath');
    await Share.file('Share "$title"', selectedSoundPath,
        bytes.buffer.asUint8List(), 'audio/mpeg',
        text: 'Shared with Memart.');
  }

  bool hasSuggestion(String suggestion) {
    return _suggestedSounds.contains(suggestion);
  }

  Future<bool> addSuggestion(String suggestion) async {
    if (hasSuggestion(suggestion)) return false;
    _suggestedSounds.add(suggestion);
    notifyListeners();
    final isCached =
        await _prefs.setStringList(SUGGESTED_SOUNDS_KEY, _suggestedSounds);
    if (!isCached) return false;
    final docRef = await Firestore.instance.collection('suggestions').add({
      'name': suggestion,
    });
    return docRef != null;
  }
}

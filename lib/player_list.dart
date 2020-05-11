import 'package:flutter/material.dart';
import 'package:meme_soundboard/app_model.dart';
import 'package:provider/provider.dart';
import 'only_one_pointer_recorgnizer.dart';
import 'player.dart';

class PlayerList extends StatelessWidget {
  PlayerList(this._sounds, this._keyName);

  final List<Map<String, dynamic>> _sounds;
  final String _keyName;

  @override
  Widget build(BuildContext context) {
    return OnlyOnePointerRecognizerWidget(
      child: ButtonTheme(
        buttonColor: Colors.transparent,
        textTheme: ButtonTextTheme.normal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: GridView.builder(
          itemCount: _sounds.length,
          key: PageStorageKey(_keyName),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            childAspectRatio: 1.0,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          itemBuilder: (BuildContext context, int id) {
            var sound = _sounds[id];
            return Consumer<AppModel>(
              builder: (context, model, child) {
                String soundPath = sound['soundPath'];
                bool isSelected = model.selectedSoundPath == sound['soundPath'];
                bool isPlaying = model.isPlaying;
                bool isLiked = model.isLiked(sound['soundPath']);
                return AnimatedOpacity(
                  opacity: isPlaying && !isSelected ? 0.5 : 1,
                  duration: Duration(milliseconds: 200),
                  child: Player(
                    isSelected: isSelected,
                    isPlaying: isPlaying,
                    isLiked: isLiked,
                    title: sound['title'],
                    imagePath: sound['imagePath'],
                    handlePress: () {
                      // if (isPlaying)
                      //   model.stop();
                      // else
                      model.play(soundPath);
                      FocusScope.of(context).unfocus();
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

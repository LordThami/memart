import 'package:flutter/material.dart';
import 'player_list.dart';

class FavoritesPage extends StatelessWidget {
  FavoritesPage(this._sounds, this._handleLikePress);

  final List<Map<String, String>> _sounds;
  final Function _handleLikePress;

  @override
  Widget build(BuildContext context) {
    return _sounds.length > 0
        ? PlayerList(
            _sounds,
            _handleLikePress,
            stopOnLikeTap: true,
          )
        : Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('No likes',
                      style: TextStyle(
                        fontSize: 32.0,
                      )),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    'Like a sound and it will show up here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

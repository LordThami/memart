import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_model.dart';
import 'player_list.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(builder: (context, model, child) {
      var likedSounds = model.getLikedSounds();
      return likedSounds.length > 0
          ? PlayerList(model.getLikedSounds(), 'favorites')
          : NoLikesMessage();
    });
  }
}

class NoLikesMessage extends StatelessWidget {
  const NoLikesMessage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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

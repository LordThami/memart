import 'package:flutter/material.dart';
import 'custom_icons_icons.dart';

class Player extends StatelessWidget {
  Player({
    @required this.isPlaying,
    @required this.isLiked,
    @required this.title,
    @required this.handlePress,
    @required this.handleLikePress,
    @required this.imagePath,
  });

  final bool isPlaying;
  final bool isLiked;
  final String title;
  final Function handlePress;
  final Function handleLikePress;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      clipBehavior: Clip.antiAlias,
      elevation: 10,
      padding: EdgeInsets.all(0),
      onPressed: handlePress,
      child: Stack(
        children: <Widget>[
          Image(
            width: double.infinity,
            fit: BoxFit.cover,
            image: AssetImage('assets/images/$imagePath'),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 1.0],
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: isPlaying ? 1 : 0,
            duration: Duration(milliseconds: 100),
            child: SizedBox.expand(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  border: Border.all(
                    width: 5,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: isPlaying ? 1 : 0,
            duration: Duration(milliseconds: 100),
            child: Align(
              alignment: Alignment(0, -0.1),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(
                  Icons.volume_up,
                  size: 60,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    CustomIcons.heart,
                    color: isLiked ? Colors.pink : Colors.black26,
                    size: 24.0,
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.all(12.0),
                  icon: Icon(
                    CustomIcons.heart_empty,
                    color: isLiked ? Colors.white : Colors.white70,
                    size: 24.0,
                  ),
                  onPressed: handleLikePress,
                ),
              ],
            ),
          ),
        ].where((o) => o != null).toList(),
      ),
    );
  }
}

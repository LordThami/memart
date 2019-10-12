import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  Player({
    @required this.isSelected,
    @required this.isPlaying,
    @required this.isLiked,
    @required this.title,
    @required this.handlePress,
    @required this.handleLikePress,
    @required this.imagePath,
  });

  final bool isSelected;
  final bool isPlaying;
  final bool isLiked;
  final String title;
  final Function handlePress;
  final Function handleLikePress;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 2,
      padding: EdgeInsets.all(0),
      onPressed: handlePress,
      child: Stack(
        children: <Widget>[
          AnimatedOpacity(
            opacity: isSelected ? 1 : 0,
            duration: Duration(milliseconds: 300),
            child: SizedBox.expand(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  boxShadow: [
                    BoxShadow(color: Colors.white, spreadRadius: 4.0),
                  ],
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image(
              width: double.infinity,
              fit: BoxFit.cover,
              image: AssetImage('assets/images/$imagePath'),
            ),
          ),
        ],
      ),
    );
  }
}

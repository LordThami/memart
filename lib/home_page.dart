import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_model.dart';
import 'player_list.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, model, child) => PlayerList(model.sounds, 'home'),
    );
  }
}

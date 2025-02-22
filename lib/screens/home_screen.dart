import 'package:flutter/material.dart';
import 'package:balde_audio/widgets/song_list.dart';
import 'package:balde_audio/widgets/mini_player.dart';
import 'package:balde_audio/widgets/theme_switch.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balde Player'),
        actions: const [ThemeSwitch()],
      ),
      body: Column(children: const [Expanded(child: SongList()), MiniPlayer()]),
    );
  }
}

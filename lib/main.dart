import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:wakelock/wakelock.dart';
import 'dart:io';

void main() {
  initMeeduPlayer(
    iosUseMediaKit: Platform.isIOS,
    androidUseMediaKit: Platform.isAndroid,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Player(),
    );
  }
}

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  MeeduPlayerController pl = MeeduPlayerController(
    responsive: Responsive(
      maxButtonsSize: 42,
    ),
  );

  void getData() async {
    Wakelock.enable();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pl.setDataSource(
        DataSource(
          type: DataSourceType.network,
          source:
              "https://user-images.githubusercontent.com/25157308/242995835-5d03235d-5368-4f08-a149-c185ebf757b5.mov",
        ),
        autoplay: true,
      );
    });
    //
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    getData();
  }

  @override
  void dispose() {
    pl.dispose();
    Wakelock.disable();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              right: 0,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: MeeduVideoPlayer(
                  controller: pl,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

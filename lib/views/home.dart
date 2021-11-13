import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:li_music/controller/page_manager.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late PlayerManager _playerManager;

  @override
  void initState() {
    super.initState();
    _playerManager = PlayerManager();
  }

  @override
  void dispose() {
    super.dispose();
    _playerManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LI Music'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Spacer(),
            ValueListenableBuilder<ProgressBarState>(
                valueListenable: _playerManager.progressNotifier,
                builder: (_, value, __) {
                  return ProgressBar(
                    progress: value.current,
                    buffered: value.buffered,
                    total: value.total,
                    onSeek: _playerManager.seek,
                  );
                }),
            ValueListenableBuilder<ButtonState>(
                valueListenable: _playerManager.buttonStateNotifier,
                builder: (_, value, __) {
                  switch (value) {
                    case ButtonState.loading:
                      return Container(
                          width: 32,
                          height: 32,
                          margin: const EdgeInsets.all(8.0),
                          child: const IconButton(
                            onPressed: null,
                            icon: Icon(Icons.play_arrow),
                          ));
                    case ButtonState.paused:
                      return Container(
                          width: 32,
                          height: 32,
                          margin: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: () {
                              _playerManager.play();
                            },
                            icon: const Icon(Icons.play_arrow),
                          ));

                    case ButtonState.playing:
                      return Container(
                          width: 32,
                          height: 32,
                          margin: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: () {
                              _playerManager.pause();
                            },
                            icon: const Icon(Icons.pause),
                          ));
                  }
                })
          ],
        ),
      ),
    );
  }
}

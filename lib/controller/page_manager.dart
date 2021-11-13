import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerManager {
  static const url =
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3';
  late AudioPlayer _audioPlayer;

  PlayerManager() {
    _init();
  }

  void _init() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer.setUrl(url);

    //Streams
    _audioPlayer.playerStateStream.listen((playerState) {
      print("TAG: $playerState");
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonStateNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonStateNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        buttonStateNotifier.value = ButtonState.playing;
      } else {
        // completed
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });

    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
          current: position,
          buffered: oldState.buffered,
          total: oldState.total);
    });

    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void dispose() {
    _audioPlayer.dispose();
  }

  final progressNotifier = ValueNotifier<ProgressBarState>(ProgressBarState(
      current: Duration.zero, buffered: Duration.zero, total: Duration.zero));

  final buttonStateNotifier = ValueNotifier<ButtonState>(ButtonState.paused);
}

class ProgressBarState {
  final Duration current;
  final Duration buffered;
  final Duration total;

  ProgressBarState(
      {required this.current, required this.buffered, required this.total});
}

enum ButtonState { paused, playing, loading }

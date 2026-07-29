import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerService extends ChangeNotifier {
  AudioPlayerService._() {
    player.playerStateStream.listen((_) {
      notifyListeners();
    });
  }

  static final AudioPlayerService instance = AudioPlayerService._();

  final AudioPlayer player = AudioPlayer();

  Map<String, dynamic>? currentSong;

  bool get isPlaying => player.playing;

  Future<void> playSong(Map<String, dynamic> song) async {
    // Agar same song pause hai to resume kar do
    if (currentSong != null &&
        currentSong!["id"] == song["id"] &&
        !player.playing) {
      await player.play();
      return;
    }

    currentSong = song;

    final url = song["downloadUrl"].last["url"];
    await player.setUrl(url);
    await player.play();

    notifyListeners();
  }

  Future<void> pauseSong() async {
    await player.pause();
  }

  Future<void> resumeSong() async {
    await player.play();
  }

  void disposePlayer() {
    player.dispose();
  }
}

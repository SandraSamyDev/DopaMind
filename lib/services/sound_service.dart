import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final AudioPlayer player = AudioPlayer();

  Future<void> startSound(String path) async {
    await player.setReleaseMode(ReleaseMode.loop);

    await player.play(AssetSource(path));
  }

  Future<void> pauseSound() async {
    await player.pause();
  }

  Future<void> resumeSound() async {
    await player.resume();
  }

  Future<void> stopSound() async {
    await player.stop();
  }

  Future<void> setVolume(double volume) async {
    await player.setVolume(volume);
  }
}

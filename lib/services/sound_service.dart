import 'package:audioplayers/audioplayers.dart';

class SoundService {
  SoundService._() {
    player.setAudioContext(
      AudioContextConfig(
        focus: AudioContextConfigFocus.mixWithOthers,
        stayAwake: true,
      ).build(),
    );

    completionPlayer.setAudioContext(
      AudioContextConfig(
        focus: AudioContextConfigFocus.mixWithOthers,
        stayAwake: true,
      ).build(),
    );
  }

  static final SoundService _instance = SoundService._();

  factory SoundService() => _instance;

  final AudioPlayer player = AudioPlayer();

  final AudioPlayer completionPlayer = AudioPlayer();

  Future<void> startSound(String path) async {
    print("PLAYING: $path");

    await player.setReleaseMode(ReleaseMode.loop);
    await player.play(AssetSource(path));

    print("PLAYER STATE: ${player.state}");
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

  Future<void> playCompletionSound() async {
    await completionPlayer.setReleaseMode(ReleaseMode.loop);

    await completionPlayer.play(
      AssetSource("sounds/notification.mp3"),
    );
  }

  Future<void> stopCompletionSound() async {
    await completionPlayer.stop();
  }
}
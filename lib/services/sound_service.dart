

import 'package:audioplayers/audioplayers.dart';

class SoundService {

final player = AudioPlayer();

void startSound(url) async{

await player.play(DeviceFileSource(url));
}
void pauseSound() async{

  await player.pause();
}
void resumeSound() async{
    await player.resume();
}
void stopSound() async{
    await player.stop();
}
}
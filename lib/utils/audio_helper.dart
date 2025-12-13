import 'package:just_audio/just_audio.dart';

class AudioHelper {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playUrl(String url) async {
    try {
      await _player.setUrl(url);
      await _player.play();
    } catch (_) {}
  }

  Future<void> stop() async => await _player.stop();

  Future<void> dispose() async => await _player.dispose();
}

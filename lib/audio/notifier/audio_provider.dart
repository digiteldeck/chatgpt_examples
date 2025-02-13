import 'package:chatgpt_examples/audio/models/audio_transcription.dart';
import 'package:chatgpt_examples/audio/repo/audio_repo.dart';
import 'package:chatgpt_examples/shared/api_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioProvider = StateNotifierProvider<AudioProvider, AsyncValue>((ref) {
  return AudioProvider(repo: AudioRepo());
});

class AudioProvider extends StateNotifier<AsyncValue<AudioTranscription>> {
  AudioProvider({required this.repo})
      : super(AsyncValue.data(AudioTranscription(text: "")));

  AudioRepo repo;

  convertAudioToText(String asset) async {
    state = const AsyncValue.loading();
    try {
      AudioTranscription transcription = await repo.audioToText(asset);
      var newState = AsyncValue.data(transcription);
      state = newState;
    } on ApiException catch (e) {
      StackTrace st = StackTrace.fromString(e.message);
      state = AsyncValue.error(e.message, st);
    } catch (e) {
      StackTrace st = StackTrace.fromString(e.toString());
      state = AsyncValue.error(e, st);
    }
  }
}

import 'package:chatgpt_examples/audio/models/audio_transcription.dart';
import 'package:chatgpt_examples/audio/notifier/audio_provider.dart';
import 'package:chatgpt_examples/shared/widgets/error_text.dart';
import 'package:chatgpt_examples/shared/widgets/inline_scale_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpeechToText extends ConsumerStatefulWidget {
  const SpeechToText({Key? key}) : super(key: key);

  @override
  _SpeechToTextState createState() => _SpeechToTextState();
}

class _SpeechToTextState extends ConsumerState<SpeechToText> {
  @override
  Widget build(BuildContext context) {
    var currentState = ref.watch(audioProvider);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  int result = substractItems(2, 3);
                  print("Result: $result");
                  ref
                      .read(audioProvider.notifier)
                      .convertAudioToText('assets/audio/audio1.mp3');
                },
                child: const Text("Pick Audio"),
              ),
              const SizedBox(
                height: 20,
              ),
              currentState.when(
                data: (data) {
                  AudioTranscription transcription = data;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      transcription.text ?? "Please select file first",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  );
                },
                error: (error, stackTrace) => ErrorText(
                  errorText: error.toString(),
                ),
                loading: () => const InlineScaleLoader(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  substractItems(int a, int b) {
    return a + b;
  }
}

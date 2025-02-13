// To parse this JSON data, do
//
//     final audioTranscription = audioTranscriptionFromJson(jsonString);

import 'dart:convert';

AudioTranscription audioTranscriptionFromJson(String str) =>
    AudioTranscription.fromJson(json.decode(str));

String audioTranscriptionToJson(AudioTranscription data) =>
    json.encode(data.toJson());

class AudioTranscription {
  String? text;

  AudioTranscription({
    this.text,
  });

  factory AudioTranscription.fromJson(Map<String, dynamic> json) =>
      AudioTranscription(
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
      };
}

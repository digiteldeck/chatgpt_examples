import 'dart:developer';
import 'dart:io';

import 'package:chatgpt_examples/audio/models/audio_transcription.dart';
import 'package:chatgpt_examples/shared/api_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';

class AudioRepo {
  String secretKey = "";
  AudioRepo() {
    getSecretKey();
  }

  getSecretKey() async {
    secretKey = dotenv.env['secret_key'] ?? "";
    log("Secret Key: $secretKey");
  }

  Future<String> loadFileFromAsset(String asset) async {
    ByteData byteData = await rootBundle.load(asset);
    List<int> audioBytes = byteData.buffer.asUint8List();

    String fileName = asset.split("/")[asset.split("/").length - 1];
    // Save the audio file to a temporary directory
    return await saveToTempFile(
      audioBytes,
      fileName,
    );
  }

  Future<String> saveToTempFile(List<int> bytes, String fileName) async {
    Directory tempDir = await Directory.systemTemp.createTemp('temp_dir');
    String filePath = '${tempDir.path}/$fileName';
    File file = File(filePath);
    await file.writeAsBytes(bytes);
    return filePath;
  }

  Future<dynamic> audioToText(String asset) async {
    // Load the audio file from assets
    // String tempPath = await loadFileFromAsset(asset);

    // Load the audio file from assets
    ByteData byteData = await rootBundle.load('assets/audio/audio1.mp3');
    List<int> audioBytes = byteData.buffer.asUint8List();

    // Save the audio file to a temporary directory
    Directory tempDir = (await getExternalCacheDirectories())![0];

    File tempFile = File('${tempDir.path}/audio1.mp3');
    await tempFile.writeAsBytes(audioBytes);
    bool isExist = await tempFile.exists();

    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(tempFile.path),
      'model': 'whisper-1',
    });

    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $secretKey';
    dio.options.headers['Content-Type'] = 'multipart/form-data';

    try {
      Response response = await dio.post(
        'https://api.openai.com/v1/audio/transcriptions',
        data: formData,
      );

      log(response.data);
      return AudioTranscription.fromJson(response.data);
    } on DioException catch (e) {
      log('Error: ${e.message}');
      log("Error: ${e.response}");
      throw ApiException(message: e.message ?? "Something went wrong");
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }
}

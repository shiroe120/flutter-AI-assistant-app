import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeechToTextHelper {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  late String _recordPath;

  Future<void> startListening() async {
    await Permission.microphone.request();

    final dir = await getTemporaryDirectory();
    _recordPath = '${dir.path}/record.wav';

    await _recorder.openRecorder();
    await _recorder.startRecorder(
      toFile: _recordPath,
      codec: Codec.pcm16,
      sampleRate: 16000,
      numChannels: 1,
    );
  }

  Future<void> cancel() async {
    await _recorder.stopRecorder();
    await _recorder.closeRecorder();
  }

  Future<String> stopListeningAndTranscribe() async {
    await _recorder.stopRecorder();
    await _recorder.closeRecorder();

    // 读取音频文件并转 base64
    final file = File(_recordPath);
    if (!await file.exists() || (await file.length()) == 0) {
      print("录音文件不存在或为空: $_recordPath");
      return "录音失败";
    }
    final bytes = await file.readAsBytes();
    final base64Audio = base64Encode(bytes);

    try {
      final dio = Dio();
      //TODO 仅仅调试时使用明文key
      final ak = "1P0VnR2zkpHj9pDGrR1zEBCb";
      final sk = "yZPutcQprDH1JkID4ufgS5UldkQRgzim";

      //获取token
      final tokenResponse = await dio.post(
        'https://aip.baidubce.com/oauth/2.0/token',
        queryParameters: {
          "grant_type": "client_credentials",
          "client_id": ak,
          "client_secret": sk,
        },
      );

      final accessToken = tokenResponse.data["access_token"];
      if (accessToken == null) {
        print("获取 token 失败");
        return "获取 token 失败";
      }

      //调用token
      final response = await dio.post(
        'http://vop.baidu.com/server_api',
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: {
          "format": "pcm",
          "rate": 16000,
          "channel": 1,
          "token": accessToken, // <<< 替换这里
          "cuid": "flutter_app",
          "len": bytes.length,
          "speech": base64Audio,
        },
      );

      final result = response.data;
      if (result["err_no"] == 0 && result["result"] != null) {
        return result["result"][0];
      } else {
        print("识别失败: ${result["err_msg"]}");
        return "识别失败${result["err_msg"]}";
      }
    } catch (e) {
      print("请求出错: $e");
      return "识别出错$e";
    }
  }
}

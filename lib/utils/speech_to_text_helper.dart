import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpeechToTextHelper {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  late String _recordPath;
  bool _isRecorderInited = false;

  /// 初始化 Recorder
  Future<void> initRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      print("麦克风权限未授权");
      throw RecordingPermissionException('Microphone permission not granted');
    }

    await _recorder.openRecorder();
    _isRecorderInited = true;
    print("Recorder 已初始化: $_isRecorderInited");
  }

  /// 开始录音
  Future<void> startListening() async {
    if (!_isRecorderInited) await initRecorder();

    final dir = await getTemporaryDirectory();
    _recordPath = '${dir.path}/record.aac';
    print("录音文件路径: $_recordPath");

    try {
      bool supported = await _recorder.isEncoderSupported(Codec.pcm16WAV);
      print("是否支持 PCM WAV: $supported");
      await _recorder.startRecorder(
        toFile: _recordPath,
        codec: Codec.aacMP4,
        audioSource: AudioSource.microphone,
      );
      print("开始录音成功");
    } catch (e) {
      print("startRecorder 报错: $e");
    }
  }

  /// 停止录音
  Future<void> stopListening() async {
    if (!_recorder.isRecording) {
      print("Recorder 未在录音");
      return;
    }
    await _recorder.stopRecorder();
    print("停止录音完成");

    final file = File(_recordPath);
    print("录音文件是否存在: ${file.existsSync()}, 大小: ${file.lengthSync()} 字节");
  }

  /// 停止录音并上传到百度语音识别
  Future<String> stopListeningAndTranscribe() async {
    if (_recorder.isRecording) await _recorder.stopRecorder();

    final file = File(_recordPath);
    if (!await file.exists() || await file.length() == 0) {
      print("录音文件不存在或为空: $_recordPath");
      return "录音失败";
    }

    final bytes = await file.readAsBytes();
    final base64Audio = base64Encode(bytes);

    try {
      // 获取百度语音识别的 SecretKey 和 AccessKey
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? ak = prefs.getString('baiduAccessKey');
      String? sk = prefs.getString('baiduSecretKey');
      if (ak == null || sk == null || ak.isEmpty || sk.isEmpty) {
        return "请先在设置页面配置百度云的 Access Key 和 Secret Key";
      }
      final dio = Dio();

      // 获取 token
      final tokenResponse = await dio.post(
        'https://aip.baidubce.com/oauth/2.0/token',
        queryParameters: {
          "grant_type": "client_credentials",
          "client_id": ak,
          "client_secret": sk,
        },
      );

      final accessToken = tokenResponse.data["access_token"];
      if (accessToken == null) return "获取 token 失败";

      // 调用百度语音识别
      final response = await dio.post(
        'http://vop.baidu.com/server_api',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {
          "format": "m4a",
          "rate": 16000,
          "channel": 1,
          "token": accessToken,
          "cuid": "flutter_app",
          "len": bytes.length,
          "speech": base64Audio,
        },
      );

      final result = response.data;
      if (result["err_no"] == 0 && result["result"] != null) {
        return result["result"][0];
      } else {
        print("识别失败: ${result["err_msg"]}, 文件大小: ${bytes.length}");
        return "识别失败: ${result["err_msg"]}, 错误码: ${result["err_no"]}";
      }
    } catch (e) {
      print("请求出错: $e");
      return "识别出错 $e";
    }
  }

  /// 关闭 Recorder
  Future<void> dispose() async {
    await _recorder.closeRecorder();
    _isRecorderInited = false;
  }
}
